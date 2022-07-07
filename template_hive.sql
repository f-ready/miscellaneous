--+---------------------------------------------------------------------+--
--+                                                                     +--
--+                          Table of Contents                          +--
--+                                                                     +--
--+     0.0.        Script Initialization                               +--
--+     0.1.        Command Line Interface Initialization               +--
--+     1.          User-Defined Functions                              +--
--+     z.          Clean Up                                            +--
--+                                                                     +--
--+---------------------------------------------------------------------+--
--+                                                                     +--
--+     Short Explanation.                                              +--
--+                                                                     +--
--+---------------------------------------------------------------------+--



--+---------------------------------------------------------------------+--
--+     0.0.        Script Initialization                               +--
--+---------------------------------------------------------------------+--

-- hive -i hive_init.hql -f hive_submit.hql
source init_file.sql;

use object_to_use;

-- To be able to use select all but a couple of columns.
--   create table test_tbl as select 1 as a, 2 as b, 3 as c;
--   select `(a|b)?+.+` from test_tbl;
--   drop table if exists test_tbl;
set hive.support.quoted.identifiers = none;

-- For variable substitution.
--   select * from row_test where (int_col <= ${int_limit});
set hive.variable.substitute = true;
set hivevar:int_limit = 2147483647;

-- For faster execution.
set hive.execution.engine = tez;
set tez.queue.name = zeppelin;
set hive.exec.parallel = true;
set hive.exec.max.dynamic.partitions.pernode = 500000;
set hive.vectorized.execution.enabled = true;
set hive.vectorized.execution.reduce.enabled = true;
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;
set hive.cbo.enable = true;
set hive.stats.fetch.column.stats = true;

-- Don't use cached statistics.
-- Toggle to true to improve performance.
-- Toggle to false for validation checks.
set hive.compute.query.using.stats = false;

-- Don't attach table name to column names in the header.
set hive.resultset.use.unique.column.names = false;

-- Configure log to be less crowded.
-- Error messages will not be affected.
set hive.server2.logging.operation.level = none;



--+---------------------------------------------------------------------+--
--+     0.1.        Command Line Interface Initialization               +--
--+---------------------------------------------------------------------+--

-- Format output for interactive mode.
-- Accepted formats are:
--   csv, tsv, csv2, tsv2, dsv, table, vertical, xmlattr, xmlelements
--   If using dsv, change delimiter with `!set delimiterForDSV ','`.
-- Vertical is recommended for outputs that employ screen-wrap.
-- Table is recommended for outputs that don't employ screen-wrap.
-- DSV is recommended for outputs to be piped into scripts.
!set outputformat table

-- Makes spotting errors easier.
!set color true

-- Toggle header when showing output.
!set showHeader true

-- Change row limit before header is displayed again.
!set headerInterval 2147483647



--+---------------------------------------------------------------------+--
--+     1.          User-Defined Functions                              +--
--+---------------------------------------------------------------------+--

show warehouses;
show databases;
show schemas;
show tables;
show views;



--+---------------------------------------------------------------------+--
--+     z.          Clean Up                                            +--
--+---------------------------------------------------------------------+--

show variables;
set user_name = 'Freddy Xu';
show variables;
unset user_name;
show variables;
