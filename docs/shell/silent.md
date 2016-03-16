## Silent mode

With Cloudbreak Shell you can execute script files as well. A script file contains shell commands and can 
be executed with the `script` cloudbreak shell command

```
script <your script file>
```

or with the `cbd util cloudbreak-shell-quiet` command

```
cbd util cloudbreak-shell-quiet < example.sh
```

>**IMPORTANT** You have to copy all your files into the `cbd` working directory, what you would like to use in shell.
 For example if your `cbd` working directory is ~/cloudbreak-deployment then copy your script file to here.
