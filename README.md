## Quickstart

```
make run
make tree
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


```
make tree
```


### DAG


https://www.bustawin.com/dags-with-materialized-paths-using-postgres-ltree/

<img src="https://www.codeproject.com/KB/database/Modeling_DAGs_on_SQL_DBs/Figure3.gif">

In the example below we execute "give me all the Livestock". This returns all children of `Livestock` i.e. `Dog, Sheep, Cow`.


```
make dag
```

```
 id |   name    |  path
----+-----------+---------
  1 | Animal    | 1
  2 | Pet       | 1.2
  3 | Livestock | 1.3
  4 | Cat       | 1.2.4
  5 | Dog       | 1.2.5
  5 | Dog       | 1.3.5
  6 | Sheep     | 1.2.6
  6 | Sheep     | 1.3.6
  7 | Cow       | 1.3.7
  8 | Doberman  | 1.2.5.8
  8 | Doberman  | 1.3.5.8
  9 | Bulldog   | 1.2.5.9
  9 | Bulldog   | 1.3.5.9
(13 rows)

 name  | path
-------+-------
 Dog   | 1.3.5
 Sheep | 1.3.6
 Cow   | 1.3.7
(3 rows)
```

### inv

```
make run
docker exec -it explore-ltree_app_1 /bin/bash
./main.py
```

Leaf nodes that have an **anchor node** in their ancestory match the users query.

* Find all anchor nodes

#### TODO

* Make sure that the anchor node matches the users original query. Currently, the anchor node _might_ match the users query, we need to fully verify.
* Get all leaf nodes of an anchor node.
* Resolve the var hierarchy of all the leaf nodes.
