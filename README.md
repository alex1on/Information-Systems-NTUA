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

### Cassandra setup:
1. Add the Apache repository of Cassandra to the file `cassandra.sources.list`. We use the latest major version 5.0:
```console
echo "deb https://debian.cassandra.apache.org 50x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list 
```
2. Add the Apache Cassandra repository keys to the list of trusted keys on the server:
```console
curl https://downloads.apache.org/cassandra/KEYS | sudo apt-key add -
```
3. Update the packages:
```console
sudo apt-get update
```
4. Install Cassandra with APT:
```console
sudo apt-get install cassandra
```
To check the Cassandra installation run:
```console
$ nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address      Load        Tokens  Owns (effective)  Host ID                               Rack
UN  192.168.1.2  203.77 KiB  16      100.0%            f6939e82-88d9-4cfa-a4f8-512b990ac76e  rack1
```
Cassandra is available in your node.


### Redis setup:
1. Download and install the Redis GPG key:
```console
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
```
2. Add the Redis repository to the package manager:
```console
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
```
3. Update the packages:
```console
sudo apt-get update
```
4. Install Redis with APT:
```console
sudo apt-get install redis
```  

## Database connection with Trino server
### PostgreSQL
1. Make PostgreSQL accessible from all the cluster. The cluster is in a LAN so we can just expose PostgreSQL to the cluster LAN. In the Postgres configuration file `/etc/postgresql/14/main/pg_hba.conf` add the IP addresses of the nodes that we want to connect to the PostgreSQL server. Under the `# IPv4 local connection:` add the following:
```txt
# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             node1-ip/32             md5
host    all             all             node2-ip/32             md5
host    all             all             node3-ip/32             md5
```

To apply the changes restart the PostgreSQL service:
```console
$ service postgresql restart
```

2. Add a user in the PostgreSQL database that will be used instead of the default user. As in the installation connect to the PostgreSQL shell as follows:

```console
$ sudo -i -u postgres
$ psql
psql (14.10 (Ubuntu 14.10-0ubuntu0.22.04.1))
Type "help" for help.

postgres=#
```

Then create a user (ROLE) by running the following command:
```console
postgres=# create role your_username with password 'your_password';
```

When creating a ROLE in PostgreSQL you also have to create database with the same name. While being logged in as `postgres` user create a database with the same name as your ROLE name (`your_username`):

```console
postgres=# CREATE DATABASE trino WITH OWNER 'trino' TEMPLATE template0 ENCODING 'LATIN1' LC_COLLATE='en_US.ISO-8859-1' LC_CTYPE='en_US.ISO-8859-1';
```
> The benchmark data we are going to use are from the TPC-DS benchmark suite. The data require `LATIN1` (`ISO-8859-1`) encoding to be loaded properly. You can use the default `UTF-8` if you choose your own data to load. 

> **Important!** You will need to add to locale settings on your OS the `ISO-8859-1`. You can check if its already available by running the command `locale -a`. If it doesn't exist on your available locals you can install it by running the `sudo dpkg-reconfigure locales` and selecting the `en_US.ISO-8859-1` in the prompt that opens. 

> You should also create a local user (on your machine) by running the `create user --interactive` and putting as a username the same username you specified in your PostgreSQL Role.

You can now login to PostgreSQL by running the following command:
```console
$ psql -h your_node_ip -U you_username -d your_database -W
psql (14.10 (Ubuntu 14.10-0ubuntu0.22.04.1))
Type "help" for help.

your_username=#
```

3. Add the PostgreSQL to all the Trino Server nodes. Create a file named `postgres.properties` inside the `/etc/catalog/` directory of the Trino server installation (if the `catalog` directory does not exist, create it) with the following attributes:
```txt
connector.name=postgresql
connection-url=jdbc:postgresql://your_node_ip:5432/your_database
connection-user=your_usename
connection-password=your_password
```

4. Verify that the connector works properly by querying the Catalogs inside the Trino server. Entering the `Trino CLI` you can run the `SHOW CATALOGS;` command. PostgreSQL and its data should appear there. 
> After the addition of the PostgreSQL connector a Trino server restart might be needed.




### Cassandra
1. Following the installation guide for Cassandra it makes the Cassandra server accessible only from localhost. In our cluster it has to be accessible by all the nodes inside our LAN. To achieve that we have to change the Cassandra configuration. In the `cassandra.yaml` configuration file (located in `/etc/cassandra/cassandra.yaml`) we have to make the following changes. Change the seeds from `- seeds: "localhost:7000"` to `- seeds: "your-node-ip:7000"`. Change the listen and rpc addresses as follows. Listen address from `listen_address: localhost` to `listen_address: your-node-ip` and rpc address from `rpc_address: localhost` to `rpc_address: your-node-ip`.

2. Add a "user" (or ROLES as per Cassandra documentation) that will be used to connect to Cassandra from the Trino server we have created. Again at the `cassandra.yaml` configuration we have to enable `PasswordAuthenticator` instead of the default `AllowAllAuthenticator` and `CassandraAuthorizer` instead of the default `AllowAllAuthorizer`.  
```yaml
authenticator:
  class_name : org.apache.cassandra.auth.PasswordAuthenticator
authorizer: CassandraAuthorizer
```
Restart the Cassandra service:
```console
$ sudo service cassandra restart
```

Then connect to the Cassandra server as follows:
> As we previously changed the Cassandra server ip address you have to provide the ip address you previously set as `your-node-ip`
```console
$ cqlsh -u cassandra 192.168.1.2
Password:
WARNING: cqlsh was built against 5.0-beta1, but this server is 5.0.  All features may not work!
Connected to Test Cluster at 192.168.1.2:9042
[cqlsh 6.2.0 | Cassandra 5.0 | CQL spec 3.4.7 | Native protocol v5]
Use HELP for help.
cassandra@cqlsh>
```
To create a ROLE (user) from inside the cqlsh terminal you can run the following command:
```console
cassandra@cqlsh> CREATE ROLE your_username WITH PASSWORD = 'your_password' AND SUPERUSER = true AND LOGIN = true  ;
```
The above credentials will be used by the Trino connector to access the Cassandra database server. 

To create a KEYSPACE (database) via cqlsh (Cassandra CLI) run the following command:
```console
CREATE KEYSPACE IF NOT EXISTS tpcds WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1} AND durable_writes = true;
```
You may want to grant permissions. You can do so, using the following command:
```console
GRANT ALL PERMISSIONS ON KEYSPACE tpcds TO trino;
```
We will use tpcds keyspace under the user trino.

3. Add the Cassandra Trino connector to all the cluster nodes. Create a file inside the Trino Server installation directory at the `/etc/catalog` (if the catalog directory does not exist you also have to create it) named `cassandra.properties`. Add the following lines inside the file:
```txt
connector.name=cassandra
cassandra.contact-points=your_cassandra_node_ip
cassandra.load-policy.dc-aware.local-dc=datacenter_name
cassandra.username=your_username
cassandra.password=your_password
```
> You can find the `datacenter_name` in the output of the `nodetool status` terminal command.

4. Verify that the connector works properly by querying the Catalogs inside the Trino server. Entering the `Trino CLI` you can run the `SHOW CATALOGS;` command. Cassandra and its data should appear there. 
> After the addition of the Cassandra connector a Trino server restart might be needed.


### Redis
1. Access Redis Configuration file using the following command:
```console
sudo vim /etc/redis/redis.conf
```
2. Enable Password Authentication by adding the following line in `redis.conf`:
```console
requirepass <your_password>
```
3. Make Redis listen to a specific (your node's) IP Address. In order to achieve this, add the following line in `redis.conf`:
```console
bind <node's 3 IP address>
```
To apply the changes restart the Redis service:
```console
sudo service redis restart
```
4. Run Redis CLI by running:
```console
redis-cli -h <node's IP address> -a <your_password>
```
5. Add the Redis Trino connector to all the cluster nodes. Create a file inside the Trino Server installation directory at the `/etc/catalog` (if the catalog directory does not exist you also have to create it) named `redis.properties`. Add the following lines inside the file:
```txt
connector.name=redis
redis.table-names=your_list_of_table_names_seperated_with_comma
redis.user=your_username
redis.password=your_password
redis.nodes=your_nodes'_ip_address:6379
redis.hide-internal-columns=false
```
6. Verify that the connector works properly by querying the Catalogs inside the Trino server. Entering the `Trino CLI` you can run the `SHOW CATALOGS;` command. Redis and its data should appear there. 
> After the addition of the Redis connector a Trino server restart might be needed.

## Import TPC-DS Benchmark data 

### Set up the TPC-DS benchmark suite

1. Download the TPC-DS source code from their [website](https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp)

2. Unzip the source code:
```console
$ unzip TPC-DS-Tool.zip
```

3. Edit the `makefile` in the `/DSGen-software-code-3.2.0rc1/tools` directory and specify the `OS` of your machine in the `OS=` line of the `makefile`.

4. Compile the code. To successfully compile it without errors you need to install an older version of the `gcc` compiler. Install it by running `sudo apt install gcc-9`.
> You might also need to install the following packages: `flex`, `bison`, `byacc`
Run make:
```console
$ make CC=ggc-9
```

### Generate benchmark data
Again in the `/DSGen-software-code-3.2.0rc1/tools` directory to generate benchmark data run the following command:
```console
$ ./dsdgen -scale <size> -dir <save_directory>
```
> Specify the data sample size with the `size` parameter. The amount of data is in GBs.

### Load Data to DBs
