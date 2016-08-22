# Update Cloudbreak Deployer

To update Cloudbreak Deployer to the newest version, run the following commands on the console where your `Profile` is located:

**Step 1:** Stop all of the running Cloudbreak components:
```
cbd kill
```
**Step 2:** Update Cloudbreak Deployer:
```
cbd update
```
**Step 3:** Update the `docker-compose.yml` file with new Docker containers needed for the `cbd`:
```
cbd regenerate
```
**Step 4:** If there are no other Cloudbreak instances that still use old Cloudbreak versions, remove the obsolete containers:
```
cbd util cleanup
```
**Step 5:** Check the health and version of the updated `cbd`: 
```
cbd doctor
```
**Step 6:** Start the new version of the `cbd`:
```
cbd start
```
> Cloudbreak needs to download updated docker images for the new version, so this step may take a while.
