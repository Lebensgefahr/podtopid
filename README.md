# podtopid
You should have ssh access with private key authentication to all of kubernetes nodes cluster and sudo without password to run this script.

### EXAMPLES

* Pod with sidecar
```
./podtopid.sh pod/test-malloc-64b6dd6dcd-qv7qk
Node:node1
221404 /bin/sleep infinity
222875 /bin/sleep 3650d
```
* Pod
```
./podtopid.sh pod/service-7d6674888-nntsn
Node:node2
154021 dotnet Service.dll
```
