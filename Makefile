COMMIT_MESSAGE = "chore: update profile [skip ci]"

all: build/README.md commit push

build:
	git clone -b main --single-branch "https://github.com/RangHo/rangho" build
	( \
		cd build; \
		git config --local user.name "github-actions[bot]"; \
		git config --local user.email "41898282+github-actions[bot]@users.noreply.github.com"; \
		git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/RangHo/rangho"; \
	)
	rm -f build/README.md

build/README.md: build
	for script in $$(find scripts -executable -type f | sort); do \
		./$$script; \
	done
	cp README.md build/README.md
	for untracked in $$(git ls-files --others --exclude-standard); do \
		cp $$untracked build/; \
	done

commit:
	( \
		cd build; \
		git add --all; \
		git commit -m $(COMMIT_MESSAGE); \
	)

push:
	( \
		cd build; \
		git push origin main; \
	)

clean:
	git ls-files --others --exclude-standard | xargs rm -rf

.PHONY: all commit push clean
