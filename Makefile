preview:
	 docker run --rm -p 8000:8000 -v $(PWD):/work sequenceiq/pagebuilder mkdocs serve

circleci:
	rm ~/.gitconfig

clean:
	rm -rf site

update-images:
	curl -sL https://atlas.hashicorp.com/api/v1/artifacts/sequenceiq/cbd/amazon.image/search | jq .versions[0] > ./mkdocs_theme/providers/aws.json
	curl -sL https://atlas.hashicorp.com/api/v1/artifacts/sequenceiq/cbd/googlecompute.image/search | jq .versions[0] > ./mkdocs_theme/providers/gcp.json
	curl -sL https://atlas.hashicorp.com/api/v1/artifacts/sequenceiq/cbd/openstack.image/search | jq .versions[0] > ./mkdocs_theme/providers/openstack.json

test:
	docker run --rm -p 8000:8000 -v $(PWD):/work sequenceiq/pagebuilder mkdocs build
