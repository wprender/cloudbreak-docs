CB_BRANCH = $(shell echo \${BRANCH})
ifeq ($(CB_BRANCH),)
	CB_BRANCH=$(shell git name-rev --name-only HEAD) 
endif

CACHE = $(shell echo \${GRADLE_CACHE})
ifeq ($(CACHE),)
	CACHE_OPTION= 
else
	CACHE_OPTION=-v $(CACHE):/root/.gradle
endif

preview:
	 docker run --rm -p 8000:8000 -v $(PWD):/work sequenceiq/pagebuilder mkdocs serve

circleci:
	rm ~/.gitconfig

clean:
	rm -rf site

test:
	docker run --rm -p 8000:8000 -v $(PWD):/work sequenceiq/pagebuilder mkdocs build

generate-dots-by-branch:
	docker run --rm -v $(PWD):/work $(CACHE_OPTION) -e BRANCH=$(CB_BRANCH) -it sequenceiq/pagebuilder generate-dots
