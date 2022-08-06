# server-integration-docker
A docker image for running the server's integration test in a reproducible manner

## Building the Image
```bash
make docker
```

## Running locally
*Note*: The image acts like a runner and must therefore be provided with a Smarthome-server working directory as a volume.

```bash
# Navigate into the `smarthome-go/smarthome` repository
cd smarthome

# Run following command AFTER the image has been built
# This will start the integration tests using a local version of the code
docker run -it \
  --rm \
  --name smarthome-server-integration-tests \
  -v $(pwd):/opt/smarthome/tests \
  mikmuellerdev/smarthome-integration-test
```
