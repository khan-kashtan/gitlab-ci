## Test deploy gitlab-ci at Google Cloud with CI pipeline

#### To create http allow rule via gcloud-CLI (default network):

``` bash
gcloud compute firewall-rules create allow-http \
--allow tcp:80,tcp:8080,tcp:443 \
--target-tags=http-allow \
--description="Allow HTTP/HTTPS connection" \
--direction=INGRESS
```

#### To create gitlab-host via docker-machine (default network):

* Change <GCP_project_ID> and run:
``` bash
docker-machine create --driver google \
--google-project <GCP_project_ID> \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts \
--google-machine-type n1-standard-1 \
--google-zone europe-west1-b \
--google-disk-type pd-standard \
--google-disk-size 100 \
--google-tags http-allow \
gitlab-host
```

#### To deploy GitLab application at gitlab-host:

1. Change <project_ID> and <service_account_credencials> at dynamo.gcp.yml.example *1
2. Rename dynamo.gcp.yml.example to dynamo.gcp.yml *1
3. Use ansible/set-ip.sh

*1 Or use other way like setting simple ini-format inventory file

#### To create Runner:

1. Create runner as a container:
```
docker run -d --name gitlab-runner --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```
2. Get URL and registration token at GitLab Settings - CI/CD - Runners

3. Register your container as a runner:

``` bash
# registration initialization
docker exec -it gitlab-runner gitlab-runner register --run-untagged --locked=false

# Enter the GitLab instance URL (for example, https://gitlab.com/):
<enter your URL from point 2.>

# Enter the registration token:
<enter your token from point 2.>
# Enter a description for the runner:
my-runner
# Enter tags for the runner (comma-separated):
linux,xenial,ubuntu,docker
# Enter an executor: docker, ssh, virtualbox, shell, docker+machine, docker-ssh+machine, kubernetes, custom, docker-ssh, parallels:
docker
# Enter the default Docker image (for example, ruby:2.6):
alpine:latest
```

Success!
