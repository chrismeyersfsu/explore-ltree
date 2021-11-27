-- CREATE DATABASE exploreltree;
create extension IF NOT EXISTS ltree;

drop table if exists tree;
drop table if exists node;

create table node(
    id serial primary key,
    name VARCHAR(4096),
    vars JSONB
);

create table tree(
    id serial primary key,
    node_id INT,
    path ltree,
    CONSTRAINT fk_node FOREIGN KEY(node_id) REFERENCES node(id)
);
create index tree_path_idx on tree using gist (path);


insert into node (name, vars) values ('1', '{"deployment": "prod"}');
insert into node (name, vars) values ('2', '{"ci_status": "passed"}');
insert into node (name, vars) values ('3', '{}');
insert into node (name, vars) values ('4', '{"deployment": "prod"}');
insert into node (name, vars) values ('5', '{}');
insert into node (name, vars) values ('6', '{"ci_status": "failed"}');
insert into node (name, vars) values ('7', '{}');

insert into tree (node_id, path) values (1, '1');
insert into tree (node_id, path) values (5, '5.1');
insert into tree (node_id, path) values (3, '5.1.3');
insert into tree (node_id, path) values (7, '5.1.3.7');
insert into tree (node_id, path) values (4, '4');
insert into tree (node_id, path) values (2, '4.2');
insert into tree (node_id, path) values (6, '4.2.6');
insert into tree (node_id, path) values (7, '4.2.6.7');

