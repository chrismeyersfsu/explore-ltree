#!/usr/bin/env python

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

conn = psycopg2.connect("host=db dbname=exploreltree user=postgres password=mysecretpassword")
cur = conn.cursor()

cur.execute(open("inv.sql", "r").read())

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
