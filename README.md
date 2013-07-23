chrysalis
=========

Automated build server for GitHub pull requests

## Provisioning
### Nginx
Rails user better have passwordless sudo if you wanna be able to reload nginx
Set nginx options in config/application.rb
Rails process must have write permissions on the Nginx sites-available and sites-enabled dirs
