#!/usr/bin/env python

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

conn = psycopg2.connect("host=db dbname=exploreltree user=postgres password=mysecretpassword")
cur = conn.cursor()

cur.execute(open("inv.sql", "r").read())

cur.execute("""select abc.node_id, abc.name, abc.path, kv.key k, kv.value v
    INTO TEMP TABLE path_recent FROM
    (select DISTINCT ON (t.node_id)
    t.id, t.node_id, n.name, t.path, n.vars
    FROM tree t, node n
    WHERE (n.vars ? 'can_eat' OR n.vars ? 'is_pet' OR n.vars ? 'should_eat')
    AND t.node_id = n.id) AS abc, jsonb_each(abc.vars) as kv
    WHERE kv.key IN ('can_eat', 'is_pet', 'should_eat');""")

cur.execute('select p1.node_id, p1.name, p1.path, p1.k, p1.v from path_recent p1;')
for r in cur.fetchall():
    print(r)
print("====================")
cur.execute("""select p1.node_id, p1.k, p1.v, p1.path
        FROM path_recent AS p1
        INNER JOIN path_recent AS p2 ON (p2.path @> p1.path)
        WHERE nlevel(p1.path) > nlevel(p2.path)
        GROUP BY p1.node_id, p1.k, p1.v, p1.path""")

# TODO: Ensure k, v match
# TODO: Get the sub-trees of all matching "anchor" nodes

for r in cur.fetchall():
    print(r)
