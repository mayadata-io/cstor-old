
This repo containts the docker files to build cStor which is used a target replica engine in openEBS.

It makes use of the ZFS DMU transactional layer to persist data on disk, but doing so from user space.
The repository includes testing where the cstor-sidecar watches for creation, deletion, and updation of CRDs like cstorPool, cstorVolumeReplica, etc and performs zpool and zfs operations accordingly.

The design pattern followed here is Sidecar as well as Ambassador pattern where the zfs operations on one container are visible to the other through a shared volume.
