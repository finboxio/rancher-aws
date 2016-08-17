
0.5.1 / 2016-08-17
==================

  * fix healthchecks
  * remove production dns records

0.5.0 / 2016-08-17
==================

  * add production infrastructure
  * add maintenance/404 page to staging and dns failover
  * fix healthcheck credentials file placement
  * remove volume config if not mounted
  * fix mysql backup for passwords with unusual characters
  * use rancher hostname for backup id instead of deployment tag
  * temporary fix for fleet subnet spec in us-west-2. use rancher hostname for backup id instead of deployment tag
  * add mongo mms, mongo backup, and job to enforce primary status
  * remove stacks from repo
  * improve router error handling with proper status codes and environment-variable redirects
  * add die image for testing handling of error codes returned from backends
  * restore fallback url for requests with no recognized backends (handle differently from known backends with 0 servers so we can do 'not found' vs 'maintenance')
  * remove mongo elb and route through default instead
  * add active haproxy router

0.4.1 / 2016-08-12
==================

  * drop ssl from mongo loadbalancer
  * add mongo and convoy images to makefile
  * leave curl in mongo image

0.4.0 / 2016-08-11
==================

  * stacks on stacks of changes
  * do not terminate spot instances on fleet cancellation
  * add asg/fleet tags to serf members
  * remove all-* checks files for out-of-service nodes

0.3.3 / 2016-08-08
==================

  * add server fleet module
  * remove server from load-balancer on termination

0.3.2 / 2016-08-08
==================

  * separate asg-specific resources from base server infrastructure
  * register with given load balancer after tagging
  * remove instance from serf on termination message

0.3.1 / 2016-08-08
==================

  * updates to status page
  * move clustercheck out of cron and into persistent service
  * filter out health checks to/from terminated instances
  * run cron tasks as root

0.3.0 / 2016-08-06
==================

  * add cluster status checks and s3 + cloudfront hosted web app
  * add cluster status checks and s3 + cloudfront hosted web app

0.2.4 / 2016-08-06
==================

  * only handle cluster-wide termination message if rancher is locally available
  * clarify slack messages for rancher server vs rancher host

0.2.3 / 2016-08-05
==================

  * enable configurable use of latest version in cloud config
  * wait until console is ready before starting custom services
  * check for failure to start rancher agent during host bootstrapping
  * handle unavailability of instance metadata

0.2.2 / 2016-08-05
==================

  * fix graceful serf exit on host termination
  * use latest docker image
  * handle case where instance metadata is not available to serf
  * stop reporter on instance termination

0.2.1 / 2016-08-05
==================

  * optimize packer build since we don't need our images in user-docker anymore

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

