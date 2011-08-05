#!/bin/bash

unset BUILD

KERNEL_REL=3.0

#for x.x.X
#STABLE_PATCH=1

#for x.x-gitX
PRE_SNAP=v3.0
PRE_RC=3.0-git20

#for x.x-rcX
#RC_KERNEL=3.0
#RC_PATCH=-rc7

ABI=0

if [ "${NO_DEVTMPS}" ] ; then
BUILD=dold${ABI}
else
BUILD=d${ABI}
fi

BUILDREV=1.0
DISTRO=cross

export KERNEL_REL BUILD RC_PATCH KERNEL_PATCH
export BRANCH REL
export BUILDREV DISTRO
