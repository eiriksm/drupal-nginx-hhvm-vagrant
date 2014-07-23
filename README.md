drupal-nginx-hhvm-vagrant
=========================

Vagrant box for nginx -> hhvm -> drupal 8.

Almost works.

# Usage
`vagrant up`

# Seriously?
Sure. Ok. So here is a little more info:

- The bootstrap.sh script installs mysql, php-cli, hhvm, nginx and some other stuff via apt-get.
- Then we install composer.
- Then we install drush.
- Then we download drupal 8.
- Then we install drupal with drush.
- ...?
- Profit!

