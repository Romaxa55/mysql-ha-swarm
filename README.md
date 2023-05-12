# mysql-ha-swarm

## Short Description
MySQL High-Availability Cluster for Docker Swarm with Consul for service discovery and Minio for backup.

## Description
This repository contains a Docker Compose file to deploy a highly available MySQL cluster with Consul and Minio in a Docker Swarm environment. It provides a robust solution for ensuring the continuity of your databases, with an automatic failover mechanism in case of any disruptions.

## Features
1. **High Availability:** The repository offers a solution for providing highly available MySQL, resistant to failures.

2. **Service Discovery with Consul:** Consul is used for service discovery and health checks.

3. **Backup with Minio:** Minio is used for storing MySQL backups.

4. **Docker Swarm:** All components are deployed in Docker Swarm, ensuring ease and simplicity of scaling.

5. **Automatic Recovery:** In case of primary node failure, the system automatically switches to the standby, minimizing downtime.

6. **Ease of Use:** The whole process from deployment to management and monitoring is simple and understandable, thanks to comprehensive documentation.

## How to Use
1. Clone the repository: `git clone https://github.com/Romaxa55/mysql-ha-swarm.git`
2. Navigate to the directory: `cd mysql-ha-swarm`
3. Deploy the stack: `docker stack deploy -c docker-compose.yml mysql`

Detailed instructions for usage and deployment can be found in the repository. Follow the steps in the documentation to get started with mysql-ha-swarm.

## Requirements
- Docker and Docker Swarm are required for the use of mysql-ha-swarm.
- You need to replace all environment variables in the docker-compose file with your own settings.

## Support
If you have any questions or issues, please create an issue in this repository.

## License
Detailed information about the license can be found in the LICENSE file in this repository.
