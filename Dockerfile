FROM golang:1.5.1
ENV GO15VENDOREXPERIMENT=1
# install dependencies
RUN apt-get update && apt-get -y install zip libsqlite3-dev sqlite3 patch
WORKDIR /go/src/github.com/drone/drone
COPY . /go/src/github.com/drone/drone

# patch and build drone
RUN contrib/setup-sassc.sh && contrib/setup-sqlite.sh
RUN make deps gen build

# Run config
EXPOSE 80/tcp
ENV DRONE_SERVER_PORT=:80
ENV DRONE_DATABASE_DATASOURCE=/var/lib/drone/drone.sqlite
ENV DRONE_DATABASE_DRIVER=sqlite3
ENTRYPOINT $GOPATH/src/github.com/drone/drone/drone
