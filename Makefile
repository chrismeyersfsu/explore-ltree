run:
	docker run --rm --name pgltree -v ${PWD}:/data_dir -e POSTGRES_PASSWORD=mysecretpassword postgres

tree:
	docker exec -it --user postgres pgltree sh -c "psql -f /data_dir/tree.sql"

dag:
	docker exec -it --user postgres pgltree sh -c "psql -f /data_dir/dag.sql"
