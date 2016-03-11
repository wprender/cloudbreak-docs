The goal with the Cloudbreak Shell (Cloudbreak CLI) was to provide an interactive command line tool which supports:

- all functionality available through the REST API or Cloudbreak Web UI
- makes possible complete automation of management task via scripts
- context aware command availability
- tab completion
- required/optional parameter support
- hint command to guide you on the usual path

## Start Cloudbreak Shell

To start the Cloudbreak CLI use the following commands:

 - Open your `cloudbreak-deployment` directory if it is needed. For example:
```
   cd cloudbreak-deployment
```
 - Start the `cbd` from here if it is needed
```
   cbd start
```
 - In the root of your `cloudbreak-deployment` folder apply:
```
   cbd util cloudbreak-shell
```
>At the very first time it will take for a while, because of need to download all the necessary docker images.

This will launch the Cloudbreak shell inside a Docker container then it is ready to use.
![](/shell/image/shell-started_v2.png)
<sub>*Full size [here](/shell/image/shell-started_v2.png).*</sub>

>**IMPORTANT You have to copy all your files into the `cbd` working directory, what you would like to use in shell.** For 
example if your `cbd` working directory is `~/cloudbreak-deployment` then copy your **blueprint JSON, public ssh key 
file...etc.** to here. You can refer to these files with their names from the shell.

## Autocomplete and hints

Cloudbreak Shell helps to you with **hint messages** from the very beginning, for example:
```
cloudbreak-shell>hint
Hint: Add a blueprint with the 'blueprint add' command or select an existing one with 'blueprint select'
cloudbreak-shell>
```

Beyond this you can use the **autocompletion (double-TAB)** as well:

```
cloudbreak-shell>credential create --
credential create --AWS          credential create --AZURE        credential create --EC2          credential create --GCP          credential create --OPENSTACK
```
