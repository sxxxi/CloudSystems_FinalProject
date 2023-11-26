#!/bin/sh

remote_host=$1
local_pubkey=$2

sftp ec2-user@$remote_host:~/.ssh <<< $"put $local_pubkey"