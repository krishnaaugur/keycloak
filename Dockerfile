FROM quay.io/keycloak/keycloak:latest AS builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure PostgreSQL database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# Copy custom providers/themes if present
COPY keycloak-26.7.4/providers/ /opt/keycloak/providers/
COPY keycloak-26.7.4/themes/ /opt/keycloak/themes/

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Keycloak behind Render reverse proxy
ENV KC_HTTP_ENABLED=true
ENV KC_PROXY_HEADERS=xforwarded

EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]
