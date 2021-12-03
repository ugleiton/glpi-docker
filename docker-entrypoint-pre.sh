#bin/bash

#instalando via command line tool CLI
#https://glpi-install.readthedocs.io/en/latest/command-line.html#cdline-install
php /var/www/html/scripts/cliinstall.php -h $MYSQL_HOST -d $MYSQL_DATABASE -u $MYSQL_USER -p $MYSQL_PASSWORD -l $LANG
