NAME = atomaka/docker-linkshare
CONTAINER = sinatra-linkshare
DOMAIN = linkshare.atomaka.com
PORT = 10081
DATABASE = /home/atomaka/linkshare.db

all: build

build:
	docker build -t $(NAME) .

clean:
	docker rm -f $(CONTAINER)

deploy: clean
	touch $(DATABASE)
	docker run -e VIRTUAL_HOST=$(DOMAIN) -d -p $(PORT):9292 -v $(DATABASE):/app/db/linkshare.db --name=$(CONTAINER) --restart=always $(NAME)
	docker exec $(CONTAINER) rake db:migrate

update:
	git pull origin master
