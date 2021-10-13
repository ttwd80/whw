# whw

What happens when you type `www.github.com` in the browser and press enter.

## Steps

### DNS resolution

1. The name `www.github.com` maps to an IP address on the internet. In order to connect to the server, we need to resolve this to an IP address.

1. Chrome will cache DNS entries. An attempt will be made to lookup the value `www.github.com` for a cached entry. If one exists, it will be used.
