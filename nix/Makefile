CONTAINER_NAME := nix-iso-builder

# We can't build linux on osx.
builder-iso:
	podman build --platform linux/arm64 -t nix-builder ./hemera
	podman volume create nix-eval-cache || true

check: builder-iso
	# Even the check needs to run in the builder ...
	podman run --rm \
		-v "$$PWD":/workspace -w /workspace \
		-v nix-eval-cache:/root/.cache/nix \
		nix-builder /bin/sh -c 'nix flake check --all-systems --no-build --show-trace'
	

# Build an iso for a Hemera VM.
# Runs on OSX, using podman for a builder image.
hemera-iso: builder-iso
	@echo "Using persistent container: $(CONTAINER_NAME)"
	@if podman container exists $(CONTAINER_NAME) 2>/dev/null; then \
		echo "Reusing existing container (with cached store)..."; \
		podman start -a $(CONTAINER_NAME); \
	else \
		echo "Creating new container (first build will be slow)..."; \
		podman run --name $(CONTAINER_NAME) -it --privileged \
			--security-opt seccomp=unconfined --security-opt label=disable \
			-v "$$PWD":/workspace -w /workspace \
			-v nix-eval-cache:/root/.cache/nix \
			nix-builder \
			/bin/sh -c 'nix build \
				--option sandbox false \
				--option filter-syscalls false \
				.#packages.aarch64-linux.hemera-iso \
				&& cp -L result/iso/*.iso /workspace/nixos-$$(date +%Y%m%d-%H%M%S).iso \
				&& echo "ISO copied successfully"'; \
	fi
	@echo "Build complete! ISO file:"


clean-cache:
	podman volume rm nix-eval-cache

clean-container:
	@echo "Removing container (will lose cached store)..."
	podman rm -f $(CONTAINER_NAME) 2>/dev/null || true

clean: clean-container clean-cache

clean-iso:
	rm -f nixos-*.iso result

.PHONY: iso clean-cache clean-container clean clean-iso
