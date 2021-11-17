run:
	docker run --rm --name pgltree -v ${PWD}:/data_dir -e POSTGRES_PASSWORD=mysecretpassword postgres

init:
	docker exec -it --user postgres pgltree sh -c "psql -f /data_dir/init.sql"
