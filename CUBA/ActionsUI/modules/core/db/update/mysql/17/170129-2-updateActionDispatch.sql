update action_dispatch set CATEGORY = 'ACTION' where CATEGORY is null ;
alter table action_dispatch modify column CATEGORY varchar(50) not null ;
