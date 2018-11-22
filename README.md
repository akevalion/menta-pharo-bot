# Menta
<img src="assets/mint.png" alt="logo" width="100"/>

> A GitHub App built with [Probot](https://probot.github.io) that uses Pharo and Roassal2 to generate visualizations.


## Deployment Steps

1. Prepare:

```sh
./build_all.sh
./screen_start_all.sh
```

The Probot server will start at http://localhost:3000/. 

2. You need to browse this URL and press the Register button to create a Github App.

3. Create a file with the following environment variables:

```
export APP_ID=<number>
export PRIVATE_KEY_PATH=/path/to/private-key.pem
export WEBHOOK_SECRET=<random>
```

You can get this information from the Github App's configuration page (https://github.com/settings/apps/<APP_NAME>).

4. Update `report-server/start.sh` with the right URL.

5. Restart:

```sh
./screen_stop_all.sh
./screen_start_all.sh
```


## Contributing

If you have suggestions for how menta-pharo-bot could be improved, or want to report a bug, open an issue! We'd love all and any contributions.

For more, check out the [Contributing Guide](CONTRIBUTING.md).

## License

[ISC](LICENSE) © 2018 Martín Dias <tinchodias@gmail.com> (tinchodias.github.io)

## Logo/Avatar

Thanks to https://openclipart.org/detail/192959/mint-two
