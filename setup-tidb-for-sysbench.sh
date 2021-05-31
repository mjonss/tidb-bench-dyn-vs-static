mysql -h 192.168.2.62 -P 4000 -u root -e 'set global tidb_disable_txn_auto_retry = off'
mysql -h 192.168.2.62 -P 4000 -u root -e 'create database if not exists sbtest'
mysql -h 192.168.2.62 -P 4000 -u root -e 'set global tidb_partition_prune_mode = "dynamic"'
#mysql -h 192.168.2.62 -P 4000 -u root -e 'set global tidb_partition_prune_mode = "dynamic"'
