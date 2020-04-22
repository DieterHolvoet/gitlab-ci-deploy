gitlab-ci-deploy
======================

![Latest Stable Version](https://img.shields.io/github/v/release/DieterHolvoet/gitlab-ci-deploy)
![Total Downloads](https://img.shields.io/github/downloads/DieterHolvoet/gitlab-ci-deploy/total)
![License](https://img.shields.io/github/license/DieterHolvoet/gitlab-ci-deploy)

> Reusable config for simple, SSH based deploys using [GitLab CI/CD]((https://docs.gitlab.com/ee/ci)).

## Requirements
- A server with SSH access, bash & rsync
- A repository hosted on Gitlab with the following files: `.gitlab-ci` and 
 `.deploy/.rsync-filter`. The [examples](#examples) can be used for 
 inspiration.

## Features
### Run pipelines using GitLab CI/CD
All this functionality is powered by **GitLab CI/CD**, check their 
 [documentation](https://docs.gitlab.com/ee/ci/) for more information.

### Deploy your files using rsync
The deployment of your files is done using 
 [rsync](http://manpages.ubuntu.com/manpages/eoan/en/man1/rsync.1.html):
- One-way sync, left to right
- Extraneous files are deleted from destination dirs
- Filter rules can be defined in the `.deploy/.rsync-filter` file.

To minimise downtime, the file sync will happen to a copy of your files 
 in a new _release_. After finishing the sync, the active release will be
 changed by replacing the symlink. A couple of settings can be changed 
 through variables:
- `RELEASES_FOLDER`: the name of the folder in which all releases are 
    stored (default: `releases`)
- `CURRENT_RELEASE_FOLDER`: the name of the folder to which the active 
    release is symlinked (default: `current`)
- `KEEP_RELEASES`: the amount of releases that should be kept (minimum: 1,
    default: 2)


A couple environment variables are required, check the [documentation](https://docs.gitlab.com/ee/ci/variables/) for ways to define them.
- `DEPLOY_SERVER_HOST`: the host of the server
- `DEPLOY_SERVER_USER`: the user used for SSH'ing
- `DEPLOY_SSH_PRIVATE_KEY`: the private key used for SSH'ing
- `DEPLOY_PATH`: the path the files should be deployed to

### Run a server-side script after deploy
If a `.deploy/post-deploy.sh` file exists, it will be executed on the 
 server after the deployment is finished. The current directory will be 
 equal to `DEPLOY_PATH`.

### Automatically generate .env files
A script is provided to automatically generate a .env file and serve it as
 an artifact in your pipeline. To add this functionality to your pipeline, 
 create a new job extending `.create_dotenv`:
 
 ```yaml
 dotenv:
   extends:
     - .create_dotenv
   stage: build
 ```
 
The script will take a `.env.example` file as starting point and fill in 
 the values using current environment variables. There are multiple ways 
 to define your environment variables, check the 
 [documentation](https://docs.gitlab.com/ee/ci/variables/) for more 
 information.

## Examples
Some examples are provided to get you started quickly.

### [`deploy-only`](examples/deploy-only)
- simple, deploy-only setup

### [`drupal-8`](examples/drupal-8)
- Drupal 8 website
- jobs for building a custom theme, .env file and installing Composer dependencies
- a set of Drush commands are executed after deploying.

### [`octobercms`](examples/octobercms)
- OctoberCMS website
- jobs for building a custom theme, .env file and installing Composer dependencies
- a set of Artisan commands are executed after deploying.
- staging environment which is automatically built and deployed after pushing to a [Gitflow-style](https://nvie.com/posts/a-successful-git-branching-model) release branch
- production environment which is automatically built, but manually deployed after pushing a [Semantic Versioning-style](https://semver.org) tag.
