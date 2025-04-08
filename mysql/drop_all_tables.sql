USE bookshop;

SET FOREIGN_KEY_CHECKS = 0;

SELECT @tables := GROUP_CONCAT(table_schema, '.', table_name);
SELECT @tables := IFNULL(@tables,'information_schema.dummy');

SET @stmt = CONCAT('DROP TABLE IF EXISTS ', @tables);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET FOREIGN_KEY_CHECKS = 1;