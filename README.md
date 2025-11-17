# uv-bug — Reproducible workspace + `--locked` setup

This repo provides a minimal reproducable example for the potantial bug related to `uv` workspaces and locking.

The setup is as follows:

- A root `pyproject.toml`, with at least one workspace package (`packages/examplelib`)
- The workspace package `packages/examplelib` is depended upon in the root via `[tool.uv.sources]`, as described in the [official docs](https://docs.astral.sh/uv/concepts/projects/workspaces/#workspace-sources).
- A Dockerfile that follows the [official `uv` template](https://docs.astral.sh/uv/concepts/projects/workspaces/#workspace-sources).


## How to reproduce

1) First, run `uv` sync, with `--all-packages` to also build the workspace package:
```
uv sync --all-packages
```
- This will produce a `uv.lock` file in the root.

2) Build the Dockerfile:
```
docker build -t uv-bug:repro .
```
- This should then fail with the error message:
- `The lockfile at uv.lock needs to be updated, but --locked was provided. To update the lockfile, run uv lock`


For confirmation, we can change the `ro` parameter in line 12 of the Dockerfile, giving it write access, and then removing the `--locked` parameter.

It should result in **no changes** to the `uv.lock` file, indicating that the lock file is indeed not outdated.