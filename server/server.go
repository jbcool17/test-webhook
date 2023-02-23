package server

import (
	"flag"
	"log"
	"net/http"
)

var (
	port    string
	tlskey  string
	tlscert string
)

func hello(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte("Hello World.\n"))

	log.Printf("Hello World - %v", req)
}

func Start() {
	// flag.StringVar(&tlscert, "tlscert", "certs/webhook-server-tls.crt", "Path to the TLS certificate")
	// flag.StringVar(&tlskey, "tlskey", "certs/webhook-server-tls.key", "Path to the TLS key")
	flag.StringVar(&tlscert, "tlscert", "/etc/certs/tls.crt", "Path to the TLS certificate")
	flag.StringVar(&tlskey, "tlskey", "/etc/certs/tls.key", "Path to the TLS key")
	flag.StringVar(&port, "port", "8443", "The port to listen")
	flag.Parse()

	http.HandleFunc("/", hello)
	http.HandleFunc("/mutate", postTest)
	http.HandleFunc("/validate", postTest)

	log.Printf("Starting server at port 8443\n")

	err := http.ListenAndServeTLS(":8443", tlscert, tlskey, nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
