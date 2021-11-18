create extension ltree;

drop table if exists tree;
drop table if exists node;

create table node(
    id serial primary key,
    name VARCHAR(4096)
);

create table tree(
    node_id INT,
    path ltree primary key,
    CONSTRAINT fk_node FOREIGN KEY(node_id) REFERENCES node(id)
);
create index tree_path_idx on tree using gist (path);


insert into node (name) values ('Animal');
insert into node (name) values ('Pet');
insert into node (name) values ('Livestock');
insert into node (name) values ('Cat');
insert into node (name) values ('Dog');
insert into node (name) values ('Sheep');
insert into node (name) values ('Cow');
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

select n.id, n.name, t.path from node n, tree t WHERE n.id = t.node_id;
select DISTINCT ON (t.node_id) n.name, t.path from tree t, node n where path ~ '1.3.*{1}' AND t.node_id = n.id;


