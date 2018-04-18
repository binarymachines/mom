use suggestion;

CREATE TABLE IF NOT EXISTS `suggestion`.`generated_action` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `action_id` int(11) UNSIGNED,
    `action_status_id` int(11) UNSIGNED,
    `parent_id` int(11) UNSIGNED,
    `asset_id` varchar(128) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`parent_id`)
        REFERENCES `generated_action` (`id`) 
);

ALTER TABLE `generated_action` 
ADD foreign key fk_action(`action_id`)
REFERENCES analysis.action(`id`);

ALTER TABLE `generated_action` 
ADD foreign key fk_action_asset(`asset_id`)
REFERENCES media.asset(`id`);

ALTER TABLE `generated_action` 
ADD foreign key fk_action_status(`action_status_id`)
REFERENCES analysis.action_status(`id`);


CREATE TABLE IF NOT EXISTS `suggestion`.`generated_reason` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `reason_id` int(11) UNSIGNED,
    `parent_id` int(11) UNSIGNED,
    -- `asset_id` varchar(128) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`parent_id`)
        REFERENCES `generated_reason` (`id`)
);


ALTER TABLE `generated_reason` 
ADD foreign key fk_reason(`reason_id`)
REFERENCES analysis.action(`id`);

-- ALTER TABLE `generated_reason` 
-- ADD foreign key fk_reason_asset(`asset_id`)
-- REFERENCES media.asset(`id`);


CREATE TABLE IF NOT EXISTS `suggestion`.`generated_action_reason` (
  `action_id` INT(11) UNSIGNED NOT NULL,
  `reason_id` INT(11) UNSIGNED NOT NULL,
--    `is_sufficient_solo` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`action_id`, `reason_id`),
  INDEX `fk_action_reason_reason_idx` (`reason_id` ASC),
  INDEX `fk_action_reason_action_idx` (`action_id` ASC),
  CONSTRAINT `fk_action_reason_action`
    FOREIGN KEY (`action_id`)
    REFERENCES `suggestion`.`generated_action` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_reason`
    FOREIGN KEY (`reason_id`)
    REFERENCES `suggestion`.`generated_reason` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS `suggestion`.`generated_reason_param` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    -- `action_id` int(11) UNSIGNED NOT NULL,
    `reason_id` int(11) UNSIGNED NOT NULL,
    `vector_param_id` INT(11) UNSIGNED NOT NULL,
    -- `reason_param_id` int(11) UNSIGNED NOT NULL,
    `value` varchar(1024),
    PRIMARY KEY (`id`),
    -- FOREIGN KEY (`action_id`)
    --     REFERENCES `action` (`id`),
    FOREIGN KEY (`reason_id`)
        REFERENCES `generated_reason` (`id`)
);

ALTER TABLE `generated_reason_param` 
ADD foreign key fk_reason_vector_param(`vector_param_id`)
REFERENCES analysis.vector_param(`id`);

CREATE TABLE IF NOT EXISTS `suggestion`.`generated_action_param` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `action_id` int(11) UNSIGNED,
    `vector_param_id` INT(11) UNSIGNED NOT NULL,
    -- `action_param_id` int(11) UNSIGNED,
    `value` varchar(1024),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`action_id`)
        REFERENCES `generated_action` (`id`),
    FOREIGN KEY (`vector_param_id`)
        REFERENCES `analysis`.`vector_param` (`id`)
);


-- CREATE VIEW `v_m_action_m_reasons_w_ids` AS
--     select at.id action_id, at.name action, at.priority action_priority, ad.id dispatch_id, ad.name dispatch_name,
--         ad.category dispatch_category, ad.module_name dispatch_module, ad.class_name dispatch_class, ad.func_name dispatch_func,
--         rt.id reason_id, rt.name reason, rt.weight reason_weight,
--         ad2.id conditional_dispatch_id, ad2.name conditional_dispatch_name, ad2.category conditional_dispatch_category,
--         ad2.module_name conditional_dispatch_module, ad2.class_name conditional_dispatch_class, ad2.func_name conditional_dispatch_func

--     from action at,
--         dispatch ad,
--         dispatch ad2,
--         reason rt,
--         m_action_m_reason ar

--     where at.dispatch_id = ad.id
--         and rt.dispatch_id = ad2.id
--         and at.id = ar.action_id
--         and rt.id = ar.reason_id

--     order by action;

-- DROP VIEW IF EXISTS `v_m_action_m_reasons`;

-- CREATE VIEW `v_m_action_m_reasons` AS
--     select action, action_priority, dispatch_name,
--         dispatch_category, dispatch_module, dispatch_class, dispatch_func,
--         reason, reason_weight, conditional_dispatch_name, conditional_dispatch_category,
--         conditional_dispatch_module, conditional_dispatch_class, conditional_dispatch_func
--     from v_m_action_m_reasons_w_ids
--     order by action;
