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

-- select n.id, n.name, t.path from node n, tree t WHERE n.id = t.node_id;
--select DISTINCT ON (t.node_id) n.name, t.path from tree t, node n where path ~ '{}.3.*{1}' AND t.node_id = n.id;

-- High level query can_eat=true AND should_eat = false
-- Low level action:
-- * Get all nodes that have the extra var(s) we are searching on.
--   A member of the hierarchy lower down may set can_eat=false.
select abc.node_id, abc.name, abc.path, kv.key k, kv.value v
    INTO TEMP TABLE path_recent FROM
    (select DISTINCT ON (t.node_id)
    t.id, t.node_id, n.name, t.path, n.vars
    FROM tree t, node n
    WHERE (n.vars ? 'can_eat' OR n.vars ? 'is_pet' OR n.vars ? 'should_eat')
    AND t.node_id = n.id) AS abc, jsonb_each(abc.vars) as kv
    WHERE kv.key IN ('can_eat', 'is_pet', 'should_eat');
/*
-- TODO: OR above might not work, consider UNION
   That will give us the correct resolved vars that we care about and the nodes/paths.
   Get all the leafs nodes of those sub-trees and those are our hosts.
   We then need to get all nodes in the path to the hosts to build the vars
*/

/*
TODO: An alternative algorithm.

*/

/*
-- TODO: Above query identifies "anchor" nodes in question
--       Group the anchor nodes by sub-tree
--       Foreach sub-tree go to the lowest level
--       if lowest level fact MATCH then
--       must get sub-tree of that lowest level node
--       because all of those nodes are a match

                          Animal
                          (can_eat: false, is_pet: false)
           Livestock ------|------ Pet
           (can_eat: true)         (is_pet: true, should_eat: false)
           |-----------------------|-- Dog
                                       (lives_in_house: true)

* can_eat: Initial value that is overwritten 1 level lower
* is_pet: Initial value that is overwritten 2 levels lower
* should_eat: value set 1 level higher than leaf
* lives_in_house: value first time set at leaf
*/
select lca(array_agg(path)) from tree WHERE NOT path ~ '1';
select p1.node_id, p1.name, p1.path, p1.k, p1.v from path_recent p1;

select p1.node_id, p1.name, p1.path, p1.k, p1.v, lca(array(select tree.path from tree where not path ~ '1')) from path_recent p1;

-- select p1.node_id, p1.name, p1.path, p1.k, p1.v from path_recent p1, path_recent p2
-- WHERE p1.path ~ lca(array(select path from p2))::text;

/*
SELECT t.node_id, t.path
INTO TEMP TABLE path_hierarchy
FROM tree t, path_recent p
WHERE t.path <@ p.path;

select n.name, h.path FROM node n, path_hierarchy h WHERE n.id = h.node_id;
*/
