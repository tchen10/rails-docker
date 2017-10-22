# README

A simple rails api to demonstrate Service Oriented Architecture.

# Stack Overview

- Ruby 2.4
- Rails 5.1.4
- Postgresql 10.0
- Docker & Docker Compose

# Set up
  
- Follow the instructions to install [Docker](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/). 
- Once docker is installed, run 
```
docker-compose up --build
```
The application is now running at localhost:3000

- Create and migrate the database.  
```
docker-compose exec api rake db:create
docker-compose exec api rake db:migrate
```
- To stop the application, go to your terminal where you are running the docker containers and press `CTRL+C`.
- To stop the services, run `docker-compose stop`.
- To stop the containers, run `docker-compose down`.

## Local development

Once you have created your images, you can use `docker-compose up` to start the containers. Some helpful commands:

- `docker-compose ps` : List containers
- `docker-compose start` : Start services
- `docker-compose stop` : Stop services
- `docker-compose exec` : Execute a command on a container
- `docker-compose run` : Execute a one-off command on a container

Please refer to `docker-compose help` for all commands.

Developing a Rails application on a docker container is not so different from development in a local environment.  You should be able to run all commands as you normally would, but you must prefix them with `docker-compose exec ${name of container}`. The containers are named as so:
- `api` - Rails service
- `db` - Postgres database
- `redis` - Redis
- `sidekiq` - Sidekiq

For example, running bundle install on the Rails service looks like:
```
docker-compose exec api bundle install
```

See the `docker-compose.yml` in the root of the project for configuration.

# Sidekiq

This service uses [Sidekiq](https://github.com/mperham/sidekiq) to schedule asynchronous, background jobs.  

To access to real-time information about workers, queues and jobs, `require 'sidekiq/api'`. See [Sidekiq/api](https://github.com/mperham/sidekiq/wiki/API) for more details.

# Testing

## Unit tests

```
docker-compose exec api rspec
```

