#for partitiontype in 1 2 3 4
for partitiontype in 2 3 4
do
	echo # Cleaning up and starting fresh tidb cluster
	date
	tiup cluster clean prune-bench --all -y
	tiup cluster start prune-bench
	#sleep 10
	echo # enable dynamic pruning in TiDB
	date
	sh ~/bench/setup-tidb-for-sysbench.sh
	echo # TPC-C prepare
	date
	echo time ~/repos/go-tpc/bin/go-tpc tpcc prepare -T 4 --parts 8 --warehouses 32 --partition-type ${partitiontype}
	time ~/repos/go-tpc/bin/go-tpc tpcc prepare -T 4 --parts 8 --warehouses 32 --partition-type ${partitiontype} > go-tpc.prepare.partitiontype.${partitiontype}.log 2>&1
	date
	sleep 30
	echo # TPC-C run
	date
	echo time ~/repos/go-tpc/bin/go-tpc tpcc run -T 4 --time 10m --parts 8 --warehouses 32 --partition-type ${partitiontype}
	time ~/repos/go-tpc/bin/go-tpc tpcc run -T 4 --time 10m --parts 8 --warehouses 32 --partition-type ${partitiontype} > go-tpc.10m.partitiontype.${partitiontype}.log 2>&1
	date
	echo # TPC-C check
	date
	echo time ~/repos/go-tpc/bin/go-tpc tpcc check --check-all -T 4 --parts 8 --warehouses 32 --partition-type ${partitiontype}
	time ~/repos/go-tpc/bin/go-tpc tpcc check --check-all -T 4 --parts 8 --warehouses 32 --partition-type ${partitiontype} > go-tpc.check.partitiontype.${partitiontype}.log 2>&1
	date
done
echo # Cleaning up and starting fresh tidb cluster and run without partitions
date
tiup cluster clean prune-bench --all -y
tiup cluster start prune-bench
#sleep 10
echo # enable dynamic pruning in TiDB
date
sh ~/bench/setup-tidb-for-sysbench.sh
echo # TPC-C prepare
date
echo time ~/repos/go-tpc/bin/go-tpc tpcc prepare -T 4 --warehouses 32
time ~/repos/go-tpc/bin/go-tpc tpcc prepare -T 4 --warehouses 32 > go-tpc.prepare.no-partition.log 2>&1
date
sleep 30
echo # TPC-C run
date
echo time ~/repos/go-tpc/bin/go-tpc tpcc run -T 4 --time 10m --warehouses 32
time ~/repos/go-tpc/bin/go-tpc tpcc run -T 4 --time 10m --warehouses 32 > go-tpc.10m.no-partition.log 2>&1
date
echo # TPC-C check
date
echo time ~/repos/go-tpc/bin/go-tpc tpcc check --check-all -T 4 --warehouses 32
time ~/repos/go-tpc/bin/go-tpc tpcc check --check-all -T 4 --warehouses 32 > go-tpc.check.no-partition.log 2>&1
date
