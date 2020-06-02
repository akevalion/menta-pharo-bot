# Menta
<img src="assets/mint.png" alt="logo" width="100"/>

> A small [Pharo](https://pharo.org/) example/framework that start creating your own GitHub App that interacts with GitHub via their APIs and webhooks.

## How to use

The `server/build.sh ` script downloads a Pharo image, loads the code and it's dependencies. 

Setup your Github app with and id and PEM private key. Read class comments of `MeGithubApp` and subclasses to learn about it.

The `server/start.sh` script starts the Pharo image in headless mode. The image will start two servers: a HTTP server (3000 by default) and a VNC server (5900, the default port).

## License

[MIT license](https://mit-license.org/).

## Logo

Thanks to https://openclipart.org/detail/192959/mint-two
