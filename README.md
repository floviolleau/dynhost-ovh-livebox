# Dynhost OVH

Script to update periodically your OVH DNS via DynHost and use the Livebox to retrieve the public IP

## OVH user creation.

To use that script, you have to set a login and a password. This login and password have to be created by going in the OVH manager. Chose your domain name section, and move to the dyndns tab.

Next move to manage access.

![ovh-1](https://raw.githubusercontent.com/floviolleau/dynhost-ovh-livebox/master/docs/images/ovh-1.png)

Next create an id.

![ovh-2](https://raw.githubusercontent.com/floviolleau/dynhost-ovh-livebox/master/docs/images/ovh-2.png)

Login use in the script will be: domain-name.fr-[login_you_created]

Password use in the script will the one you chose in that screen.

![ovh-3](https://raw.githubusercontent.com/floviolleau/dynhost-ovh-livebox/master/docs/images/ovh-3.png)

## Cron

Use with cron to launch periodicaly (every two minutes)

```
crontab -e
*/2 * * * * /usr/local/dynhost/dynhost
```

## Config file

You can use the sample config file given (dynhost.sample.cfg). Rename it to dynhost.cfg and change the variables to meet your own parameters. Use cron this way.

```
crontab -e
*/2 * * * * /usr/local/dynhost/dynhost /usr/local/dynhost/dynhost.cfg
```
