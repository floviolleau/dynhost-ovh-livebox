# dynhost
Script to update periodically your OVH DNS via DynHost and use the Livebox to retrieve the public IP

## OVH user creation.
To use that script, you have to set a login and a password. This login and password have to be created by going in the OVH manager. Chose your domain name section, and move to the dyndns tab


## Cron
Use with cron to launch periodicaly

```
crontab -e
  00 * * * * /usr/local/dynhost/dynhost
```

## Config file

You can use the sample config file given (dynhost.sample.cfg). Rename it to dynhost.cfg and change the variables to meet your own parameters. Use cron this way.

```
crontab -e
  00 * * * * /usr/local/dynhost/dynhost /usr/local/dynhost/dynhost.cfg
```
