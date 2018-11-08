# todo

* [/] local development doesn't support public/ 
    + use ngrok? --> annoying: free account creates a new url each time so we should update github app's settings each time
    + set up a sshfs to a huelmo dev-public/? <-------------- WIP
    + set up independent file servers at huelmo for both dev and prod that are always online --> which one?
        - https://github.com/richardgirges/express-fileupload
* [ ] replace hardcoded "../public/" 
    + with an environment variable that can be customized dev/prod?
    + with other mechanism?
* [ ] explore PR API (comments, status, more?)
* [ ] explore checks API
* [ ] pharo: split server from demo
* [ ] add own tests

# Variants

Server at localhost and have client in:
* vscode
* pharo without roassal (show a svg or png or a fuelized morph)
* pharo with roassal
    --> keep interactivity
    --> fuel in and out
    --> useful only if processing packages are big so user avoids installing on each image
