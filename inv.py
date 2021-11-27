#!/usr/bin/env python

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

conn = psycopg2.connect("host=db dbname=exploreltree user=postgres password=mysecretpassword")
cur = conn.cursor()

cur.execute(open("inv.sql", "r").read())

kv = {
    'deployment': 'prod',
    'ci_status': 'failed'
}

cond = (' OR ').join([f"n.vars ? '{k}' AND n.vars @> '{{\"{k}\": \"{v}\"}}'" for k,v in kv.items()])

cur.execute(f"""select p1.node_id, n.name, n.vars, p1.path
        FROM tree AS p1, tree AS p2, node n
        WHERE nlevel(p1.path) > nlevel(p2.path)
        AND ({cond})
        AND p2.path @> p1.path
        AND n.id = p1.node_id
        GROUP BY p1.node_id, n.vars, p1.path, n.name;""")

# TODO: Ensure k, v match
# TODO: Get the sub-trees of all matching "anchor" nodes
# TODO: manifest hostvars on leaf node

for r in cur.fetchall():
    print(r)
