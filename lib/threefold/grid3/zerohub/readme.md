# ZeroHub

This is a SAL for the ZeroHub

The default hub we connect to is https://hub.grid.tf/

### for developers

more info see https://github.com/threefoldtech/0-hub#public-api-endpoints-no-authentication-needed


> TODO: implement each endpoint on the zerohub here at client


## Hub Authorization
ZeroHub authorized enpoints can be accessed with exporting a jwt in env vars. to do so:
- go to https://hub.grid.tf, and on the login section try `Generate API Token`
- copy the token you got and `export HUB_JWT=<jwt>`