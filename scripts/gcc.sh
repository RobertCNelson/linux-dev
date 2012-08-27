#!/bin/bash -e
#
# Copyright (c) 2009-2012 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

DIR=$PWD

source ${DIR}/system.sh

#Test that user actually modified the CC line:
if [ "x${CC}" == "x" ] ; then
	echo "-----------------------------"
	echo "Error: You haven't setup the Cross Compiler (CC variable) in system.sh"
	echo ""
	echo "with a (sane editor) open system.sh and modify the commented Line 18: #CC=arm-linux-gnueabi-"
	echo ""
	echo "If you need hints on installing an ARM GCC Cross ToolChain, view README file"
	echo "-----------------------------"
	exit 1
fi

GCC="gcc"
if [ "x${GCC_OVERRIDE}" != "x" ] ; then
	GCC="${GCC_OVERRIDE}"
fi

GCC_TEST=$(LC_ALL=C ${CC}${GCC} -v 2>&1 | grep "Target:" | grep arm || true)
GCC_REPORT=$(LC_ALL=C ${CC}${GCC} -v 2>&1 || true)

if [ "x${GCC_TEST}" == "x" ] ; then
	echo ""
	echo "Error: The GCC ARM Cross Compiler you setup in system.sh (CC variable)."
	echo "Doesn't seem to be valid for ARM, double check it's location, or that"
	echo "you chose the correct GCC Cross Compiler."
	echo ""
	echo "Output of: LC_ALL=C ${CC}${GCC} --version"
	echo "${GCC_REPORT}"
	echo ""
	exit 1
else
	echo "Debug Using: `LC_ALL=C ${CC}${GCC} --version`"
fi

