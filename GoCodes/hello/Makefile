.PHONY: run build test fmt vet clean

run:
	go run .

build:
	go build -o bin/hello .

test:
	go test ./...

fmt:
	gofumpt -w .

vet:
	go vet ./...
	staticcheck ./...

clean:
	rm -rf bin
