FROM golang:1.5.1
ENV GO15VENDOREXPERIMENT=1
# install dependencies
RUN apt-get update && apt-get -y install zip libsqlite3-dev sqlite3 patch
# Get drone
RUN wget https://github.com/drone/drone/archive/master.tar.gz \ 
    && mkdir -p $GOPATH/src/github.com/drone/ \
    && tar -xzf master.tar.gz \
    && mv drone-master/ $GOPATH/src/github.com/drone/drone

WORKDIR /go/src/github.com/drone/drone

# patch and build drone
RUN contrib/setup-sassc.sh && contrib/setup-sqlite.sh
COPY *.patch ./
RUN patch -f controller/repo.go repo.patch
RUN patch -f controller/hook.go hook.patch
RUN patch -f controller/gitlab.go gitlab.patch
RUN patch -f remote/gitlab/gitlab.go remote_gitlab.patch
RUN make deps gen build

# Run config
EXPOSE 80/tcp
ENV DRONE_SERVER_PORT=:80
ENV DRONE_DATABASE_DATASOURCE=/var/lib/drone/drone.sqlite
ENV DRONE_DATABASE_DRIVER=sqlite3
ENTRYPOINT $GOPATH/src/github.com/drone/drone/drone
