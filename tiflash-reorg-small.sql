drop table if exists t;
select @@session.tidb_isolation_read_engines,@@session.tidb_allow_mpp,@@session.tidb_enforce_mpp, @@session.tidb_partition_prune_mode;
create table t (a int primary key, b varchar(255), c int, key (b), key (c,b)) partition by range (a) (partition p0 values less than (1000000), partition p1M values less than (2000000));
analyze table t;
alter table t set tiflash replica 1;
show warnings;
select * from information_schema.tiflash_replica where table_schema = 'test';
select `database`,`table`,tidb_table,table_id,is_tombstone,segment_count,total_rows, p.table_name, p.partition_name from information_schema.tiflash_tables,information_schema.partitions p where table_id = p.tidb_partition_id;
select sleep(2);
select * from information_schema.tiflash_replica where table_schema = 'test';
select `database`,`table`,tidb_table,table_id,is_tombstone,segment_count,total_rows, p.table_name, p.partition_name from information_schema.tiflash_tables,information_schema.partitions p where table_id = p.tidb_partition_id;
insert into t values (1,"1",-1);
set @t := 1;
insert into t select a+@t,a+@t,-(a+@t) from t;
set @t := 2 * @t;
insert into t select a+@t,a+@t,-(a+@t) from t;
set @t := 500000;
insert into t select a+@t,a+@t,-(a+@t) from t;
set @t := 1000000;
insert into t select a+@t,a+@t,-(a+@t) from t;

select * from information_schema.tiflash_replica where table_schema = 'test';
select sleep(3);
select * from information_schema.tiflash_replica where table_schema = 'test';
select /*+ READ_FROM_STORAGE(TIKV[t]) */ count(*) from t partition (p0);
show warnings;
explain select /*+ READ_FROM_STORAGE(TIKV[t]) */ count(*) from t partition (p0);
select /*+ READ_FROM_STORAGE(TIFLASH[t]) */ count(*) from t partition (p0);
show warnings;
explain select /*+ READ_FROM_STORAGE(TIFLASH[t]) */ count(*) from t partition (p0);

select * from information_schema.tiflash_replica where table_schema = 'test';
select `database`,`table`,tidb_table,table_id,is_tombstone,segment_count,total_rows,tiflash_instance from information_schema.tiflash_tables where tidb_database = 'test';
select `database`,`table`,tidb_table,table_id,is_tombstone,segment_count,total_rows, p.table_name, p.partition_name from information_schema.tiflash_tables,information_schema.partitions p where table_id = p.tidb_partition_id;
select table_name,partition_name,tidb_partition_id from information_schema.partitions where partition_name is not null;

analyze table t;
alter table t reorganize partition p0 INTO (partition p0 values less than (500000), partition p500k values less than (1000000));
select /*+ READ_FROM_STORAGE(TIFLASH[t]) */ count(*) from t partition (p0);
select /*+ READ_FROM_STORAGE(TIFLASH[t]) */ count(*) from t partition (p500k);
show warnings;
explain select /*+ READ_FROM_STORAGE(TIFLASH[t]) */ count(*) from t partition (p0);
select /*+ READ_FROM_STORAGE(TIKV[t]) */ count(*) from t partition (p0);
select /*+ READ_FROM_STORAGE(TIKV[t]) */ count(*) from t partition (p500k);
show warnings;
explain select /*+ READ_FROM_STORAGE(TIKV[t]) */ count(*) from t partition (p0);

select * from information_schema.tiflash_replica where table_schema = 'test';
select `database`,`table`,tidb_table,table_id,is_tombstone,segment_count,total_rows,tiflash_instance from information_schema.tiflash_tables where tidb_database = 'test';
select `database`,`table`,tidb_table,table_id,is_tombstone,segment_count,total_rows, p.table_name, p.partition_name from information_schema.tiflash_tables,information_schema.partitions p where table_id = p.tidb_partition_id;
select table_name,partition_name,tidb_partition_id from information_schema.partitions where partition_name is not null;

set @t := 4;
insert into t select a+@t,a+@t,-(a+@t) from t;
select /*+ READ_FROM_STORAGE(TIFLASH[t]) */ count(*) from t partition (p0);
show warnings;
explain select /*+ READ_FROM_STORAGE(TIFLASH[t]) */ count(*) from t partition (p0);
select /*+ READ_FROM_STORAGE(TIKV[t]) */ count(*) from t partition (p0);
show warnings;
explain select /*+ READ_FROM_STORAGE(TIKV[t]) */ count(*) from t partition (p0);

select * from information_schema.tiflash_replica where table_schema = 'test';
select `database`,`table`,tidb_table,table_id,is_tombstone,segment_count,total_rows,tiflash_instance from information_schema.tiflash_tables where tidb_database = 'test';
select `database`,`table`,tidb_table,table_id,is_tombstone,segment_count,total_rows, p.table_name, p.partition_name from information_schema.tiflash_tables,information_schema.partitions p where table_id = p.tidb_partition_id;
select table_name,partition_name,tidb_partition_id from information_schema.partitions where partition_name is not null;
