cd ~/tidb
git diff > tmp.diff
git checkout .
git checkout master
git pull

#time go test -tags intest github.com/pingcap/tidb/pkg/session -bench . -cpu 8 -timeout 45m -run '^[^T]' -v -skip '^Benchmark[SJ]|Pruning$|Scan|Index|Basic|Table|^Benchmark[PB]|BenchmarkHashPartitionPruningPointSelect' -count 5 --outfile bench.master.res > bench.master.out 2>&1
benchtest='go test -tags intest github.com/pingcap/tidb/pkg/session -bench . -cpu 8 -timeout 45m -run "^[^T]" -v'

nr=1
git checkout master
patch -p1 < ~/bench-part-cache.final.diff
time $benchtest > bench.master.${nr}.out 2>&1
git checkout .

git checkout ccbab5eeb7e004802610daf9c6bd91918e568c8e
patch -p1 < ~/bench-part-cache.final.only-test.diff
time $benchtest > bench.after-pr.${nr}.out 2>&1
git checkout .

git checkout ccbab5eeb7e004802610daf9c6bd91918e568c8e^
patch -p1 < ~/bench-part-cache.final.only-test.diff
time $benchtest > bench.before-pr.${nr}.out 2>&1
git checkout .

git checkout v7.5.1
patch -p1 < ~/bench-part-cache.final.7.5.diff
time $benchtest > bench.7.5.1.${nr}.out 2>&1
git checkout .

# Run 2
nr=2

git checkout v7.5.1
patch -p1 < ~/bench-part-cache.final.7.5.diff
time $benchtest > bench.7.5.1.${nr}.out 2>&1
git checkout .

git checkout ccbab5eeb7e004802610daf9c6bd91918e568c8e^
patch -p1 < ~/bench-part-cache.final.only-test.diff
time $benchtest > bench.before-pr.${nr}.out 2>&1
git checkout .

git checkout ccbab5eeb7e004802610daf9c6bd91918e568c8e
patch -p1 < ~/bench-part-cache.final.only-test.diff
time $benchtest > bench.after-pr.${nr}.out 2>&1
git checkout .

git checkout master
patch -p1 < ~/bench-part-cache.final.diff
time $benchtest > bench.master.${nr}.out 2>&1
git checkout .

# Run 3
nr=3
git checkout master
patch -p1 < ~/bench-part-cache.final.diff
time $benchtest > bench.master.${nr}.out 2>&1
git checkout .

git checkout ccbab5eeb7e004802610daf9c6bd91918e568c8e
patch -p1 < ~/bench-part-cache.final.only-test.diff
time $benchtest > bench.after-pr.${nr}.out 2>&1
git checkout .

git checkout ccbab5eeb7e004802610daf9c6bd91918e568c8e^
patch -p1 < ~/bench-part-cache.final.only-test.diff
time $benchtest > bench.before-pr.${nr}.out 2>&1
git checkout .

git checkout v7.5.1
patch -p1 < ~/bench-part-cache.final.7.5.diff
time $benchtest > bench.7.5.1.${nr}.out 2>&1
git checkout .

# Run 4
nr=4

git checkout v7.5.1
patch -p1 < ~/bench-part-cache.final.7.5.diff
time $benchtest > bench.7.5.1.${nr}.out 2>&1
git checkout .

git checkout ccbab5eeb7e004802610daf9c6bd91918e568c8e^
patch -p1 < ~/bench-part-cache.final.only-test.diff
time $benchtest > bench.before-pr.${nr}.out 2>&1
git checkout .

git checkout ccbab5eeb7e004802610daf9c6bd91918e568c8e
patch -p1 < ~/bench-part-cache.final.only-test.diff
time $benchtest > bench.after-pr.${nr}.out 2>&1
git checkout .

git checkout master
patch -p1 < ~/bench-part-cache.final.diff
time $benchtest > bench.master.${nr}.out 2>&1
git checkout .


