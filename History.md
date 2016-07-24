
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

