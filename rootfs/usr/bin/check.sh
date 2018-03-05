#!/bin/bash

# Set git config if env vars are set

if [ ! -z GIT_NAME ]; then
    git config --global user.name "$GIT_NAME"
    echo "Set git name to: $GIT_NAME"
fi

if [ ! -z GIT_EMAIL ]; then
    git config --global user.email "$GIT_EMAIL"
    echo "Set git email to: $GIT_EMAIL"
fi


# Check Repos

REPO1=/repo1
REPO2=/repo2

# Check that `/repo1` and `/repo2` are git repositories

if [ ! -d "$REPO1/.git" ]; then
  echo "ERROR: /repo1 doesn't appear to be a GIT repository!"
  exit 1
fi

if [ ! -d "$REPO2/.git" ]; then
  echo "ERROR: /repo2 doesn't appear to be a GIT repository!"
  exit 1
fi

DTE=`date`
echo "[$DTE]  Repos exist"

# 1. Get commit id from repo1
cd $REPO1
REPO1_HEAD_1=`git rev-parse HEAD`

DTE=`date`
echo "[$DTE]  HEAD: $REPO1_HEAD_1"

# 2. Pull repo1
cd $REPO1
git pull --no-edit

if [ $? != 0 ]; then
  echo "ERROR: Failed to pull repo1"
  exit 1
fi

# 3. Get new commit id from repo1
cd $REPO1
REPO1_HEAD_2=`git rev-parse HEAD`


DO_ACTION=false

if [ -v ACTION_FORCE ]; then
    DO_ACTION=true
else
    if [ "$REPO1_HEAD_1" == "$REPO1_HEAD_2" ]; then
        echo "[$DTE]  No change detected in repo1"
        exit 0
    else
        DO_ACTION=true
    fi
fi

if [ "$DO_ACTION" = true ] ; then
    cd $REPO2

    # We have to pull any outstanding changes first, otherwise the commit and push won't work
    git pull --no-edit

    if [ $? != 0 ]; then
      echo "ERROR: Failed to pull repo2"
      exit 1
    fi

    /action_script.sh "$REPO1_HEAD_1" "$REPO1_HEAD_2"
    RET_VAR=$?

    DTE=`date`
    echo "[$DTE]  Action script returned $RET_VAR"
    exit $RET_VAR
fi
