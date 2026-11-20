#!/bin/bash
set -eu

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get install -y -qq wget curl ca-certificates vim htop mc nmap netcat-openbsd git
