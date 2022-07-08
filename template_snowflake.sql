--+---------------------------------------------------------------------+--
--+                                                                     +--
--+                          Table of Contents                          +--
--+                                                                     +--
--+     0.          Initialization                                      +--
--+     1.          Functions                                           +--
--+     2.          Utility                                             +--
--+     z.          Clean Up                                            +--
--+                                                                     +--
--+---------------------------------------------------------------------+--
--+                                                                     +--
--+     Short Explanation.                                              +--
--+                                                                     +--
--+---------------------------------------------------------------------+--



--+---------------------------------------------------------------------+--
--+     0.          Initialization                                      +--
--+---------------------------------------------------------------------+--

show grants;
use role granted_role;
use secondary role granted_role;
use warehouse data_warehouse;
use database data_database;
use schema data_schema;



--+---------------------------------------------------------------------+--
--+     1.          Functions                                           +--
--+---------------------------------------------------------------------+--

create or replace procedure get_cols(
    "tbl" string,
    "lower_upper_exact" string)
    returns variant
    language javascript
    as
    $$
    var cmd = null;
    var stmt = null;
    var query_return = null;
    var query_result = null;
    query_result = [];
    cmd = `show columns in ${tbl};`;
    stmt = snowflake.createStatement({sqlText : cmd});
    query_return = stmt.execute();
    while (query_return.next()) {
        switch(lower_upper_exact) {
            case "lower":
                query_result.push(query_return.getColumnValue(3).toLowerCase());
                break;
            case "upper":
                query_result.push(query_return.getColumnValue(3).toUpperCase());
                break;
            default:
                query_result.push(query_return.getColumnValue(3));
                break;
            }
     }
    return query_result;
    $$;

create or replace procedure get_tbls(
    "db_schema" string,
    "lower_upper_exact" string)
    returns variant
    language javascript
    as
    $$
    var cmd = null;
    var stmt = null;
    var query_return = null;
    var query_result = null;
    query_result = [];
    cmd = `show tables in ${db_schema};`;
    stmt = snowflake.createStatement({sqlText : cmd});
    query_return = stmt.execute();
    while (query_return.next()) {
        switch(lower_upper_exact) {
            case "lower":
                query_result.push(query_return.getColumnValue(2).toLowerCase());
                break;
            case "upper":
                query_result.push(query_return.getColumnValue(2).toUpperCase());
                break;
            default:
                query_result.push(query_return.getColumnValue(2));
                break;
            }
        }
    return query_result;
    $$;

create or replace procedure find_cols(
    "db_schema" string,
    "search_substr" string)
    returns variant
    language javascript
    as
    $$
    var cmd = null;
    var stmt = null;
    var query_return = null;
    var query_result = null;
    var tbls = [];
    var cols = [];
    var tbl = "";
    var col = "";
    var cols_found = [];
    query_result = [];
    cmd = `call get_tbls('${db_schema}', 'lower');`
    stmt = snowflake.createStatement({sqlText : cmd});
    query_return = stmt.execute();
    query_return.next();
    tbls = query_return.getColumnValue(1);
    for (let i = 0; i < tbls.length; i++) {
        tbl = tbls[i];
        cmd = `call get_cols('${db_schema}.${tbl}', 'lower');`
        stmt = snowflake.createStatement({sqlText : cmd});
        query_return = stmt.execute();
        query_return.next();
        cols = query_return.getColumnValue(1);
        for (let j = 0; j < cols.length; j++) {
            col = cols[j];
            if (col.includes(search_substr)) {
                cols_found.push(`${tbl}.${col}`);
            }
        }
    }
    return cols_found;
    $$;

call find_cols('data_schema', 'elusive_col');



--+---------------------------------------------------------------------+--
--+     2.          Utility                                             +--
--+---------------------------------------------------------------------+--

-- show roles like '%admin%';
-- use role accountadmin;
-- grant role accountadmin to user "xufreddy9@gmail.com";
-- use role accountadmin;

--+---------------------------------------------------------------------+--

set user_name = 'Freddy Xu';

select
    $user_name as curr_username,
    current_user() as curr_user,
    current_role() as curr_role,
    current_date() as curr_date,
    current_timestamp() as curr_timestamp;



--+---------------------------------------------------------------------+--
--+     z.          Clean Up                                            +--
--+---------------------------------------------------------------------+--

show procedures;
desc procedure get_cols(varchar, varchar);
desc procedure get_tbls(varchar, varchar);
desc procedure find_cols(varchar, varchar);
drop procedure if exists get_cols(varchar, varchar);
drop procedure if exists get_tbls(varchar, varchar);
drop procedure if exists find_cols(varchar, varchar);
show procedures;

--+---------------------------------------------------------------------+--

show variables;
unset user_name;
show variables;

--+---------------------------------------------------------------------+--

show tables like 'proj_name%';
drop table if exists proj_name_tbl;
show tables like 'proj_name%';
