run:
	docker run --rm -p 5432:5432 --name pgltree -v ${PWD}:/data_dir -e POSTGRES_PASSWORD=mysecretpassword postgres

tree:
	docker exec -it --user postgres pgltree sh -c "psql -f /data_dir/tree.sql"

dag:
	docker exec -it --user postgres pgltree sh -c "psql -f /data_dir/dag.sql"

inv:
	docker exec -it --user postgres pgltree sh -c "psql -f /data_dir/inv.sql"

debug:
	docker exec -it --user postgres pgltree psql

build:
	docker build -t chrismeyersfsu/explore-ltree-app .

docker-compose:
	docker-compose up
