build:
	docker build -t todo_elixir_img .

up:
	docker run -d -p 4000:4000 -v $(shell pwd)/todo:/app/todo --name todo_container --network host -it todo_elixir_img

run:
	docker exec -it --workdir /app/todo todo_container mix phx.server

test:
	docker exec -it --workdir /app/todo -e MIX_ENV=test todo_container mix test

enter: 
	docker exec -it todo_container /bin/bash