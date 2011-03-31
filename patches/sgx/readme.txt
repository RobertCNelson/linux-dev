Quick Readme about the SGX patches.

These GPL Kernel Modules were pulled from these TI SDK Versions:

3.01.00.02
3.01.00.06
3.01.00.07
4.00.00.01
4.03.00.01
4.03.00.02

To ensure compatiabilty with TI's SDK no external patches are applied unless to make it 'buildable/runable'

Since the source in these patches is TI's, I have no plans to push them to upstream. (Upstream would never accept them.)

So these patches only serve the purpose to provide Omap3 users the 3d-Acceleration from the SGX core they expect.

Note: Even with these patches, you can not run anything without the closed SGX libraries. (But atleast you don't have to build the module)

SGX unpackage script: http://bazaar.launchpad.net/~beagleboard-kernel/%2Bjunk/2.6-stable/annotate/head:/create_sgx_package.sh

(rcn-ee)

