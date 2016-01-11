package testdata

import (
	"net/http"
	"net/http/httptest"
)

// setup a mock server for testing purposes.
func NewServer() *httptest.Server {
	mux := http.NewServeMux()
	server := httptest.NewServer(mux)

	// handle requests and serve mock data
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		//println(r.URL.Path + "  " + r.Method)
		// evaluate the path to serve a dummy data file
		switch r.URL.Path {
		case "/api/v3/projects":
			w.Write(projectsPayload)
			return
		case "/api/v3/projects/diaspora/diaspora-client":
			w.Write(project4Paylod)
			return
		case "/api/v3/projects/diaspora/diaspora-client/services/drone-ci":
			switch r.Method {
			case "PUT":
				if r.FormValue("token") == "" {
					w.WriteHeader(404)
				} else {
					w.WriteHeader(201)
				}
			case "DELETE":
				w.WriteHeader(201)
			}

			return
		case "/oauth/token":
			w.Write(accessTokenPayload)
			return
		case "/api/v3/user":
			if r.Header.Get("Authorization") == "Bearer valid_token" {
				w.Write(currentUserPayload)
			} else {
				w.WriteHeader(401)
			}
			return
		}

		// else return a 404
		http.NotFound(w, r)
	})

	// return the server to the client which
	// will need to know the base URL path
	return server
}
