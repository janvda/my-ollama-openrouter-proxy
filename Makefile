export COMPOSE_DOCKER_CLI_BUILD=0

project_name=my-ollama-openrouter-proxy

# variable below specifies the docker context where the service must run.
DOCKER_CONTEXT=colima

current_docker_context:=$(shell docker context ls | grep -e "*" | cut -d ' ' -f1 )

# check the docker context
ifneq (${current_docker_context},$(DOCKER_CONTEXT))
  $(error "Current docker context[=$(current_docker_context)] is not '$(DOCKER_CONTEXT)'")
endif

default: current_context

current_context:
	@echo  "========================================================================================="
	@echo  "current context:"
	@echo  "    current docker context = $(current_docker_context)"
	@echo  "    project_name = $(project_name)"
	@echo  "    COMPOSE_DOCKER_CLI_BUILD = $(COMPOSE_DOCKER_CLI_BUILD)"
	@echo  "usage:"
	@echo  "     # docker-compose commands:"
	@echo  "     make [all|up|build|down|stop|start|restart|ps|logs|top|images]"
	@echo  ""
	@echo  "     # docker system commands:"
	@echo  "     make df        # shows all system resources used by docker"
	@echo  "     make df_v      # same as df but more verbose output"
	@echo  "     make prune     # removes all unused containers, networks, images"
	@echo  "     make prune_all # same as prune but also removes unused volumes"	
	@echo  "========================================================================================="

all: 
	docker-compose -f docker-compose.yml  -p $(project_name) up -d --build

up:
	docker-compose -f docker-compose.yml  -p $(project_name) up -d

down stop start restart ps logs top images build:
	docker-compose -f docker-compose.yml  -p $(project_name) $@

df :
	docker system df

df_v :
	docker system df -v

prune :
	docker system prune -a

prune_all :
	docker system prune -a --volumes

.PHONY: default up  build down stop start restart ps logs top images df df_v prune prune_all
