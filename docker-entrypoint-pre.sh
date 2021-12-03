#bin/bash

FILE_CONFIG=/var/www/html/config/config_db.php

#criando arquivo de conexao manualmente
cat > $FILE_CONFIG <<EOF
<?php
class DB extends DBmysql {
   public \$dbhost     = '$MYSQL_HOST';
   public \$dbuser     = '$MYSQL_USER';
   public \$dbpassword = '$MYSQL_PASSWORD';
   public \$dbdefault  = '$MYSQL_DATABASE';
}
EOF

#instalando tabelas
count_tables=$(php /var/www/html/scripts/checkinstall.php)
if [ "$count_tables" = "0" ]; then
    echo "banco de dados vazio, instalando tabelas..."
    #instalando via command line tool CLI
    #https://glpi-install.readthedocs.io/en/latest/command-line.html#cdline-install
    php /var/www/html/scripts/cliinstall.php -h $MYSQL_HOST -d $MYSQL_DATABASE -u $MYSQL_USER -p $MYSQL_PASSWORD -l $LANG --force
else
    echo "banco de dados ja iniciado..."
fi