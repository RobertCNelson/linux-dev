#!/bin/bash

unset BUILD

KERNEL_REL=3.1

#for x.x.X
#STABLE_PATCH=1

#for x.x-gitX
#PRE_RC=3.0-git23

#for x.x-rcX
RC_KERNEL=3.2
RC_PATCH=-rc4

ABI=1

if [ "${NO_DEVTMPS}" ] ; then
BUILD=dold${ABI}
else
BUILD=d${ABI}
fi

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel

export KERNEL_REL STABLE_PATCH RC_KERNEL RC_PATCH PRE_RC BUILD
export BUILDREV DISTRO DEBARCH
