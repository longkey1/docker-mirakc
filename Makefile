.DEFAULT_GOAL := help

MIRAKC_VERSION := $(shell cat .mirakc-version | tr -d '[:space:]')
RECISDB_RS_VERSION := $(shell cat .recisdb-rs-version | tr -d '[:space:]')
MIRAVIEW_VERSION := $(shell cat .miraview-version | tr -d '[:space:]')

# Combine component versions without their optional leading v.
NEXT_TAG := $(patsubst v%,%,$(MIRAKC_VERSION))-$(patsubst v%,%,$(RECISDB_RS_VERSION))-$(patsubst v%,%,$(MIRAVIEW_VERSION))

dryrun ?= true
tag    ?=

.PHONY: release
release: ## Release a new build. Usage: make release [dryrun=false]
	@echo "mirakc version : $(MIRAKC_VERSION)"
	@echo "recisdb version: $(RECISDB_RS_VERSION)"
	@echo "miraview version: $(MIRAVIEW_VERSION)"
	@echo "Next tag       : $(NEXT_TAG)"
	@if [ "$(dryrun)" = "false" ]; then \
		echo "Pushing to origin/master..."; \
		git push origin master --no-verify --force-with-lease; \
		echo "Creating tag $(NEXT_TAG)..."; \
		git tag -a $(NEXT_TAG) -m "Release $(NEXT_TAG)"; \
		git push origin $(NEXT_TAG); \
		echo "Creating GitHub release $(NEXT_TAG)..."; \
		gh release create $(NEXT_TAG) --title "Release $(NEXT_TAG)" --notes ""; \
		echo "Release $(NEXT_TAG) created."; \
	else \
		echo "[DRY RUN] Would push to origin/master"; \
		echo "[DRY RUN] Would create and push tag: $(NEXT_TAG)"; \
		echo "[DRY RUN] Would create GitHub release: $(NEXT_TAG)"; \
		echo ""; \
		echo "To execute, run:"; \
		echo "  make release dryrun=false"; \
	fi

.PHONY: re-release
re-release: ## Re-release an existing tag. Usage: make re-release [tag=<tag>] [dryrun=false]
	@TAG="$(tag)"; \
	if [ -z "$$TAG" ]; then \
		TAG=$$(git describe --tags --abbrev=0 2>/dev/null); \
	fi; \
	if [ -z "$$TAG" ]; then \
		echo "Error: No tag found. Specify with tag=<tag>."; \
		exit 1; \
	fi; \
	echo "Target tag: $$TAG"; \
	if [ "$(dryrun)" = "false" ]; then \
		echo "Deleting GitHub release..."; \
		gh release delete "$$TAG" --yes || true; \
		echo "Deleting local tag..."; \
		git tag -d "$$TAG"; \
		echo "Deleting remote tag..."; \
		git push origin ":refs/tags/$$TAG"; \
		echo "Recreating tag at HEAD..."; \
		git tag -a "$$TAG" -m "Release $$TAG"; \
		git push origin "$$TAG"; \
		echo "Creating GitHub release $$TAG..."; \
		gh release create "$$TAG" --title "Release $$TAG" --notes ""; \
		echo "Done!"; \
	else \
		echo "[DRY RUN] Would re-release tag: $$TAG"; \
		echo ""; \
		echo "To execute, run:"; \
		if [ -n "$(tag)" ]; then \
			echo "  make re-release tag=$$TAG dryrun=false"; \
		else \
			echo "  make re-release dryrun=false"; \
		fi; \
	fi

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
