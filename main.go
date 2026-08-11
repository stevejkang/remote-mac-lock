package main

// #cgo LDFLAGS: -F /System/Library/PrivateFrameworks -framework login
// extern int SACLockScreenImmediate(void);
import "C"

import (
	"bufio"
	"crypto/subtle"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"strconv"
	"strings"
)

func loadEnv(path string) {
	f, err := os.Open(path)
	if err != nil {
		return
	}
	defer f.Close()

	s := bufio.NewScanner(f)
	for s.Scan() {
		line := strings.TrimSpace(s.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		k, v, ok := strings.Cut(line, "=")
		if !ok {
			continue
		}
		k = strings.TrimSpace(k)
		v = strings.TrimSpace(v)
		v = strings.Trim(v, `"'`)
		if os.Getenv(k) == "" {
			os.Setenv(k, v)
		}
	}
}

func lockScreen() error {
	ret := C.SACLockScreenImmediate()
	if ret != 0 {
		return fmt.Errorf("SACLockScreenImmediate returned %d", ret)
	}
	return nil
}

func basicAuth(next http.HandlerFunc, user, pass string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		u, p, ok := r.BasicAuth()
		if !ok ||
			subtle.ConstantTimeCompare([]byte(u), []byte(user)) != 1 ||
			subtle.ConstantTimeCompare([]byte(p), []byte(pass)) != 1 {
			w.Header().Set("WWW-Authenticate", `Basic realm="restricted"`)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}
		next(w, r)
	}
}

func handleLock(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	if err := lockScreen(); err != nil {
		log.Printf("Failed to execute lockscreen: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]any{"ok": false, "error": "Failed to lock screen"})
		return
	}

	json.NewEncoder(w).Encode(map[string]any{"ok": true})
}

func main() {
	if home, err := os.UserHomeDir(); err == nil {
		loadEnv(home + "/.config/remote-mac-lock/.env")
	}
	loadEnv(".env")

	user := os.Getenv("BASIC_AUTH_USER")
	pass := os.Getenv("BASIC_AUTH_PASS")

	const defaultPort = 61000
	const maxRetries = 10

	port := defaultPort
	if p := os.Getenv("PORT"); p != "" {
		if v, err := strconv.Atoi(p); err == nil {
			port = v
		}
	}

	handler := http.HandlerFunc(handleLock)
	if user != "" && pass != "" {
		http.HandleFunc("GET /lock", basicAuth(handler, user, pass))
	} else {
		log.Println("Warning: running without basic authentication")
		http.HandleFunc("GET /lock", handler)
	}

	var ln net.Listener
	for i := range maxRetries {
		var err error
		ln, err = net.Listen("tcp", ":"+strconv.Itoa(port+i))
		if err == nil {
			port = port + i
			break
		}
		if i == maxRetries-1 {
			log.Fatalf("Failed to bind to ports %d-%d", defaultPort, defaultPort+maxRetries-1)
		}
	}

	log.Printf("App listening on port %d", port)
	log.Fatal(http.Serve(ln, nil))
}
