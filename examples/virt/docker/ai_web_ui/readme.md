# AI Web UI

- make docker build (see docker_ubuntu example)
  - start from docker_ubuntu
  - install the web UI: openwebui (not by docker but use uv to install this software)
  - use https://github.com/astral-sh/uv for the python part
  - as last step, clean it all up (remove apt cache, ...)
- push to threefold docker hub
  - convert in TF Hub from the docker
- have .vsh script which deploys this solution on TFGrid behind webgw and get people to login
  - use wireguard to access the machine (as part of .vsh script)
- make tutorial, so everyone can do it, we will use this to show community how to do something with AI on our grid
