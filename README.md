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
- Create and migrate the database.  
```
docker-compose exec api rake db:create
docker-compose exec api rake db:migrate
```
- To stop the application, go to your terminal where you are running the docker containers and press `CTRL+C`. Then run `docker-compose down` for good measure.

## Local development

Developing a Rails application on a docker container is not so different from development in a local environment.  You should be able to run all commands as you normally would, but you must prefix them with `docker-compose exec api`.
 
# Running the application

# Testing

## Unit tests

```
docker-compose exec api rspec
```

