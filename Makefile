
.PHONY: build
build:
	cargo build --release

.PHONY: check
check: lint test build

.PHONY: lint
lint: setup-js
	cargo clippy -- --deny warnings
	cargo fmt --check
	bun x -- bun-dx --package readme-cli-help readme-cli-help -- check
	bun x -- bun-dx --package @biomejs/biome biome -- check

.PHONY: format
format: setup-js
	cargo clippy
	cargo fmt
	bun x -- bun-dx --package readme-cli-help readme-cli-help -- update
	bun x -- bun-dx --package @biomejs/biome biome -- check --write

.PHONY: setup
setup: setup-js

.PHONY: setup-js
setup-js:
	bun install --frozen-lockfile

.PHONY: test
test: cargo-test test-behaviour

.PHONY: cargo-test
cargo-test:
	cargo test

.PHONY: test-behaviour
test-behaviour: setup-js
	bun test --timeout 15000

.PHONY: publish
publish:
	# `--no-verify` is a workaround for https://github.com/rust-lang/cargo/issues/8407
	cargo publish --no-verify

.PHONY: install
install:
	cargo install --path .

.PHONY: uninstall
	cargo uninstall folderify

RM_RF = bun -e 'process.argv.slice(1).map(p => process.getBuiltinModule("node:fs").rmSync(p, {recursive: true, force: true, maxRetries: 5}))' --

.PHONY: clean
clean:
	@ # no-op for now

.PHONY: reset
reset: clean
	${RM_RF} ./target/
