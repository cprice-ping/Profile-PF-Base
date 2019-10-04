This profile provides a base configuration for PingFederate.

It is designed to be used in conjunction with the Baseline Pingdirectory image \ Profile.

## Configuration

To access the Admin UI for PF go to:
https://{{PF_BASE_URL}}:9999/pingfederate

Credentials:  
`Administrator` / `2FederateM0re`

This configuration includes:

### Adapters
* HTML Form
* HTML Form with LIP
* PingID

### Authentication Policy
Extended Property Selector
  * Basic (HTML Form)
  * Enhanced (HTML Form with LIP)
  * MFA (Enhanced --> PingID)

The Authentication Experience is controlled by setting the `Extended Properties` on the Application.

### Extended Properties
* `Basic` (Plain HTML Form)
* `Enhanced` (HTML Form with LIP -- Google & Facebook buttons [not configured])
* `MFA` (HTML Form with LIP --> PingID adapter [not configured])

### Applications
Two applications are pre-wired:

**SAML:**  
https://${pf_base_url}/idp/startSSO.ping?PartnerSpId=Dummy-SAML

**OAuth \ OIDC:**  
`client_id` == PingLogon

**Introspect**  
`client_id` == PingIntrospect  
`client_secret` == 2FederateM0re

### Users
If you are using the BASELINE PingDirectory image, the credentials you can use for these applications are:

`user.[0-4]` / `2FederateM0re`

