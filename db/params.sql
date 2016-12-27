SET @TABLE_DEC = "CREATE TABLE IF NOT EXISTS `scratch`.";
SET @PARAM_COLS = "\n`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT, \n`value_id` INT(11) UNSIGNED NOT NULL,";
SET @PRIMARY_KEY = "\nPRIMARY KEY (`id`)";
-- SET @PARAM_CONSTRAINT = "
SELECT identifier, sql_type, 
	concat(@TABLE_DEC, '`param_value_', identifier, '` (', @PARAM_COLS, @PRIMARY_KEY, ',\nCONSTRAINT `fk_param_value_', identifier, 
	"_param_value` FOREIGN KEY (`param_value_id`) \nREFERENCES `param_value`  (`id`),") 

as 'table_ddl'
FROM param_type;


-- CREATE TABLE IF NOT EXISTS `scratch`.`param_value_boolean` (
--   `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `param_value_id` INT(11) UNSIGNED NOT NULL,
--   `value_id` INT(11) UNSIGNED NOT NULL,
--   PRIMARY KEY (`id`),
--   INDEX `fk_param_value_boolean_param_value` (`param_value_id` ASC),
--   INDEX `fk_param_value_boolean` (`value_id` ASC),
--   CONSTRAINT `fk_param_value_boolean_param_value`
--     FOREIGN KEY (`param_value_id`)
--     REFERENCES `scratch`.`param_value` (`id`),
--   CONSTRAINT `fk_param_value_boolean`
--     FOREIGN KEY (`value_id`)
--     REFERENCES `scratch`.`value_boolean` (`id`))


-- CREATE TABLE IF NOT EXISTS `scratch`.`value_boolean` (
--   
--   `value` TINYINT(1) NOT NULL,
--   )
-- ENGINE = InnoDB
-- DEFAULT CHARACTER SET = latin1
-- 