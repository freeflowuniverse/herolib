

## OSX

to use with herocontainers

- https://herocontainers-desktop.io/docs/migrating-from-docker/using-the-docker_host-environment-variable

could export the path

```bash
export DOCKER_HOST=unix:///Users/despiegk1/.local/share/containers/herocontainers/machine/qemu/herocontainers.sock

#had to install docker to get some docker tools, but was not running it
brew install --cask docker
cd /tmp
git clone git@git.ourworld.tf:despiegk/test.git
cd test
actrunner exec
```

will run the runner locally

