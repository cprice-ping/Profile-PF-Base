This profile provides a common baseline configuration for PingFederate.

It uses an API injection to build a common base of PF  
**Note:** This relies on Use Case: PD - Base, and needs additional Use Case APIs to make this useful.

API Collections (Required): 
* Use Case: PD - Baseline
 * [Documentation]()
 * [Collection](https://www.getpostman.com/collections/251528ba1c88b823da85)
* Use Case: PF - Initial
 * [Collection](https://www.getpostman.com/collections/f8e24e4e53f7059beb10)

## Configuration

To access the Admin UI for PF go to:  
https://{{PF_HOSTNAME}}:9999/pingfederate

Credentials (LDAP):  
`Administrator` / `2FederateM0re`

This configuration includes:

### PD for Configuration
* OAuth Clients
* OAuth Grants
* AuthN Sessions
* Admin Console AuthN

### IdP Config
* Password Credential Validator -- PD
* Add Extended Property (`authnExp`)
* Add Extended Property Selector (`Basic` \ `MFA` \ `Passwordless`)
* Add Default Policy Contract (`subject` \ `ImmutableID` \ `mail`)
* Enable Global IDP Sessions

### AS Config
* Add OIDC Scopes
* Add JWT Token Manager
* Add Grant Mapping to Policy Contract
* Add Token Mapping to Policy Contract
* Add OIDC Policy

This Server Profile is built to inject non-API changes into the PingFederate container:

[run.properties](pingfed/instance/bin/run.properties.subst)
* `pf.console.authentication=LDAP`
* `pf.admin.api.authentication = native`
* `pf.provisioner.mode=STANDALONE`

[ldap.properties](pingfed/instance/bin/ldap.properties.subst)
* `ldap.password=${PF_USER_PWD}`

[log4j2.xml](/pingfed/instance/server/default/conf/log4j2.subst)
* `<Logger name="com.pingidentity" level="${PF_LOG_LEVEL}" />`
* `<Logger name="org.sourceid" level="${PF_LOG_LEVEL}" />`

[Deploy Folder](/pingfed/instance/server/default/deploy)
* Agentless IK v1.5.1

[50-before-post-start.sh](pingfed/hooks/50-before-post-start.sh) 
* Since you can't modify `hivemodule.xml` with the Admin API, there's a hook script that is called to do the changes:
 * LDAP (PD) - OAuth Client
 * LDAP (PD) - OAuth Access Grants
 * LDAP (PD) - AuthN Sessions

---
**NOTE:** This will break existing Profiles based on `Profile-PF-Base` -- to resolve, you can:

* Point the Profile to the `pre-api` branch:
```
    environment:
    - SERVER_PROFILE_URL=https://github.com/cprice-ping/Profile-PF-Base.git
    - SERVER_PROFILE_PATH=pingfed
    - SERVER_PROFILE_BRANCH=pre-api
```

* Add the API Calls as a service to your stack:

```
  pingconfig:
    image: pricecs/pingconfigurator
    environment:
            # Collections: Use Case: PD - GTE Baseline --> Use Case: PF Initial
      - COLLECTIONS=https://www.getpostman.com/collections/251528ba1c88b823da85,https://www.getpostman.com/collections/f8e24e4e53f7059beb10
    volumes: 
      # An environment file should be injected into the image - this file should contain your specfic info and secrets
      - ./postman_vars.json:/usr/src/app/postman_vars.json
    networks:
      - pingnet
```
---

## Deployment
* Copy the `docker-compose.yaml`, `env_vars.sample` and `postman_vars.json.sample` files to a folder
* Rename files to `env_vars` and `postman_vars.json`
* Modify the `env_vars` file to match your environment
* Modify the `postman.json` file to match your environment
* Launch the stack with `docker-compose up -d`
* Logs for the stack can be watched with `docker-compose logs -f`
* Logs for individual services can be watched with `docker-compose logs -f {service}`






// Move all the below to proper Use Case documentation
### Adapters
* HTML Form
* Identifier-First (Passwordless)
* PingID

### PingID - Special Considerations
The PingID adapter uses the secrets from your PingID tenant to create the proper calls to the service. As such, storing those values in a public location, such as GitHub, should be considered **risky**.

For this Profile, you can place the text from a `pingid.properties` file into `postman_vars.json`. The API calls will base64 encode and inject into the PingID Adapter and HTML Form (for Self-Service Password Reset)

### Authentication Policy
Extended Property Selector
  * Basic (HTML Form)
  * MFA (Enhanced --> PingID)
  * Passwordless (ID-First --> PingID)

The Authentication Experience is controlled by setting the `Extended Properties` on the Application.   

### Extended Properties
* `Basic` (Plain HTML Form) *default*
* `MFA` (HTML Form with LIP --> PingID adapter)
* `Passwordless` (ID-First --> PingID)
* _Anything Else_ (Plain HTML Form)

### Applications
Two applications are pre-wired:

**SAML:**  
https://`${PF_BASE_URL}`/idp/startSSO.ping?PartnerSpId=Dummy-SAML

**OAuth \ OIDC:**  
`Issuer` == `${PF_BASE_URL}`  

**OIDC Logon**
`client_id` == PingLogon  

**Introspect**  
`client_id` == PingIntrospect  
`client_secret` == 2FederateM0re

### Users
If you are using the BASELINE PingDirectory image, the credentials you can use for these applications are:

`user.[0-4]` / `2FederateM0re`