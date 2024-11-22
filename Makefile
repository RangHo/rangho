GIT_COMMIT_MESSAGE = "chore: update profile [skip ci]"
GIT_USER_NAME = "github-actions[bot]"
GIT_USER_EMAIL = "41898282+github-actions[bot]@users.noreply.github.com"

all: build/README.md commit push

build:
	git clone -b main --single-branch "https://github.com/RangHo/rangho" build
	( \
		cd build; \
		git config --local user.name $(GIT_USER_NAME); \
		git config --local user.email $(GIT_USER_EMAIL); \
		git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/RangHo/rangho"; \
	)
	rm -f build/README.md

build/README.md: build
	for script in $$(find scripts -executable -type f | sort); do \
		./$$script; \
	done
	cp README.md build/README.md
	for untracked in $$(git ls-files --others --exclude-standard); do \
		[ -f $$untracked ] && cp $$untracked build/; \
	done

commit:
	( \
		cd build; \
		git add --all; \
		git commit -m $(GIT_COMMIT_MESSAGE); \
	)

push:
	( \
		cd build; \
		git push origin main; \
	)

clean:
	git ls-files --others --exclude-standard | xargs rm -rf

.PHONY: all commit push clean
