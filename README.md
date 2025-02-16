# Gatus

Light weight status and monitoring tool. This repo contains config for building a multi arch Docker image and also creating binary for running on Pi Zero to monitor various endpoints. The container image is pushed to GitHub Container Registry and the binary also stored as an artifact in GitHub.

For reference and documentation on Gatus see:

- [Gatus](https://gatus.io/)
- [GitHub Repo](https://github.com/TwiN/gatus)
- [DockerHub](https://hub.docker.com/r/twinproduction/gatus)

## Config file
The config file contains the various endpoints that are targeted. 

Gatus can use [YAML anchors](https://github.com/TwiN/gatus#keeping-your-configuration-small) so its possible to DRY up the config file somewhat. 

Various [conditions](https://gatus.io/docs/conditions) are used to evaluate the health of the endpoints.

## Alerting 

It also integrates with several tools for alerting. [Slack](https://gatus.io/docs/alerting-slack) is the chosen method in this case. The Slack app can be found [here](https://api.slack.com/apps/A055J67H126/install-on-team) and the Webhook URL can be rotated if required.

## Docker Image

Builds an image for Linux and Arm. Pushes to [GitHub Artifact Registry]().
Pull the image via:

```
docker pull ghcr.io/celestial-industries/gatus/gatus:latest
```

## Binary

GitHub action checks out the main branch on the Gatus repo and uses elements of the standard [Dockerfile](https://github.com/TwiN/gatus/blob/master/Dockerfile) present in the Gatus repo to to build the Go binary via Alpine and stores the binary for use after.

GitHub action will clone the offical [Gautus repo](https://github.com/TwiN/gatus/tree/master) and build binary for linx, arm and arm64. As using [Raspberry Pi Zero](https://www.raspberrypi.com/products/raspberry-pi-zero-w/) to host this Docker is not used specifically as overhead on the limitted H/W available to the Pi Zero binary is easier. Also possible to install binary directly from [Gatus & Go](https://github.com/TwiN/gatus/tree/master#installing-as-binary). 

## SOPS & Age

[Sops](https://github.com/getsops/sops) and [Age](https://github.com/FiloSottile/age) are sed to encrypt specific sensitive values in the YAML config file.


### Encryption

``` bash
age-keygen -o key.txt
export SOPS_AGE_KEY_FILE=$(pwd)'/key.txt'
sops --encrypt --age $(cat $SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") --encrypted-regex '^INSERT_REGEX$' --in-place ./<FILENAME>
 sops --encrypt --age $(cat $SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") --encrypted-regex '^(webhook-url)$' --in-place ./config.enc.yaml
```

In the GH workflows for GH action for docker SOPS is installed and the AGE key is retrieved from a GH secret and ussed to decrypt the `config.enc.yaml`.

### Decryption

To edit the `config.enc.yaml` locally run:

``` bash
export SOPS_AGE_KEY_FILE=$(pwd)'/key.txt'
sops --decrypt ./config.enc.yaml > conifg.yaml
sops --encrypt --age $(cat $SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") --encrypted-regex '^(webhook-url)$' ./config.yaml > config.enc.yaml
```

Remove unencrypted file afterwards although it is excluded via `.gitignore` if named `config.yaml`.
``` bash
rm config.yaml
```

## GitHub Container Registry

GitHub Container registry (GHCR) is used to store the image and need to authenticate to the registry in order to pull the image. Ensure using a PAT to auth to GH cli and then run:

```
gh auth token | docker login ghcr.io -u $USERNAME --password-stdin
```

The PAT needs certain permissions to read from packages.
