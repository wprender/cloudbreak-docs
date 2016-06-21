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
