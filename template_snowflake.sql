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

create or replace procedure clean_cols(
    "tbl" string)
    returns variant
    language javascript
    as
    $$
    var cmd = null;
    var stmt = null;
    var query_return = null;
    var query_result = null;
    var cols = [];
    var col = "";
    var col_new = "";
    cmd = `call get_cols('${tbl}', 'exact');`;
    stmt = snowflake.createStatement({sqlText : cmd});
    query_return = stmt.execute();
    query_return.next();
    query_result = query_return.getColumnValue(1);
    for (let i = 0; i < query_result.length; i++) {
        col = query_result[i];
        if (/\W/.test(col)) {
            col_new = col.replace(/=/, " equals ");
            col_new = col_new.replace(/</, " less ");
            col_new = col_new.replace(/>/, " greater ");
            col_new = col_new.replace(/\W+/g, "_");
            if (col_new.slice(-1) == "_") {
                col_new = col_new.slice(0, -1);
            }
            cols.push(`"${col}" as ${col_new}`);
        } else {
            cols.pust(col);
        }
    }
    return cols;
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

--+---------------------------------------------------------------------+--

create or replace procedure add_tbl_ref(
    "cols" array,
    "tbl" string)
    returns variant
    language javascript
    as
    $$
    var cmd = null;
    var stmt = null;
    var query_return = null;
    var query_result = null;
    var cols_new = [];
    var col = "";
    if (tbl == "") {
        cols_new = cols;
    } else {
        for (let i = 0; i < cols.length; i++) {
            col = cols[i].trim();
            cols_new.push(`${tbl}.${col}`);
        }
    }
    return cols_new;
    $$;

create or replace procedure add_prefix_suffix(
    "cols" array,
    "tbl" string,
    "prefix" string,
    "suffix" string)
    returns variant
    language javascript
    as
    $$
    var cmd = null;
    var stmt = null;
    var query_return = null;
    var query_result = null;
    var cols_new = [];
    var col = "";
    for (let i = 0; i < cols.length; i++) {
        col = cols[i].trim();
        cols_new.push(`${col} as ${prefix}${col}${suffix}`);
    }
    cmd = `call add_tbl_ref(array_construct('${cols_new.join("', '")}'), '${tbl}');`;
    stmt = snowflake.createStatement({sqlText : cmd});
    query_return = stmt.execute();
    query_return.next();
    query_result = query_return.getColumnValue(1);
    return query_result;
    $$;



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
desc procedure clean_cols(varchar);
desc procedure find_cols(varchar, varchar);
desc procedure add_tbl_ref(array, varchar);
desc procedure add_prefix_suffix(array, varchar, varchar, varchar);
drop procedure if exists get_cols(varchar, varchar);
drop procedure if exists get_tbls(varchar, varchar);
drop procedure if exists clean_cols(varchar);
drop procedure if exists find_cols(varchar, varchar);
drop procedure if exists add_tbl_ref(array, varchar);
drop procedure if exists add_prefix_suffix(array, varchar, varchar, varchar);
show procedures;

--+---------------------------------------------------------------------+--

show variables;
unset user_name;
show variables;

--+---------------------------------------------------------------------+--

show tables like 'proj_name%';
drop table if exists proj_name_tbl;
show tables like 'proj_name%';
