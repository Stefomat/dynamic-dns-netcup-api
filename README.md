# Dynamic DNS client for netcup DNS API
A simple dynamic DNS client written in PHP for use with the netcup DNS API.

## Description
This repository hosts the source code for a Docker container that can automatically update DNS records with the netcup DNS API.  
The main component is from [stecklars dynamic-dns-netcup-api](https://github.com/stecklars/dynamic-dns-netcup-api).


## Requirements
* Be a netcup customer: https://www.netcup.de – or for international customers: https://www.netcup.eu
  * You don't have to be a domain reseller to use the necessary functions for this client – every customer with a domain may use it.
* netcup API key and API password, which can be created within your CCP at https://www.customercontrolpanel.de
* A domain :wink:

## Features
### Implemented
* All necessary API functions for DNS actions implemented (REST API)
* Determines correct public IP address, uses fallback API for determining the IP address, in case main API does return invalid / no IP
* Automatically retries API requests on errors
* IPv4 and IPv6 Support (can be individually enabled / disabled)
* Update everything you want in one go: Every combination of domains, subdomains, domain root, and domain wildcard is possible
* Creation of DNS record, if it doesn't already exist
* If configured, lowers TTL to 300 seconds for the domain on each run, if necessary

### Missing
* Caching the IP provided to netcup DNS, to avoid running into (currently extremely tolerant) rate limits in the DNS API
* Possible to manually provide IPv4 / IPv6 address to set as a CLI option (can't use that in container yet)

## Setup
The container needs a few configuration parameters. These are:

* `CUSTOMERNR`      - Your netcup customer number  
* `APIPASSWORD`     - Your API-Password (you can generate it in your CCP)  
* `APIKEY`          - Your API-Key (you can generate it in your CCP)  
* `DOMAINLIST`      - Define domains and subdomains which should be used for dynamic DNS in the following format:  
                    `domain.tld: host1, host2, host3; domain2.tld: host1, host4, *, @`  
                    Start with the domain (without subdomain), add ':' after the domain, then add as many subdomains as you want, seperated by ','.
                    To add another domain, finish with ';'.
                    Whitespace (spaces and newlines) are ignored. If you have a very complicated configuration, you may want to use multiple lines. Feel free to do so!
                    If one of the subdomains does not exist, the script will create them for you.  
                    Subdomain configuration: Use '@' for the domain without subdomain. Use '*' for wildcard: All subdomains (except ones already defined in DNS).  
* `USE_IPV4`        - If set to true, the script will check for your public IPv4 address and add it as an A-Record / change an existing A-Record for the host.  
                    You may want to deactivate this, for example, when using a carrier grade NAT (CGNAT).  
                    Most likely though, you should keep this active, unless you know otherwise.  
* `USE_IPV6`        - If set to true, the script will check for your public IPv6 address too and add it as an AAAA-Record / change an existing AAAA-Record for the host.  
                    Activate this only if you have IPv6 connectivity, or you *WILL* get errors.  
* `CHANGE_TTL`      - If set to true, this will change TTL to 300 seconds on every run if necessary.  
* `CRONTAB`         - Optionally you can set your own interval, see [https://crontab.guru/](https://crontab.guru/) for syntax. If you don't set this option, it will run every 5 minutes.  

## Usage
Start the container with the following `docker run` command:  
```bash
docker run -d \
    -e CUSTOMERNR="12345" \
    -e APIPASSWORD="abcdefghijklmnopqrstuvwxyz" \
    -e APIKEY="abcdefghijklmnopqrstuvwxyz" \
    -e DOMAINLIST="myfirstdomain.com: server, dddns; myseconddomain.com: @, *, some-subdomain" \
    -e USE_IPV4="true" \
    -e USE_IPV6="false" \
    -e CHANGE_TTL="true" \
    -e CRONTAB="*/5 * * * *" \
    ghcr.io/stefomat/dynamic-dns-netcup-api:master \
```
Use the "master" tag for the latest version, that's the GitHub branch from which the Docker images will be built.

You can also run it as a `docker-compose` setup.

```yml
---
version: "2"

services:
  dynamic-dns-netcup-api:
    image: ghcr.io/stefomat/dynamic-dns-netcup-api:master
    container_name: dynamic-dns-netcup-api
    environment:
      CUSTOMERNR: '12345'
      APIKEY: 'abcdefghijklmnopqrstuvwxyz'
      APIPASSWORD: 'abcdefghijklmnopqrstuvwxyz'
      DOMAINLIST: 'myfirstdomain.com: server, dddns; myseconddomain.com: @, *, some-subdomain'
      USE_IPV4: 'true'
      USE_IPV6: 'false'
      CHANGE_TTL: 'true'
      CRONTAB: '*/5 * * * *'
    restart: unless-stopped
```

## Notes
Open TODOs for future improvements:
- [ ] Allow using the CLI options, that the script offers.
