
0.2.0 / 2016-08-05
==================

  * reorganize source, add docker monitor to kickstart stalled user-docker, integrate aws cloudwatch events for instance termination, improved termination procedure, host and server healthcheck endpoints, run everything as system service
  * updates for terraform v0.7 (data sources and string concat)
  * extra attempt to remove rancher host and create a new backup on host termination
  * add rancher/agent-instance to base image

0.1.3 / 2016-08-01
==================

  * fix makefile references

0.1.2 / 2016-08-01
==================

  * fix makefile references

0.1.1 / 2016-08-01
==================

  * reorganize terraform, fix auto registration/deregistration and other bugs
  * add rancher environment module for autoscaling host groups

0.1.0 / 2016-07-27
==================

  * Merge pull request #1 from finboxio/blue-green
  * functional blue-green server infrastructure, organized into terraform modules

0.0.10 / 2016-07-24
===================

  * switch to elb health checks
  * increase default volume size, detach mysql container from mysqlvol
  * remove pid and gvwstate files from mysql backup

0.0.9 / 2016-07-23
==================

  * add mysql-monitor to dockerfile

0.0.8 / 2016-07-23
==================

  * start rising services at RISE_COUNT - 1
  * add mysql monitor to restore primaries in case of quorum loss
  * don't print an unhealthy message if monitored service is rising
  * pull additional rancher images during packer build
  * fix possible inconsistency in cluster size & ha launch script, pin rancher version

0.0.7 / 2016-07-23
==================

  * improve mysql leader monitoring, improve rancher bootstrapping to avoid conflicts
  * cleanup snapshot message on termination

0.0.6 / 2016-07-23
==================

  * fix last-words config
  * retry api key generation

0.0.5 / 2016-07-23
==================

  * fix galera url concatenation
  * set unhealthy status to fall count after parent failure

0.0.4 / 2016-07-22
==================

  * make dev-tag optional for images

0.0.3 / 2016-07-22
==================

  * fix mysqlchk when socket is not available

0.0.2 / 2016-07-22
==================

  * fix changelog formatting

0.0.1 / 2016-07-22
==================

  * run mysql-related processes as mysql user
  * update image reference to finboxio/rancher-asg-server
  * add rise/fall settings to status monitor
  * ignore terraform state files
  * add atlas ami reference to launch configuration
  * compute quorum_size from cluster_size
  * fix check for rancher auth setting when db has not been initialized
  * add terraform commands, fix version retrieval, add docker image tags
  * add changelog

0.0.0 / 2016-07-22
==================

  * Initial commit

