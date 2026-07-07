#!/usr/bin/env bash
nixos-rebuild switch --flake "${PWD}#${HOSTNAME}"
