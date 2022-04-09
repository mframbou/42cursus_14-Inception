all:
	docker-compose --file=./srcs/docker-compose.yml --env-file=./srcs/.env up

down:
	docker-compose --file=./srcs/docker-compose.yml --env-file=./srcs/.env down

stop: down

re: prune all

prune:
# - at the start ignores if a command fails
	@echo "Stopping all containers"
	-@docker stop $$(docker ps -qa)

	@echo "Deleting all containers"
	-@docker rm $$(docker ps -qa)

	@echo "Deleting all images"
	-@docker rmi -f $$(docker images -qa)

	@echo "Deleting all volumes"
	-@docker volume rm $$(docker volume ls -q)

	@echo "Deleting all networks"
	-@docker network rm $$(docker network ls -q) 2> /dev/null