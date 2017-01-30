update action_status set NAME = '' where NAME is null ;
alter table action_status modify column NAME varchar(255) not null ;
