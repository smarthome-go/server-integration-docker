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
# cd smarthome

# Run following command AFTER the image has been built
# This will start the integration tests using a local version of the code
docker run -it \
  --rm \
  --name smarthome-server-integration-tests \
  -e 'SMARTHOME_INTEGRATION_SETUP_ONLY'=0 \
  -v $(pwd):/opt/smarthome/tests \
  mikmuellerdev/smarthome-integration-test
```

### Setup Only
Sometimes it is desired to only setup MariaDB and check the current directory for validity, in those cases the
`SMARTHOME_INTEGRATION_SETUP_ONLY1` environment variable can be set to `1`.

Those cases include using the image to perform other tests on the server repository, for example running the actual server.

#### Valid Values
| Value | Result                                |
|-------|---------------------------------------|
| `0`   | Continuation of the integration tests |
| `1`   | Abortion using exit-code `0`          |
| empty | Continuation of the integration tests |
| any   | Error using exit-code `1`             |

```bash
# Navigate into the `smarthome-go/smarthome` repository
# cd smarthome

# Run following command AFTER the image has been built
# This will abort the integration tests
# due to the `xxx_SETUP_ONLY` environment variable bein set to `1`
docker run -it \
  --rm \
  --name smarthome-server-integration-tests \
  -e 'SMARTHOME_INTEGRATION_SETUP_ONLY'=1 \
  -v $(pwd):/opt/smarthome/tests \
  mikmuellerdev/smarthome-integration-test
```
