# Information-Systems-NTUA

## Overview 
In this project we set up a Trino cluster with multiple data source types. We will test the Trino capabilities and benchmark that peformance when running queries with multiple data sources.

## Set up
### Trino cluster setup:
1. Install Java 17.03 or newer:
```console
$ sudo apt install openjdk-17-jdk openjdk-17-jre
```
2. Ensure you have python installed 2.6 or later:
```console
$ python3 --version
Python 3.10.12
```
3. Download and unpack the latest Trino release binary:
> You can find the latest version at the [Maven Central Repository](https://repo.maven.apache.org/maven2/io/trino/trino-server).
```console
$ wget https://repo.maven.apache.org/maven2/io/trino/trino-server/435/trino-server-435.tar.gz
$ tar xvzf trino-server-435.tar.gz
```
4. Create a `data` directory outside of the installation directory for Trino logs:
```console
$ mkdir data/
```
5. Create an `etc` directory inside the installation directory:
```console
$ cd ./trino-server-435/
$ mkdir etc/
```
6. Now you need to create the necessary Trino configuration files inside the `/etc` directory we previously created:
    - jvm.config
    - config.properties
    - node.properties
    - log.properties
To create and provide the correct configuration for the cluster run the following:
```console
$ touch jvm.config config.properties node.properties log.properties
```
Add the following lines to each of the configuration files:
```txt
# jvm.config content
-server
# Change this to 76-85% of the total memory of your node 
-Xmx6G
-XX:InitialRAMPercentage=80
-XX:MaxRAMPercentage=80
-XX:G1HeapRegionSize=32M
-XX:+ExplicitGCInvokesConcurrent
-XX:+ExitOnOutOfMemoryError
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:ReservedCodeCacheSize=512M
-XX:PerMethodRecompilationCutoff=10000
-XX:PerBytecodeRecompilationCutoff=10000
-Djdk.attach.allowAttachSelf=true
-Djdk.nio.maxCachedBufferSize=2000000
-XX:+UnlockDiagnosticVMOptions
-Dfile.encoding=UTF-8
-XX:+UseAESCTRIntrinsics
# Change this to the number of your cpu cores of your node 
-XX:GCLockerRetryAllocationCount=4
```

```txt
# config.properties content - for the coordinator 
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
# change localhost with coordinator's ip address
discovery.uri=http://localhost:8080

# config.properties content - for the workers 
coordinator=false
http-server.http.port=8080
# change localhost with coordinator's ip address
discovery.uri=http://localhost:8080
```

```txt
# node.properties content
# The name of your cluster 
node.environment=development 
```

```txt
# log.properties content
io.trino=INFO
```
7. You are now ready to start the cluster. At all nodes (while in the default installation directory) run:
```console
$ bin/launcher start
```
To verify that Trino started you can run:
```console
$ bin/launcher status
Running as 4716
```

### Trino CLI setup:
1. Download the Trino CLI executable:
```console
$ wget https://repo1.maven.org/maven2/io/trino/trino-cli/435/trino-cli-435-executable.jar
```
2. Make it an executable:
```console
$ mv trino-cli-435-executable.jar trino
$ chmod +x trino
```
3. Verify installation:
```console
$ ./trino --version
Trino CLI 435
```

## Database environment
We will install the following dbs one in each node of your Trino Cluster:

    - PostgreSQL
    - Cassandra
    - Redis 

### PostgreSQL setup:
1. Install PostgreSQL:
```console
$ sudo apt install postgresql postgresql-contrib
```
2. PostgreSQL creates a default user with the installation named `postgres`. To access the Postgres switch to that user and run:
```console
$ sudo -i -u postgres
$ psql
psql (14.10 (Ubuntu 14.10-0ubuntu0.22.04.1))
Type "help" for help.

postgres=#
```
You now have PostgreSQL working in your node. 






  
