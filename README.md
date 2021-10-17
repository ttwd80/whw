# whw

What happens when you type `www.google.com` in the browser and press enter.

## Steps

### DNS resolution

1. The name `www.google.com` maps to an IP address on the internet.
In order to connect to the server, we need to resolve this to an IP address.

1. Chrome will cache DNS entries.
An attempt will be made to lookup the value `www.google.com` for a cached entry.
If one exists, it will be used.
