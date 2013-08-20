#!/bin/sh

lsb_release -cs
dpkg -l | grep libncurses5-dev
