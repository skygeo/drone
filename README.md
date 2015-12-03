[![Build Status](http://drone.eu-west-1.prod.aws.skyscanner.local/api/badges/slingshot/drone-ci/status.svg)](http://drone.eu-west-1.prod.aws.skyscanner.local/slingshot/drone-ci)

Drone
=====

Drone is a Continuous Integration platform built on container technology. Every build is executed inside an ephemeral Docker container, giving developers complete control over their build environment with guaranteed isolation.

This was forked from https://github.com/drone/drone.

**What was patched**
- Custom CI pipeline. See .drone.yml
- Patch gitlab integration: we've reduce the size of the hook token for the webhook length to be < 255.


**How to deploy**

1. Deploy the CF script: http://git.prod.skyscanner.local/slingshot/aws-provisioning/blob/master/DockerPaaS/cloudformation/slingshot_drone_cf_stack.json
2. Update the parameters 'DroneTag' to latest, or master, or <branchName>

**Ho to update the cluster**
1. SSH into the box
2. re-run the cf-init script
```
/opt/aws/bin/cfn-init -v --stack slg-drone --resource DroneLaunchConfig --configsets InstallAndRun  --region eu-west-1
```