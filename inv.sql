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


insert into node (name, vars) values ('Animal', '{"type":"animal", "is_pet": "false", "can_eat": "false"}');
insert into node (name, vars) values ('Pet', '{"is_pet": "true", "should_eat": "false"}');
insert into node (name, vars) values ('Livestock', '{"can_eat": "true", "is_pet": "false"}');
insert into node (name) values ('Cat');
insert into node (name, vars) values ('Dog', '{"type": "dog", "lives_in_house": "true"}'); -- 5
insert into node (name, vars) values ('Sheep', '{"type": "sheep"}');
insert into node (name, vars) values ('Cow', '{"type": "cow"}');
insert into node (name) values ('Doberman');
insert into node (name) values ('Bulldog');

insert into tree (node_id, path) values (1, '1');
insert into tree (node_id, path) values (2, '1.2');
insert into tree (node_id, path) values (3, '1.3');
insert into tree (node_id, path) values (4, '1.2.4');
insert into tree (node_id, path) values (5, '1.2.5');
insert into tree (node_id, path) values (5, '1.3.5');
insert into tree (node_id, path) values (6, '1.2.6');
insert into tree (node_id, path) values (6, '1.3.6');
insert into tree (node_id, path) values (7, '1.3.7');
insert into tree (node_id, path) values (8, '1.2.5.8');
insert into tree (node_id, path) values (8, '1.3.5.8');
insert into tree (node_id, path) values (9, '1.2.5.9');
insert into tree (node_id, path) values (9, '1.3.5.9');

