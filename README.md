This profile provides a base configuration for PingFederate.

It uses Postman to do an Admin API collection set to (almost) fully configure PF from a Ping Docker image.

The Postman collection is documented here: [PF Admin API - Base](https://documenter.getpostman.com/view/1239082/SWLh4RQB)

**Note:** In [run.properties](pingfed/instance/bin/run.properties.subst) the `pf.admin.api.authentication` setting needs to be `native` - the Postman collection will create an account that it will use.

Since you can't modify `hivemodule.xml` with the Admin API, there's a hook script that is called to do the changes:  
[50-before-post-start.sh](pingfed/hooks/50-before-post-start.sh)  
Also - since Proxy Settings can't be set by the Admin API, there's a pre-configured `sourceid-saml2-local-metadata.xml` file in the Profile. the `BaseURL` and `EntityID`s will be overwritten by the API calls. 

Changes made:
* LDAP (PD) - OAuth Client
* LDAP (PD) - OAuth Access Grants
* LDAP (PD) - AuthN Sessions

This Profile also installs the **Agentless v1.5.1 Adapter** to enable use cases like External OAuth Consent. 

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
pf-base-config:
    image: postman/newman
    command: run https://www.getpostman.com/collections/2e0df14dcf26f1ddb39a -e postman_vars.json --insecure --ignore-redirects
    volumes: 
      # An environment file should be injected into the image - this file should contain your specfic info and secrets
      - ./postman_vars.json:/etc/newman/postman_vars.json
    networks:
      - pingnet-internal
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

## Configuration

To access the Admin UI for PF go to:  
https://{{PF_HOSTNAME}}:9999/pingfederate

Credentials (LDAP):  
`Administrator` / `2FederateM0re`

**Note:** Since the Admin account is in LDAP, you *will* see the First Run Wizard in the Admin UI. You can just click `Next` through it to get to the configured server.

(This does not affect the Runtime operations)

This configuration includes:

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