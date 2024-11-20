# Variables
DOCKER_IMAGE = seal-benchmark
ENCLAVE_FILE = seal-enclave.eif
CPU_COUNT = 2
MEMORY_MB = 2048

.PHONY: build_docker build_enclave run_docker run_enclave clean

# Build the Docker image
build_docker:
	docker build -t $(DOCKER_IMAGE) .

# Build the enclave image from Docker image
build_enclave: build_docker
	nitro-cli build-enclave --docker-uri $(DOCKER_IMAGE):latest --output-file $(ENCLAVE_FILE)

# Run the benchmark in Docker
run_docker:
	docker run --rm $(DOCKER_IMAGE)

# Run the benchmark in Nitro Enclave and show console output
run_enclave:
	@echo "Starting enclave..."
	nitro-cli run-enclave --cpu-count $(CPU_COUNT) --memory $(MEMORY_MB) --eif-path $(ENCLAVE_FILE) --debug-mode
	@echo "Console output:"
	nitro-cli console --enclave-name seal-enclave

# Clean up built images
clean:
	docker rmi $(DOCKER_IMAGE) || true
	rm -f $(ENCLAVE_FILE) || true
