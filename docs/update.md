# Update

Cloudbreak has a built in solution to keep it up-to-date.

## Update Cloudbreak Deployer

The cloudbreak-deployer tool is capable of upgrading itself to a newer version.

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
- Remove obsolete containers, if other Cloudbreak instance doesn't use old versions:
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
> Since Cloudbreak needs to download updated docker images for the new version, this step may take a while.