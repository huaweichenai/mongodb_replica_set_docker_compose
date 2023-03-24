build:
	cp .env-dist .env
	docker-compose build --force-rm
	docker-compose up -d

start:
	docker-compose start

status:
	docker-compose ps

stop:
	docker-compose stop

down:
	docker-compose down --rmi local
	rm .env
