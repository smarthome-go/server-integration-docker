repository := mikmuellerdev/smarthome-integration-test
tag := 0.1.0

docker:
	docker build \
		-t $(repository):$(tag) \
		-t $(repository):latest .

docker-push:
	docker push $(repository):$(tag)
	docker push $(repository):latest
