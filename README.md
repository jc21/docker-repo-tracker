# Repo Tracker

For when you want to keep track of changes in someone's Git Repo and take action.

This is a simple docker process to check `repo1` for changes and then run a script of your making
to make changes and/or push commits to `repo2`.


### A simple use case

I have a `docker-electroneumd` Github repository that when has new commits, will trigger a new build
on Docker Hub. As part of the build process it will checkout code from `electroneum/electroneum` which
I don't own and is not forked.

So, I'll use Repo Tracker to periodically check for new commits on that repository and then it will
fire a script to update the latest commit ID in a file on my docker repository and commit it.

This fires the automatic build and I don't have to worry.


### How to use it

The docker image runs a single process to check the repository (`repo1`) and then exits. It does not
continually run. You might want to create a cron job on the docker host to run it periodically.

First, clone your git repositories. The first repository is the one you want to track. The second is
the one you want to take action on.

Next, create an action script. Check the `examples` folder for some inspiration. Then you're ready to
run the docker process:

```bash
docker run --rm \
  -e GIT_NAME="Joe Citizen" \
  -e GIT_EMAIL="joe@example.com" \
  -v /path/to/repo1:/repo1 \
  -v /path/to/repo2:/repo2 \
  -v /path/to/action_script.sh:/action_script.sh \
  jc21/repo-tracker
```

**Here's what will happen:**

1. The process will get the head commit id from `repo1`
2. The process will `git pull` on `repo1`
3. It will get the new head commit id on `repo1` and IF the commit id is different:
4. It will execute the action script with arguments about the latest commit.

