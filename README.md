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

