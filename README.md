# Gatus

Light weight status and monitoring tool. This repo contains config for buildin a multi arch Docker image and also creating binary for running on Pi Zero to monitor various endpoints. Docker image is opushed to DockerHub and the biary stored as an artifact in GitHub.

For reference and documentation on Gatus see:

- [Gatus](https://gatus.io/)
- [GitHub Repo](https://github.com/TwiN/gatus)
- [DockerHub](https://hub.docker.com/r/twinproduction/gatus)

## Config file
The config file contains the various endpoints that are targeted. 

Gatus can use [YAML anchors](https://github.com/TwiN/gatus#keeping-your-configuration-small) so its possible to DRY up the config file somewhat. 

Various [conditions](https://gatus.io/docs/conditions) are used to evaluate the health of the endpoints.

## Alerting 

It also intergrates with several tools for alerting. [Slack](https://gatus.io/docs/alerting-slack) is the chosen method in this case.

## Docker Image

Builds an image for Linux and Arm. Pushes to [DockerHub]()

## Binary

GitHub action checks out the main branch on the Gatus repo and uses elements of the standard [Dockerfile](https://github.com/TwiN/gatus/blob/master/Dockerfile) present in the Gatus repo to to build the Go binary via Alpine and stores the binary for use after.

GitHub action will clone the offical [Gautus repo](https://github.com/TwiN/gatus/tree/master) and build binary for linx, arm and arm64. As using [Raspberry Pi Zero](https://www.raspberrypi.com/products/raspberry-pi-zero-w/) to host this Docker is not used specifically as overhead on the limitted H/W available to the Pi Zero binary is easier. Also possible to install binary directly from [Gatus & Go](https://github.com/TwiN/gatus/tree/master#installing-as-binary). 

## SOPS & Age

[Sops](https://github.com/getsops/sops) and [Age](https://github.com/FiloSottile/age) are sed to encrypt specific sensitive values in the YAML config file.

``` bash
age-keygen -o key.txt
export SOPS_AGE_KEY_FILE=$(pwd)'/key.txt
sops --encrypt --age $(cat $SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") --encrypted-regex '^INSERT_REGEX$' --in-place ./<FILENAME>
 sops --encrypt --age $(cat $SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") --encrypted-regex '^(webhook-url)$' --in-place ./config.enc.yaml
```

In the GH workflows for GH action binary and the docker actions this file is decrypted as one of the initial steps.

