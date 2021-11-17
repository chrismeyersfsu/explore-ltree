## Quickstart

```
make run
make init
```

```
 count
-------
     8
(1 row)

 count
-------
     2
(1 row)

 id | letter | path
----+--------+-------
  1 | A      | A
  2 | B      | A.B
  3 | C      | A.C
  4 | D      | A.C.D
  5 | E      | A.C.E
  6 | F      | A.C.F
  7 | G      | A.B.G
  8 | E      | A
(8 rows)

 id | letter | path
----+--------+-------
  2 | B      | A.B
  7 | G      | A.B.G
(2 rows)

```

## Postgres and Graphs

First, let's play around and get a tree data structure working in Postgres. Next, let's move on to a DAG. Finally, consider cycles.

### ltree

Inspired by http://patshaughnessy.net/2017/12/13/saving-a-tree-in-postgres-using-ltree

<img src="http://patshaughnessy.net/assets/2017/12/11/example-tree.png">

http://patshaughnessy.net/assets/2017/12/11/example-tree.png ^^

### DAG

https://www.bustawin.com/dags-with-materialized-paths-using-postgres-ltree/
