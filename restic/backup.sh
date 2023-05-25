#!/usr/bin/env bash

# We expect our files to be mounted here
pushd /etc/restic

export RESTIC_REPOSITORY_FILE=/var/run/secrets/restic/repository
export RESTIC_PASSWORD_FILE=/var/run/secrets/restic/password
export AWS_ACCESS_KEY_ID="$(cat /var/run/secrets/restic/aws_id)"
export AWS_SECRET_ACCESS_KEY="$(cat /var/run/secrets/restic/aws_secret)"

restic backup --iexclude-file ./backup-iexclude.list --exclude-file ./backup-exclude.list --files-from ./backup.list --exclude-if-present ".nobackup" --exclude-if-present ".git" --exclude-if-present ".nextcloudsync.log" --exclude-if-present ".owncloudsync.log" --tag nixos
restic forget --prune --keep-last 10 --keep-daily 14 --keep-weekly 10 --keep-monthly 24 --keep-yearly 100

popd