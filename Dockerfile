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
ARG namespace

ENV TAG = ${tag}
ENV IMAGE = ${image}
ENV PROJECT_ID = ${project}
ENV CLUSTER_ID = ${project_clusterID}
ENV CLUSTER_NAME = ${project_cluster_name}
ENV CLUSTER_LOCATION = ${project_location}

COPY . /home

RUN mkdir -p /github/workspace \
    cd /home \
    && apk add curl nodejs npm \
    && npm install

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && chmod +x kubectl \
    && mkdir -p ~/.local/bin \
    && mv ./kubectl ~/.local/bin/kubectl \
    && kubectl version --client

# RUN curl -sfLo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.1.0/kustomize_3.1.0_linux_amd64 \
#     && chmod u+x ./kustomize

WORKDIR "/github/workspace"

RUN chmod +x /home/entrypoint.sh
ENTRYPOINT ["sh", "/home/entrypoint.sh"]
