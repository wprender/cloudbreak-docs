# Update Cloudbreak Deployer

To update Cloudbreak Deployer to the newest version, run the following commands on the console where your `Profile` is located:

- Stop all of the running Cloudbreak components:
```
cbd kill
```
- Update Cloudbreak Deployer:
```
cbd update
```
- Update the `docker-compose.yml` file with new Docker containers that are needed for the `cbd`:
```
cbd regenerate
```
- If there are no other Cloudbreak instances that still use old Cloudbreak versions, remove the obsolete containers:
```
cbd util cleanup
```
- Check the health and version of the updated `cbd`: 
```
cbd doctor
```
- Start the new version of the `cbd`:
```
cbd start
```
> Cloudbreak needs to download updated docker images for the new version, so this step may take a while.

# Update existing clusters

If the Cloudbreak has been updated to `1.4.0` version then existing clusters that are provisioned by the previous `1.3.0` version needs to be updated to be still managable through Cloudbreak.

To update existing clusters from `1.3.0` to `1.4.0` version, run the following commands on the `cbgateway` node of the cluster:

- Update the version of the Salt-Bootsrap tool on the nodes:
```
salt '*' cmd.run 'curl -Ls https://github.com/sequenceiq/salt-bootstrap/releases/download/v0.1.2/salt-bootstrap_0.1.2_Linux_x86_64.tgz | tar -zx -C /usr/sbin/ salt-bootstrap'
```
- Trigger restart of tool on the nodes:
```
salt '*' service.dead salt-bootstrap
```
> **NOTE** Checking the version of the Salt-Bootsrap on the nodes:
>
>```
>salt '*' cmd.run 'salt-bootstrap --version'
>```