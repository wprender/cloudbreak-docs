preview:
	 docker run --rm -p 8000:8000 -v $(PWD):/work sequenceiq/pagebuilder mkdocs serve

circleci:
	rm ~/.gitconfig

clean:
	rm -rf site

test:
	docker run -d --rm -p 8000:8000 -v $(PWD):/work sequenceiq/pagebuilder mkdocs build
