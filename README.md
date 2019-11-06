This profile provides a base configuration for PingFederate.

It is designed to be used in conjunction with the Baseline Pingdirectory image \ Profile.

## Deployment
* Copy the `docker-compose.yaml` and `env_vars` files to a folder
* Modify the `env_vars` file to match your environment
* Launch the stack with `docker-compose up -d`

## Configuration

To access the Admin UI for PF go to:
https://{{PF_HOSTNAME}}:9999/pingfederate

Credentials:  
`Administrator` / `2FederateM0re`

This configuration includes:

### Adapters
* HTML Form
* HTML Form with LIP
* PingID

### PingID - Special Considerations
The PingID adapter uses the secrets from your PingID tenant to create the proper calls to the service. As such, storing those values in a public location, such as GitHub, sound be considered **risky**.

For this Profile, you can place the `base64` encoded text from a `pingid.properties` file that will be placed into the PingID Adapter settings 

### Authentication Policy
Extended Property Selector
  * Basic (HTML Form)
  * Enhanced (HTML Form with LIP)
  * MFA (Enhanced --> PingID)

The Authentication Experience is controlled by setting the `Extended Properties` on the Application.  

Any other value will trigger the Authentication API that is mapped to the AuthN API Explorer app.

### Extended Properties
* `Basic` (Plain HTML Form)
* `Enhanced` (HTML Form with LIP -- Google & Facebook buttons [not configured])
* `MFA` (HTML Form with LIP --> PingID adapter)

### Applications
Two applications are pre-wired:

**SAML:**  
https://${PF_BASE_URL}/idp/startSSO.ping?PartnerSpId=Dummy-SAML

**OAuth \ OIDC:**  
`client_id` == PingLogon

**Introspect**  
`client_id` == PingIntrospect  
`client_secret` == 2FederateM0re

### Users
If you are using the BASELINE PingDirectory image, the credentials you can use for these applications are:

`user.[0-4]` / `2FederateM0re`

