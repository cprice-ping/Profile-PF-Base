This profile provides a base configuration for PingFederate.

It uses Postman to do an Admin API collection set to fully configure PF from a Ping Docker image.

The Postman collection is documented here: [PF Admin API - Configure Server](https://documenter.getpostman.com/view/1239082/SWLh4RQB)

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
* HTML Form with LIP
* Identifier-First (Passwordless)
* PingID

### PingID - Special Considerations
The PingID adapter uses the secrets from your PingID tenant to create the proper calls to the service. As such, storing those values in a public location, such as GitHub, should be considered **risky**.

For this Profile, you can place the text from a `pingid.properties` file into `postman_vars.json`. The API calls will base64 encode and inject into the PingID Adapter and HTML Form (for Self-Service Password Reset)

### Authentication Policy
Extended Property Selector
  * Basic (HTML Form)
  * Enhanced (HTML Form with LIP)
  * MFA (Enhanced --> PingID)
  * Passwordless (ID-First --> PingID)

The Authentication Experience is controlled by setting the `Extended Properties` on the Application.   

### Extended Properties
* `Basic` (Plain HTML Form) *default*
* `Enhanced` (HTML Form with LIP --  Facebook & QR Code buttons [not configured])
* `MFA` (HTML Form with LIP --> PingID adapter)
* `Passwordless` (ID-First --> PingID)
* _Anything Else_ (AuthN API Explorer)

### Authentication API
The AuthN API is enabled -- any value in the Extended Property *other* than the above will trigger it.
* ID-First --> HTML Form with LIP --> AuthN API Explorer 

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
