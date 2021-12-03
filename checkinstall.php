<?php
/**
 * Verificar se banco de dados foi iniciado
 * @author Ugleiton
 */

if (!defined('GLPI_ROOT')) {
   define('GLPI_ROOT', realpath('/var/www/html/'));
}

include_once (GLPI_ROOT . "/inc/based_config.php");
include_once (GLPI_ROOT . "/inc/db.function.php");
include_once (GLPI_CONFIG_DIR . "/config_db.php");
Config::detectRootDoc();

$GLPI = new GLPI();
$GLPI->initLogger();

$DB = new DB();
$DB->disableTableCaching(); //prevents issues on fieldExists upgrading from old versions

Session::loadLanguage();
if (!$DB->connected) {
   die("No DB connection\n");
}
$iterator = $DB->request([
   'FROM'   => 'information_schema.tables',
   'WHERE'  => ['TABLE_SCHEMA' => $DB->dbdefault]
]);
echo count($iterator);