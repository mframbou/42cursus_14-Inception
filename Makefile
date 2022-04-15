SHELL := /bin/bash # Otherwise read mess up with zsh

all: stop add-domain
	docker-compose --file=./srcs/docker-compose.yml --env-file=./srcs/.env up

up: all

start: up

down:
	docker-compose --file=./srcs/docker-compose.yml --env-file=./srcs/.env down

stop: down

re: down prune all

restart: down all

add-domain:
# Quiet grep, only need exit status
# read -n 1 = read 1 char, -r = no escaped characters, -p = prompt, line is stored in REPLY variable
	@if ! grep -q "mframbou.42.fr" /etc/hosts ; then \
		echo "Domain mframbou.42.fr redirection to localhost not found."; \
		read -p "Do you wish to add it now (require sudo) ? [y/n] " -r; \
		if [[ $$REPLY =~ ^[Yy] ]] ; then \
            sudo sed -i '/^127.0.0.1/a127.0.0.1 mframbou.42.fr' /etc/hosts; \
        fi; \
	fi;

add-volumes-folders:
	@if [ ! -d ~/data/wordpress ]; then \
		mkdir -p /data/wordpress; \
	fi;

	@if [ ! -d ~/data/mariadb ]; then \
		mkdir -p /data/mariadb; \
	fi;

	@if [ ! -d ~/data/minecraft-server ]; then \
		mkdir -p /data/minecraft-server; \
	fi;

	@if [ ! -d ~/data/static-website ]; then \
		mkdir -p /data/static-website; \
	fi;


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