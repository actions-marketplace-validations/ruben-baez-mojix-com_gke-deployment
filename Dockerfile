FROM alpine:3.10

LABEL version="1.1.0"
LABEL repository=""
LABEL homepage=""
LABEL maintainer="Ruben"
LABEL "com.github.actions.name"="GKE deployment"
LABEL "com.github.actions.description"="Run GKE deployment"
LABEL "com.github.actions.icon"="check"
LABEL "com.github.actions.color"="red"

ARG image
ARG project
ARG tag
ARG sha
ARG deploy
ARG project_location
ARG project_clusterID
ARG project_cluster_name

ENV CLUSTER_ID = ${project_clusterID}
ENV CLUSTER_NAME = ${project_cluster_name}
ENV CLUSTER_LOCATION = ${project_location}

COPY . .

RUN apk add curl nodejs npm
RUN npm install 

RUN curl -sfLo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.1.0/kustomize_3.1.0_linux_amd64 \
    && chmod u+x ./kustomize

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
