echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list
wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
apt-get update

# Set default password for mysql.
echo 'mysql-server-5.1 mysql-server/root_password password vagrant' | debconf-set-selections
echo 'mysql-server-5.1 mysql-server/root_password_again password vagrant' | debconf-set-selections

# Install some stuff.
apt-get install -y php5-cli php5-fpm php5-mysql php5-curl php5-gd mysql-server unzip vim git-core curl wget build-essential python-software-properties nginx hhvm

# Use wget to install composer, to avoid SlowTimer errors
wget -q "https://getcomposer.org/composer.phar"
mv composer.phar /usr/local/bin/composer

# Do some preperation, pretending we are the vagrant user.
HOME=/home/vagrant
sed -i '1i export PATH="$HOME/.composer/vendor/bin:$PATH"' $HOME/.bashrc
chmod uog+x /usr/local/bin/composer

# Download drush
/usr/local/bin/composer global require drush/drush:dev-master
chown vagrant /home/vagrant/.composer* -R

# Download Drupal 8
$HOME/.composer/vendor/bin/drush dl drupal-8.x
mv drupal* /usr/share/nginx/html/drupal
$HOME/.composer/vendor/bin/drush --root=/usr/share/nginx/html/drupal si --db-url=mysqli://drupal_drupal@localhost/drupal --db-su=root --db-su-pw=vagrant -y
# Make sure www-data can access the files
chown -R www-data /usr/share/nginx/html/drupal/sites/default/files
chown -R vagrant /home/vagrant/.drush/

# For some reason I have to make the first request towards the new Drupal site with php-fpm
cp /vagrant/fpm /etc/nginx/sites-available/default
/etc/init.d/php5-fpm restart
/etc/init.d/nginx restart
curl localhost
# Install our own nginx virtual host.
cp /vagrant/drupal /etc/nginx/sites-available/default
# Restart that server.
/etc/init.d/hhvm restart
/etc/init.d/nginx restart
