# Menta

A small [Pharo](https://pharo.org/) example that can serve as a starting point to create your own GitHub App. 

The example GH App shows how to react to new comments in a repository's issues by posting a Roassal2 visualization. The interaction with GitHub is done via their REST API and webhooks.

<img src="assets/mint.png" alt="logo" width="100"/>

## How to use

The `./server/build.sh ` script downloads a Pharo image, loads the code and it's dependencies. 

Browse the code by starting the image with `./pharo-ui Pharo.image` in the `server/build` directory.

To interact with GitHub, you must setup your GitHub App with an ID and PEM private key. Read class comments of `MeGithubApp` and subclasses to learn about it.

Deploy on a server that can be accessed via two ports. The `./server/start.sh` script starts the Pharo image in headless mode with: 
- HTTP server (port 3000 by default) to receive GH webhook requests.
- VNC server (port 5900 by default) to allow debugging on deploy environemt with a VNC client.

## CI status

![CI](https://github.com/tinchodias/menta-pharo-bot/workflows/CI/badge.svg)

## License

[MIT license](https://mit-license.org/).

## Logo

Thanks to https://openclipart.org/detail/192959/mint-two
