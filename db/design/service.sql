drop schema if exists `service`;
create schema `service`;
use `service`;

DROP TABLE IF EXISTS `mode_state_default_param`;
-- DROP TABLE IF EXISTS `mode_state_default_operation`;
DROP TABLE IF EXISTS `mode_state_default`;
DROP TABLE IF EXISTS `mode_default`;
DROP TABLE IF EXISTS `mode_state_param`;
DROP TABLE IF EXISTS `mode_state`;
DROP TABLE IF EXISTS `transition_rule`;
DROP TABLE IF EXISTS `switch_rule`;
DROP TABLE IF EXISTS `state`;
DROP TABLE IF EXISTS `mode`;
-- DROP TABLE IF EXISTS `operation`;
-- DROP TABLE IF EXISTS `operator`;
DROP TABLE IF EXISTS `dispatch_target`;
DROP TABLE IF EXISTS `service_dispatch`;
DROP TABLE IF EXISTS `service_profile`;

DROP VIEW IF EXISTS `v_mode_default_dispatch`;
DROP VIEW IF EXISTS `v_mode_default_dispatch_w_id`;
DROP VIEW IF EXISTS `v_mode_dispatch`;
DROP VIEW IF EXISTS `v_mode_state_default_dispatch`;
DROP VIEW IF EXISTS `v_mode_state_default_dispatch_w_id`;
DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch`;
DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch_w_id`;
DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch`;
DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch_w_id`;

CREATE TABLE `service_profile` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
);


CREATE TABLE `service_dispatch` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `category` varchar(128) DEFAULT NULL,
  `package_name` varchar(128) DEFAULT NULL,
  `module_name` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `func_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

# service process
INSERT INTO service_dispatch (name, category, module_name, func_name) VALUES ('create_service_process', 'process', 'docserv', 'create_service_process');
INSERT INTO service_dispatch (name, category, module_name, class_name) VALUES ('handle_service_process', 'process.handler', 'docserv', 'DocumentServiceProcessHandler');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('service_process_before_switch', 'process.before', 'docservmodes', 'DocumentServiceProcessHandler', 'before_switch');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('service_process_after_switch', 'process.after', 'docservmodes', 'DocumentServiceProcessHandler', 'after_switch');

# modes
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('startup', 'effect', 'docservmodes', 'StartupHandler', 'start');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('startup.switch.condition', 'CONDITION', 'docserv', 'DocumentServiceProcessHandler', 'definitely');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('startup.switch.before', 'switch', 'docservmodes', 'StartupHandler', 'starting');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('startup.switch.after', 'switch', 'docservmodes', 'StartupHandler', 'started');

INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('analyze', 'effect', 'docservmodes', 'AnalyzeModeHandler', 'do_analyze');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('analyze.switch.condition', 'CONDITION', 'docserv', 'DocumentServiceProcessHandler', 'mode_is_available');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('analyze.switch.before', 'switch', 'docservmodes', 'AnalyzeModeHandler', 'before_analyze');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('analyze.switch.after', 'switch', 'docservmodes', 'AnalyzeModeHandler', 'after_analyze');

INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan.update.condition', 'CONDITION', 'docservmodes', 'ScanModeHandler', 'should_update');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan.monitor.condition', 'CONDITION', 'docservmodes', 'ScanModeHandler', 'should_monitor');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan.switch.condition', 'CONDITION', 'docservmodes', 'ScanModeHandler', 'can_scan');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan', 'effect', 'docservmodes', 'ScanModeHandler', 'do_scan');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan.discover', 'ACTION', 'docservmodes', 'ScanModeHandler', 'do_scan_discover');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan.update', 'ACTION', 'docservmodes', 'ScanModeHandler', 'do_scan');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan.monitor', 'ACTION', 'docservmodes', 'ScanModeHandler', 'do_scan_monitor');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan.switch.before', 'switch', 'docservmodes', 'ScanModeHandler', 'before_scan');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('scan.switch.after', 'switch', 'docservmodes', 'ScanModeHandler', 'after_scan');

INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('match', 'effect', 'docservmodes', 'MatchModeHandler', 'do_match');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('match.switch.condition', 'CONDITION', 'docserv', 'DocumentServiceProcessHandler', 'mode_is_available');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('match.switch.before', 'switch', 'docservmodes', 'MatchModeHandler', 'before_match');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('match.switch.after', 'switch', 'docservmodes', 'MatchModeHandler', 'after_match');

INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('fix.switch.condition', 'CONDITION', 'docserv', 'DocumentServiceProcessHandler', 'mode_is_available');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('fix', 'effect', 'docservmodes', 'FixModeHandler', 'do_fix');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('fix.switch.before', 'switch', 'docservmodes', 'FixModeHandler', 'before_fix');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('fix.switch.after', 'switch', 'docservmodes', 'FixModeHandler', 'after_fix');

INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('report.switch.condition', 'CONDITION', 'docserv', 'DocumentServiceProcessHandler', 'mode_is_available');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('report', 'effect', 'docservmodes', 'ReportModeHandler', 'do_report');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('report.switch.before', 'switch', 'docserv', 'DocumentServiceProcessHandler', 'before');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('report.switch.after', 'switch', 'docserv', 'DocumentServiceProcessHandler', 'after');

INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('requests', 'effect', 'docservmodes', 'RequestsModeHandler', 'do_reqs');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('requests.switch.condition', 'CONDITION', 'docserv', 'DocumentServiceProcessHandler', 'mode_is_available');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('requests.switch.before', 'switch', 'docserv', 'DocumentServiceProcessHandler', 'before');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('requests.switch.after', 'switch', 'docserv', 'DocumentServiceProcessHandler', 'after');

INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('shutdown', 'effect', 'docservmodes', 'ShutdownHandler', 'end');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('shutdown.switch.before', 'switch', 'docservmodes', 'ShutdownHandler', 'ending');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('shutdown.switch.after', 'switch', 'docservmodes', 'ShutdownHandler', 'ended');
INSERT INTO service_dispatch (name, category, module_name, class_name, func_name) VALUES ('shutdown.switch.condition', 'CONDITION', 'docserv', 'DocumentServiceProcessHandler', 'maybe');

CREATE TABLE `mode` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `stateful_flag` boolean NOT NULL DEFAULT False,
--   `effective_dt` datetime DEFAULT now(),
--   `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mode_name` (`name`)
);

SET @NONE = 'None';
INSERT INTO mode (name) VALUES (@NONE);
INSERT INTO mode (name) VALUES ('startup');
INSERT INTO mode (name, stateful_flag) VALUES ('scan', True);
INSERT INTO mode (name) VALUES ('match');
INSERT INTO mode (name) VALUES ('analyze');
INSERT INTO mode (name) VALUES ('fix');
INSERT INTO mode (name) VALUES ('clean');
INSERT INTO mode (name) VALUES ('sync');
INSERT INTO mode (name) VALUES ('requests');
INSERT INTO mode (name) VALUES ('report');
INSERT INTO mode (name) VALUES ('sleep');
INSERT INTO mode (name) VALUES ('shutdown');

CREATE TABLE `state` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `terminal_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `initial_state_flag` tinyint(1) NOT NULL DEFAULT '0',
--   `effective_dt` datetime DEFAULT now(),
--   `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_state_name` (`name`)
);

INSERT INTO state(name, initial_state_flag) VALUES ('initial', 1);
INSERT INTO state(name, initial_state_flag) VALUES ('discover', 1);
INSERT INTO state(name) VALUES ('update');
INSERT INTO state(name) VALUES ('monitor');
INSERT INTO state(name, terminal_state_flag) VALUES ('terminal', 2);


CREATE TABLE `transition_rule` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `mode_id` int(11) UNSIGNED NOT NULL,
  `begin_state_id` int(11) UNSIGNED NOT NULL,
  `end_state_id` int(11) UNSIGNED NOT NULL,
  `condition_dispatch_id` int(11) UNSIGNED NOT NULL,
  -- `effective_dt` datetime DEFAULT NULL,
  -- `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_transition_rule_mode` (`mode_id`),
  CONSTRAINT `fk_transition_rule_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  KEY `fk_transition_rule_begin_state` (`begin_state_id`),
  CONSTRAINT `fk_transition_rule_begin_state` FOREIGN KEY (`begin_state_id`) REFERENCES `state` (`id`),
  KEY `fk_transition_rule_end_state` (`end_state_id`),
  CONSTRAINT `fk_transition_rule_end_state` FOREIGN KEY (`end_state_id`) REFERENCES `state` (`id`),
  KEY `fk_transition_rule_condition_dispatch` (`condition_dispatch_id`),
  CONSTRAINT `fk_transition_rule_condition_dispatch` FOREIGN KEY (`condition_dispatch_id`) REFERENCES `service_dispatch` (`id`)
);


CREATE TABLE `switch_rule` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `begin_mode_id` int(11) UNSIGNED NOT NULL,
  `end_mode_id` int(11) UNSIGNED NOT NULL,
  `before_dispatch_id` int(11) UNSIGNED NOT NULL,
  `after_dispatch_id` int(11) UNSIGNED NOT NULL,
  `condition_dispatch_id` int(11) UNSIGNED,
  -- `effective_dt` datetime DEFAULT NULL,
  -- `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),

  KEY `fk_switch_rule_begin_mode` (`begin_mode_id`),
    CONSTRAINT `c_switch_rule_begin_mode` FOREIGN KEY (`begin_mode_id`) REFERENCES `mode` (`id`),

  KEY `fk_switch_rule_end_mode` (`end_mode_id`),
    CONSTRAINT `c_switch_rule_end_mode` FOREIGN KEY (`end_mode_id`) REFERENCES `mode` (`id`),

  KEY `fk_switch_rule_condition_dispatch` (`condition_dispatch_id`),
    CONSTRAINT `c_switch_rule_condition_dispatch` FOREIGN KEY (`condition_dispatch_id`) REFERENCES `service_dispatch` (`id`),

  KEY `fk_switch_rule_before_dispatch` (`before_dispatch_id`),
    CONSTRAINT `c_switch_rule_before_dispatch` FOREIGN KEY (`before_dispatch_id`) REFERENCES `service_dispatch` (`id`),

  KEY `fk_switch_rule_after_dispatch` (`after_dispatch_id`),
    CONSTRAINT `c_switch_rule_after_dispatch` FOREIGN KEY (`after_dispatch_id`) REFERENCES `service_dispatch` (`id`),

  UNIQUE KEY `uk_switch_rule_name` (`name`)
);

create view `v_mode_switch_rule_dispatch` as
    select sr.name, m1.name begin_mode, m2.name end_mode,
        d1.package_name condition_package, d1.module_name condition_module, d1.class_name condition_class, d1.func_name condition_func,
        d2.package_name before_package, d2.module_name before_module, d2.class_name before_class, d2.func_name before_func,
        d3.package_name after_package, d3.module_name after_module, d3.class_name after_class, d3.func_name after_func
    from mode m1, mode m2, switch_rule sr, service_dispatch d1, service_dispatch d2, service_dispatch d3
    where sr.begin_mode_id = m1.id and
        sr.end_mode_id = m2.id and
        sr.condition_dispatch_id = d1.id and
        sr.before_dispatch_id = d2.id and
        sr.after_dispatch_id = d3.id
    order by m1.id;

create view `v_mode_switch_rule_dispatch_w_id` as
    select sr.name, m1.id begin_mode_id, m1.name begin_mode, m2.id end_mode_id, m2.name end_mode,
        d1.package_name condition_package, d1.module_name condition_module, d1.class_name condition_class, d1.func_name condition_func,
        d2.package_name before_package, d2.module_name before_module, d2.class_name before_class, d2.func_name before_func,
        d3.package_name after_package, d3.module_name after_module, d3.class_name after_class, d3.func_name after_func
    from mode m1, mode m2, switch_rule sr, service_dispatch d1, service_dispatch d2, service_dispatch d3
    where sr.begin_mode_id = m1.id and
        sr.end_mode_id = m2.id and
        sr.condition_dispatch_id = d1.id and
        sr.before_dispatch_id = d2.id and
        sr.after_dispatch_id = d3.id
    order by m1.id;

INSERT INTO transition_rule(name, mode_id, begin_state_id, end_state_id, condition_dispatch_id)
    VALUES('scan.discover::update',
        (select id from mode where name = 'scan'),
        (select id from state where name = 'discover'),
        (select id from state where name = 'update'),
        (select id from service_dispatch where name = 'scan.update.condition')
    );

INSERT INTO transition_rule(name, mode_id, begin_state_id, end_state_id, condition_dispatch_id)
    VALUES('scan.update::monitor',
        (select id from mode where name = 'scan'),
        (select id from state where name = 'update'),
        (select id from state where name = 'monitor'),
        (select id from service_dispatch where name = 'scan.monitor.condition')
    );

CREATE TABLE `mode_state` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `mode_id` int(11) UNSIGNED NOT NULL,
  `state_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `times_activated` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `times_completed` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `error_count` int(3) UNSIGNED NOT NULL DEFAULT '0',
  `cum_error_count` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `status` varchar(64) NOT NULL,
  `last_activated` datetime DEFAULT NULL,
  `last_completed` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_mode` (`mode_id`),
  KEY `fk_mode_state_state` (`state_id`),
  CONSTRAINT `fk_mode_state_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_state_state` FOREIGN KEY (`state_id`) REFERENCES `state` (`id`)
);


CREATE TABLE `mode_default` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mode_id` int(11) UNSIGNED NOT NULL,
  `priority` int(3) UNSIGNED NOT NULL DEFAULT '0',
  `effect_dispatch_id` int(11) UNSIGNED,
  `times_to_complete` int(3) UNSIGNED NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) UNSIGNED NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) UNSIGNED NOT NULL DEFAULT '0',
  `error_tolerance` int(3) UNSIGNED NOT NULL DEFAULT '0',
--   `effective_dt` datetime DEFAULT now(),
--   `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_default_dispatch` (`effect_dispatch_id`),
  CONSTRAINT `fk_mode_default_dispatch` FOREIGN KEY (`effect_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  KEY `fk_mode_default_mode` (`mode_id`),
  CONSTRAINT `fk_mode_default_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`));

INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'startup'), (select id from service_dispatch where name = 'startup'), 0);
INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'analyze'), (select id from service_dispatch where name = 'analyze'), 3);
INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'match'), (select id from service_dispatch where name = 'match'), 5);
INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'scan'), (select id from service_dispatch where name = 'scan'), 5);
INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'fix'), (select id from service_dispatch where name = 'fix'), 1);
INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'clean'), (select id from service_dispatch where name = 'clean'), 1);
INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'requests'), (select id from service_dispatch where name = 'requests'), 2);
INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'report'), (select id from service_dispatch where name = 'report'), 2);
INSERT INTO mode_default(mode_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'shutdown'), (select id from service_dispatch where name = 'shutdown'), 0);

create view `v_mode_default_dispatch` as
  select m.name, d.package_name, d.module_name, d.class_name, d.func_name, md.priority, md.dec_priority_amount, md.inc_priority_amount, md.times_to_complete, md.error_tolerance
  from mode m, mode_default md, service_dispatch d
  where md.mode_id = m.id and md.effect_dispatch_id = d.id
  order by m.name;

create view `v_mode_default_dispatch_w_id` as
  select m.id mode_id, m.name mode_name, m.stateful_flag, d.package_name  handler_package, d.module_name handler_module, d.class_name handler_class, d.func_name handler_func,
    md.priority, md.dec_priority_amount, md.inc_priority_amount, md.times_to_complete, md.error_tolerance
  from mode m, mode_default md, service_dispatch d
  where md.mode_id = m.id and md.effect_dispatch_id = d.id
  order by m.name;

CREATE TABLE `mode_state_default` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mode_id` int(11) UNSIGNED NOT NULL,
  `state_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `priority` int(3) UNSIGNED NOT NULL DEFAULT '0',
  `effect_dispatch_id` int(11) UNSIGNED,
  `times_to_complete` int(3) UNSIGNED NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) UNSIGNED NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) UNSIGNED NOT NULL DEFAULT '0',
  `error_tolerance` int(3) UNSIGNED NOT NULL DEFAULT '0',
  -- `status` varchar(64) NOT NULL,
--   `effective_dt` datetime DEFAULT now(),
--   `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_dispatch` (`effect_dispatch_id`),
  CONSTRAINT `fk_mode_state_default_dispatch` FOREIGN KEY (`effect_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  KEY `fk_mode_state_default_mode` (`mode_id`),
  KEY `fk_mode_state_default_state` (`state_id`),
  CONSTRAINT `fk_mode_state_default_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_state_default_state` FOREIGN KEY (`state_id`) REFERENCES `state` (`id`)
);

INSERT INTO mode_state_default(mode_id, state_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'scan'), (select id from state where name = 'discover'), (select id from service_dispatch where name = 'scan.discover'), 5);
INSERT INTO mode_state_default(mode_id, state_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'scan'), (select id from state where name = 'update'), (select id from service_dispatch where name = 'scan.update'), 5);
INSERT INTO mode_state_default(mode_id, state_id, effect_dispatch_id, priority) VALUES ((select id from mode where name = 'scan'), (select id from state where name = 'monitor'), (select id from service_dispatch where name = 'scan.monitor'), 5);

create view `v_mode_state_default_transition_rule_dispatch` as
    select tr.name, m.name mode, s1.name begin_state, s2.name end_state,
        d1.package_name condition_package, d1.module_name condition_module, d1.class_name condition_class, d1.func_name condition_func
    from mode m, mode_state_default md, transition_rule tr, state s1, state s2, service_dispatch d1
    where m.id = md.mode_id and md.state_id = s1.id and
        tr.begin_state_id = s1.id and
        tr.end_state_id = s2.id and
        tr.condition_dispatch_id = d1.id;

create view `v_mode_state_default_transition_rule_dispatch_w_id` as
    select tr.name, m.id mode_id, m.name mode, s1.id begin_state_id, s1.name begin_state, s2.id end_state_id, s2.name end_state,
        d1.package_name condition_package, d1.module_name condition_module, d1.class_name condition_class, d1.func_name condition_func
    from mode m, mode_state_default md, transition_rule tr, state s1, state s2, service_dispatch d1
    where m.id = md.mode_id and md.state_id = s1.id and
        tr.begin_state_id = s1.id and
        tr.end_state_id = s2.id and
        tr.condition_dispatch_id = d1.id
    order by m.id;

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('startup',
        (select id from mode where name = @NONE),
        (select id from mode where name = 'startup'),
        (select id from service_dispatch where name = 'startup.switch.condition'),
        (select id from service_dispatch where name = 'startup.switch.before'),
        (select id from service_dispatch where name = 'startup.switch.after')
    );


# paths to analyze

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('startup.analyze',
        (select id from mode where name = 'startup'),
        (select id from mode where name = 'analyze'),
        (select id from service_dispatch where name = 'analyze.switch.condition'),
        (select id from service_dispatch where name = 'analyze.switch.before'),
        (select id from service_dispatch where name = 'analyze.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('scan.analyze',
        (select id from mode where name = 'scan'),
        (select id from mode where name = 'analyze'),
        (select id from service_dispatch where name = 'analyze.switch.condition'),
        (select id from service_dispatch where name = 'analyze.switch.before'),
        (select id from service_dispatch where name = 'analyze.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('match.analyze',
        (select id from mode where name = 'match'),
        (select id from mode where name = 'analyze'),
        (select id from service_dispatch where name = 'analyze.switch.condition'),
        (select id from service_dispatch where name = 'analyze.switch.before'),
        (select id from service_dispatch where name = 'analyze.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('requests.analyze',
        (select id from mode where name = 'requests'),
        (select id from mode where name = 'analyze'),
        (select id from service_dispatch where name = 'analyze.switch.condition'),
        (select id from service_dispatch where name = 'analyze.switch.before'),
        (select id from service_dispatch where name = 'analyze.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('report.analyze',
        (select id from mode where name = 'report'),
        (select id from mode where name = 'analyze'),
        (select id from service_dispatch where name = 'analyze.switch.condition'),
        (select id from service_dispatch where name = 'analyze.switch.before'),
        (select id from service_dispatch where name = 'analyze.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('fix.analyze',
        (select id from mode where name = 'fix'),
        (select id from mode where name = 'analyze'),
        (select id from service_dispatch where name = 'analyze.switch.condition'),
        (select id from service_dispatch where name = 'analyze.switch.before'),
        (select id from service_dispatch where name = 'analyze.switch.after')
    );

# paths to scan

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('startup.scan',
        (select id from mode where name = 'startup'),
        (select id from mode where name = 'scan'),
        (select id from service_dispatch where name = 'scan.switch.condition'),
        (select id from service_dispatch where name = 'scan.switch.before'),
        (select id from service_dispatch where name = 'scan.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('analyze.scan',
        (select id from mode where name = 'analyze'),
        (select id from mode where name = 'scan'),
        (select id from service_dispatch where name = 'scan.switch.condition'),
        (select id from service_dispatch where name = 'scan.switch.before'),
        (select id from service_dispatch where name = 'scan.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('scan.scan',
        (select id from mode where name = 'scan'),
        (select id from mode where name = 'scan'),
        (select id from service_dispatch where name = 'scan.switch.condition'),
        (select id from service_dispatch where name = 'scan.switch.before'),
        (select id from service_dispatch where name = 'scan.switch.after')
    );

# paths to match

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('startup.match',
        (select id from mode where name = 'startup'),
        (select id from mode where name = 'match'),
        (select id from service_dispatch where name = 'match.switch.condition'),
        (select id from service_dispatch where name = 'match.switch.before'),
        (select id from service_dispatch where name = 'match.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('analyze.match',
        (select id from mode where name = 'analyze'),
        (select id from mode where name = 'match'),
        (select id from service_dispatch where name = 'match.switch.condition'),
        (select id from service_dispatch where name = 'match.switch.before'),
        (select id from service_dispatch where name = 'match.switch.after')
    );


INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('scan.match',
        (select id from mode where name = 'scan'),
        (select id from mode where name = 'match'),
        (select id from service_dispatch where name = 'match.switch.condition'),
        (select id from service_dispatch where name = 'match.switch.before'),
        (select id from service_dispatch where name = 'match.switch.after')
    );

# paths to report

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('fix.report',
        (select id from mode where name = 'fix'),
        (select id from mode where name = 'report'),
        (select id from service_dispatch where name = 'report.switch.condition'),
        (select id from service_dispatch where name = 'report.switch.before'),
        (select id from service_dispatch where name = 'report.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('requests.report',
        (select id from mode where name = 'requests'),
        (select id from mode where name = 'report'),
        (select id from service_dispatch where name = 'report.switch.condition'),
        (select id from service_dispatch where name = 'report.switch.before'),
        (select id from service_dispatch where name = 'report.switch.after')
    );

# paths to requests

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('scan.requests',
        (select id from mode where name = 'scan'),
        (select id from mode where name = 'requests'),
        (select id from service_dispatch where name = 'requests.switch.condition'),
        (select id from service_dispatch where name = 'requests.switch.before'),
        (select id from service_dispatch where name = 'requests.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('match.requests',
        (select id from mode where name = 'match'),
        (select id from mode where name = 'requests'),
        (select id from service_dispatch where name = 'requests.switch.condition'),
        (select id from service_dispatch where name = 'requests.switch.before'),
        (select id from service_dispatch where name = 'requests.switch.after')
    );
COMMIT;

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('analyze.requests',
        (select id from mode where name = 'analyze'),
        (select id from mode where name = 'requests'),
        (select id from service_dispatch where name = 'requests.switch.condition'),
        (select id from service_dispatch where name = 'requests.switch.before'),
        (select id from service_dispatch where name = 'requests.switch.after')
    );

# paths to fix

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('requests.fix',
        (select id from mode where name = 'requests'),
        (select id from mode where name = 'fix'),
        (select id from service_dispatch where name = 'fix.switch.condition'),
        (select id from service_dispatch where name = 'fix.switch.before'),
        (select id from service_dispatch where name = 'fix.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('report.fix',
        (select id from mode where name = 'report'),
        (select id from mode where name = 'fix'),
        (select id from service_dispatch where name = 'fix.switch.condition'),
        (select id from service_dispatch where name = 'fix.switch.before'),
        (select id from service_dispatch where name = 'fix.switch.after')
    );

# paths to shutdown

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('fix.shutdown',
        (select id from mode where name = 'fix'),
        (select id from mode where name = 'shutdown'),
        (select id from service_dispatch where name = 'shutdown.switch.condition'),
        (select id from service_dispatch where name = 'shutdown.switch.before'),
        (select id from service_dispatch where name = 'shutdown.switch.after')
    );

INSERT INTO switch_rule(name, begin_mode_id, end_mode_id, condition_dispatch_id, before_dispatch_id, after_dispatch_id)
    VALUES('report.shutdown',
        (select id from mode where name = 'report'),
        (select id from mode where name = 'shutdown'),
        (select id from service_dispatch where name = 'shutdown.switch.condition'),
        (select id from service_dispatch where name = 'shutdown.switch.before'),
        (select id from service_dispatch where name = 'shutdown.switch.after')
    );

CREATE TABLE `mode_state_default_param` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mode_state_default_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
--   `effective_dt` datetime DEFAULT now(),
--   `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_param` (`mode_state_default_id`),
  CONSTRAINT `fk_mode_state_default_param` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`)
);

INSERT INTO mode_state_default_param(mode_state_default_id,name, value) VALUES
  ((select id from mode_state_default where state_id = (select id from state where name = 'discover')), 'high.level.scan', 'true');

INSERT INTO mode_state_default_param(mode_state_default_id,name, value) VALUES
  ((select id from mode_state_default where state_id = (select id from state where name = 'update')), 'update.scan', 'true');

INSERT INTO mode_state_default_param(mode_state_default_id,name, value) VALUES
  ((select id from mode_state_default where state_id = (select id from state where name = 'monitor')), 'deep.scan', 'true');


-- CREATE TABLE `mode_state_default_operation` (
--   `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `mode_state_default_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
--   `operation_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
--   `effective_dt` datetime DEFAULT NULL,
--   `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
--   PRIMARY KEY (`id`),
--   KEY `fk_mode_state_default_operation_mode_state_default` (`mode_state_default_id`),
--   CONSTRAINT `fk_mode_state_default_operation_mode_state_default` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`),
--   KEY `fk_mode_state_default_operation_operation` (`operation_id`),
--   CONSTRAINT `fk_mode_state_default_operation_operation` FOREIGN KEY (`operation_id`) REFERENCES `operation` (`id`)
-- );


CREATE VIEW `v_mode_state_default_dispatch` AS
  SELECT m.name mode_name, s.name state_name, d.name, d.package_name, d.module_name, d.class_name, d.func_name, ms.priority, ms.dec_priority_amount, ms.inc_priority_amount, ms.times_to_complete, ms.error_tolerance
    -- , ms.effective_dt, ms.expiration_dt
  FROM mode m, state s, mode_state_default ms, service_dispatch d
  WHERE ms.state_id = s.id
    AND ms.effect_dispatch_id = d.id
    AND ms.mode_id = m.id
  ORDER BY m.name, s.id;


CREATE VIEW `v_mode_state_default_dispatch_w_id` AS
  SELECT m.id mode_id, s.id state_id, s.name state_name, d.name, d.package_name, d.module_name, d.class_name, d.func_name, ms.priority, ms.dec_priority_amount, ms.inc_priority_amount, ms.times_to_complete, ms.error_tolerance
    -- , ms.effective_dt, ms.expiration_dt
  FROM mode m, state s, mode_state_default ms, service_dispatch d
  WHERE ms.state_id = s.id
    AND ms.effect_dispatch_id = d.id
    AND ms.mode_id = m.id
  ORDER BY m.name, s.id;


DROP VIEW IF EXISTS `v_mode_state_default_param`;

CREATE VIEW `v_mode_state_default_param` AS
  SELECT m.name mode_name, s.name state_name, msp.name, msp.value
    -- , msp.effective_dt, msp.expiration_dt
    FROM mode m, state s, mode_state_default ms, mode_state_default_param msp
    WHERE ms.state_id = s.id
      AND ms.mode_id = m.id
      AND msp.mode_state_default_id = ms.id
    ORDER BY m.name, s.id;

DROP VIEW IF EXISTS `v_mode_state`;

CREATE VIEW `v_mode_state` AS
  SELECT m.name mode_name, s.name state_name, ms.status, ms.pid, ms.times_activated, ms.times_completed, ms.last_activated, ms.last_completed,
    ms.error_count, ms.cum_error_count, ms.effective_dt, ms.expiration_dt
  FROM mode m, state s, mode_state ms
  WHERE ms.state_id = s.id
    AND ms.mode_id = m.id
  ORDER BY ms.effective_dt;

COMMIT;


-- DROP TABLE IF EXISTS `error_attribute_value`;
-- DROP TABLE IF EXISTS `error_attribute`;
-- DROP TABLE IF EXISTS `error`;

-- CREATE TABLE `error` (
--   `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `name` varchar(128) NOT NULL,
--   PRIMARY KEY (`id`)
-- );

-- CREATE TABLE `error_attribute` (
--   `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `error_id` int(11) UNSIGNED NOT NULL,
--   `parent_attribute_id` int(11) DEFAULT NULL,
--   `name` varchar(128) CHARACTER SET utf8 NOT NULL,
--   PRIMARY KEY (`id`),
--   KEY `fk_error_attribute_error` (`error_id`),
--   CONSTRAINT `fk_error_attribute_error` FOREIGN KEY (`error_id`) REFERENCES `error` (`id`)
-- );

-- CREATE TABLE `error_attribute_value` (
--   `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `error_id` int(11) UNSIGNED NOT NULL,
--   `error_attribute_id` int(11) UNSIGNED NOT NULL,
--   `attribute_value` varchar(256) NOT NULL,
--   PRIMARY KEY (`id`),
--   KEY `fk_eav_e` (`error_id`),
--   KEY `fk_eav_ea` (`error_attribute_id`),
--   CONSTRAINT `fk_eav_e` FOREIGN KEY (`error_id`) REFERENCES `error` (`id`),
--   CONSTRAINT `fk_eav_ea` FOREIGN KEY (`error_attribute_id`) REFERENCES `error_attribute` (`id`)
-- );


-- CREATE TABLE `dispatch_target` (
--   `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,s
--   `dispatch_id` int(11) UNSIGNED NOT NULL,
--   `target` varchar(128) DEFAULT NULL,
--   PRIMARY KEY (`id`),
--   KEY `fk_dispatch_target_dispatch` (`dispatch_id`),
--   CONSTRAINT `fk_dispatch_target_dispatch` FOREIGN KEY (`dispatch_id`) REFERENCES `service_dispatch` (`id`)
-- ); 

-- DROP VIEW IF EXISTS `v_dispatch_target`;

-- create view `v_dispatch_target` as
--   select d.name, d.package_name, d.module_name, d.class_name, d.func_name, dt.target
--   from service_dispatch d, dispatch_target dt
--   where dt.dispatch_id = d.id
--   order by d.name;

-- CREATE TABLE `operator` (
--   `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `name` varchar(128) NOT NULL,
--   `effective_dt` datetime DEFAULT NULL,
--   `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
--   PRIMARY KEY (`id`)
-- );

-- INSERT INTO operator (name) VALUES ('scan');
-- INSERT INTO operator (name) VALUES ('calc');
-- INSERT INTO operator (name) VALUES ('clean');
-- INSERT INTO operator (name) VALUES ('analyze');
-- INSERT INTO operator (name) VALUES ('fix');
-- INSERT INTO operator (name) VALUES ('report');

-- CREATE TABLE `operation` (
--   `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `operator_id` int(11) UNSIGNED NOT NULL,
--   `module_name` varchar(128) NOT NULL,
--   `name` varchar(128) NOT NULL,
--   `effective_dt` datetime DEFAULT NULL,
--   `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
--   PRIMARY KEY (`id`),
--   KEY `fk_operation_operator` (`operator_id`),
--   CONSTRAINT `fk_operation_operator` FOREIGN KEY (`operator_id`) REFERENCES `operator` (`id`)
-- );

-- INSERT INTO operation (name, operator) VALUES ('scan', (select id from operator where name = 'scan'));
-- INSERT INTO operation (name, operator_id) VALUES ('discover', (select id from operator where name = 'scan'));
-- INSERT INTO operation (name, operator_id) VALUES ('update', (select id from operator where name = 'scan'));
-- INSERT INTO operation (name, operator_id) VALUES ('monitor', (select id from operator where name = 'scan'));
-- INSERT INTO operation (name, operator) VALUES ('fix', (select id from operator where name = 'fix'));
-- INSERT INTO operation (name, operator) VALUES ('analyze', (select id from operator where name = 'analyze'));
-- INSERT INTO operation (name, operator) VALUES ('clean', (select id from operator where name = 'clean'));

-- INSERT INTO operation (name) VALUES ('clean');
-- INSERT INTO operation (name) VALUES ('analyze');
-- INSERT INTO operation (name) VALUES ('fix');
-- INSERT INTO operation (name) VALUES ('match');
-- INSERT INTO operation (name) VALUES ('scan');
-- INSERT INTO operation (name) VALUES ('sync');
-- INSERT INTO operation (name) VALUES ('report');
-- INSERT INTO operation (name) VALUES ('requests');

