#!/usr/bin/env bash
sudo nixos-rebuild boot --flake "${PWD}#${HOSTNAME}"
