
FROM centurylink/ca-certs
EXPOSE 8000

ENV DATABASE_DRIVER=sqlite3
ENV DATABASE_CONFIG=/var/lib/drone/drone.sqlite

ADD drone_static /drone_static

ENTRYPOINT ["/drone_static"]
