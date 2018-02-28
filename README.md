# cstor
  This repository hosts the kubernetization of cstor components.

Cstor is the heart of OpenEBS that acts as interface between maya and underlying zfs filesystem. This repository creates images containing zpool and zfs binaries. While kubernetizing, it runs as pod comprising of Main container(controller for replica) and sidecar container(client for zfs and zpool). 
  
The means of communication between zfs component and maya(k8s) component is via Custom Resouce Definition(CRD). 

The repo includes testing where the cstor-sidecar watches for creation, deletion and updation of CstorCrd and performs zpool and zfs operations accordingly. 

The design pattern followed here is Sidecar as well as Ambassador pattern where the zfs operations on one container is visible to the other through a shared volume. 
