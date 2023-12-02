FROM twinproduction/gatus:v5.7.0

ADD config.yaml /config/config.yaml

EXPOSE 80

HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/health || exit 1