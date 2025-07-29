efault: help
.PHONY: help clean fastcms install test test-cov test-cov-o tree

## This help screen
help:
	@printf "Available targets:\n\n"
	@awk '/^[a-zA-Z\-\_0-9%:\\ ]+/ { \
	  helpMessage = match(lastLine, /^## (.*)/); \
	  if (helpMessage) { \
	    helpCommand = $$1; \
	    helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
	    gsub("\\\\", "", helpCommand); \
	    gsub(":+$$", "", helpCommand); \
	    printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
	  } \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"


## Cleanup the code base (remove the tests and coverage files)
clean:
	@echo "Cleaning up the code base"
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -delete
	@find . -name ".coverage" -delete
	@find . -name ".pytest_cache" -delete
	@find . -name "htmlcov" -type d -exec rm -rf {} +
	@echo "Done"


## Add fastcms from the source code
fastcms:
	@echo "Adding fastcms from the source code"
	@uv lock --upgrade-package fastcms
	@uv add "fastcms @ git+https://github.com/azataiot/fastcms"
	@echo "Done"


## Install DEV and TEST dependencies
install:
	@echo "Installing development and test dependencies..."
	@uv sync --dev --group test


## Test
test:
	@uv run pytest

## Test with coverage
test-cov:
	@uv run pytest --cov=apps --cov-report=term-missing --cov-report=html

## Test with coverage and open the report in browser
test-cov-o:
	@uv run pytest --cov=apps --cov-report=term-missing --cov-report=html && open htmlcov/index.html


## List the project structure (tree command)
tree:
	@echo "Listing the project structure"
	@tree -I 'node_modules|.venv|.git|__pycache__|.pytest_cache|htmlcov|.coverage' -L 3
	@echo "Done"


# Prevent Make from treating extra words as targets
%:
	@:
