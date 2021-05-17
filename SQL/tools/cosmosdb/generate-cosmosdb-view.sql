/*
Copyright © 2021 Jovan Popovic

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”),
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
*/

create or alter procedure sp_generate_cosmosdb_view
                    @view_name sysname,
                    @connection nvarchar(1000),
                    @collection nvarchar(1000),
                    @server_cred nvarchar(1000) = NULL,
                    @database_cred nvarchar(1000) = NULL,
                    @mode tinyint = 0,
                    @default_string_type varchar(30) = 'varchar(256)'
as begin

    Drop  table if exists #frs

    create table #frs
    ( is_hidden bit NOT NULL
    , column_ordinal int NOT NULL
    , name sysname NULL
    , is_nullable bit NOT NULL
    , system_type_id int NOT NULL
    , system_type_name nvarchar(256) NULL
    , max_length smallint NOT NULL
    , precision tinyint NOT NULL
    , scale tinyint NOT NULL
    , collation_name sysname NULL
    , user_type_id int NULL
    , user_type_database sysname NULL
    , user_type_schema sysname NULL
    , user_type_name sysname NULL
    , assembly_qualified_type_name nvarchar(4000)
    , xml_collection_id int NULL
    , xml_collection_database sysname NULL
    , xml_collection_schema sysname NULL
    , xml_collection_name sysname NULL
    , is_xml_document bit NOT NULL
    , is_case_sensitive bit NOT NULL
    , is_fixed_length_clr_type bit NOT NULL
    , source_server sysname NULL
    , source_database sysname NULL
    , source_schema sysname NULL
    , source_table sysname NULL
    , source_column sysname NULL
    , is_identity_column bit NULL
    , is_part_of_unique_key bit NULL
    , is_updateable bit NULL
    , is_computed_column bit NULL
    , is_sparse_column_set bit NULL
    , ordinal_in_order_by_list smallint NULL
    , order_by_list_length smallint NULL
    , order_by_is_descending smallint NULL
    , tds_type_id int NOT NULL
    , tds_length int NOT NULL
    , tds_collation_id int NULL
    , tds_collation_sort_id tinyint NULL
    );

    declare @cred_spec nvarchar(4000) = null;
    if(@server_cred is not null)
        set @cred_spec = CONCAT('SERVER_CREDENTIAL = ''',@server_cred,'''')
    if(@database_cred is not null)
        set @cred_spec = CONCAT('CREDENTIAL = ''',@database_cred,'''')

    if @cred_spec is null
        THROW 51000, 'You need to specify @database_cred or @server_cred.', 1;  
    
    declare @openrowset nvarchar(max) = CONCAT(' FROM OPENROWSET ( PROVIDER = ''CosmosDB'',
                                                                                        CONNECTION = ''',@connection,''',
                                                                                        OBJECT = ''',@collection,''',
                                                                                        ',@cred_spec,')'
    )

    declare @tsql nvarchar(max) = 'select top 0 * ' + @openrowset + ' AS docs ';
    
    Insert #frs
    exec sys.sp_describe_first_result_set @tsql;

    

    select @tsql = CONCAT('CREATE VIEW ', @view_name, 
                                ' AS SELECT * ', @openrowset, '
                                WITH (' + STRING_AGG(CAST( 
                                                            QUOTENAME (name) + ' ' +
                                                             (case when lower(system_type_name) = 'varchar(8000)' then @default_string_type + ' COLLATE Latin1_General_100_BIN2_UTF8'
                                                                 else system_type_name
                                                                end)
                                                             
                                                             AS NVARCHAR(MAX)), ',
 ')) + ') AS docs'
    from #frs;

    if @mode = 0
        print @tsql;
    else if @mode = 1
        exec(@tsql)

end


From: Jovan Popovic 
Sent: Wednesday, April 28, 2021 11:58 AM
To: Vlado Tosev <Vlado.Tosev@microsoft.com>
Subject: RE: CosmosDb generator


create or alter procedure sp_generate_cosmosdb_view
                    @view_name sysname,
                    @connection nvarchar(1000),
                    @collection nvarchar(1000),
                    @server_cred nvarchar(1000) = NULL,
                    @database_cred nvarchar(1000) = NULL,
                    @mode tinyint = 0,
                    @default_string_type varchar(30) = 'varchar(256)'
as begin

    Drop  table if exists #frs

    create table #frs
    ( is_hidden bit NOT NULL
    , column_ordinal int NOT NULL
    , name sysname NULL
    , is_nullable bit NOT NULL
    , system_type_id int NOT NULL
    , system_type_name nvarchar(256) NULL
    , max_length smallint NOT NULL
    , precision tinyint NOT NULL
    , scale tinyint NOT NULL
    , collation_name sysname NULL
    , user_type_id int NULL
    , user_type_database sysname NULL
    , user_type_schema sysname NULL
    , user_type_name sysname NULL
    , assembly_qualified_type_name nvarchar(4000)
    , xml_collection_id int NULL
    , xml_collection_database sysname NULL
    , xml_collection_schema sysname NULL
    , xml_collection_name sysname NULL
    , is_xml_document bit NOT NULL
    , is_case_sensitive bit NOT NULL
    , is_fixed_length_clr_type bit NOT NULL
    , source_server sysname NULL
    , source_database sysname NULL
    , source_schema sysname NULL
    , source_table sysname NULL
    , source_column sysname NULL
    , is_identity_column bit NULL
    , is_part_of_unique_key bit NULL
    , is_updateable bit NULL
    , is_computed_column bit NULL
    , is_sparse_column_set bit NULL
    , ordinal_in_order_by_list smallint NULL
    , order_by_list_length smallint NULL
    , order_by_is_descending smallint NULL
    , tds_type_id int NOT NULL
    , tds_length int NOT NULL
    , tds_collation_id int NULL
    , tds_collation_sort_id tinyint NULL
    );

    declare @cred_spec nvarchar(4000) = null;
    if(@server_cred is not null)
        set @cred_spec = CONCAT('SERVER_CREDENTIAL = ''',@server_cred,'''')
    if(@database_cred is not null)
        set @cred_spec = CONCAT('CREDENTIAL = ''',@database_cred,'''')

    if @cred_spec is null
        THROW 51000, 'You need to specify @database_cred or @server_cred.', 1;  
    
    declare @openrowset nvarchar(max) = CONCAT(' FROM OPENROWSET ( PROVIDER = ''CosmosDB'',
                                                                                        CONNECTION = ''',@connection,''',
                                                                                        OBJECT = ''',@collection,''',
                                                                                        ',@cred_spec,')'
    )

    declare @tsql nvarchar(max) = 'select top 0 * ' + @openrowset + ' AS docs ';
    
    Insert #frs
    exec sys.sp_describe_first_result_set @tsql;

    

    select @tsql = CONCAT('CREATE VIEW ', @view_name, 
                                ' AS SELECT * ', @openrowset, '
                                WITH (' + STRING_AGG(CAST( 
                                                            QUOTENAME (name) + ' ' +
                                                             (case when lower(system_type_name) = 'varchar(8000)' then @default_string_type
                                                                 else system_type_name
                                                                end)
                                                             
                                                             AS NVARCHAR(MAX)), ',')) + ') AS docs'
    from #frs;

    if @mode = 0
        print @tsql;
    else if @mode = 1
        exec(@tsql)

end


From: Vlado Tosev <Vlado.Tosev@microsoft.com> 
Sent: Wednesday, April 28, 2021 10:55 AM
To: Jovan Popovic <jovanpop@microsoft.com>
Subject: RE: CosmosDb generator

--declare @view_name sysname = 'tccc-nsr-emea'
--declare @connection nvarchar(1000) = 'Account=cos-tccc-t01-nsr-emea;Database=tccc-nsr-emea'
--declare @collection nvarchar(1000) = 'dl-cee-uat'
--declare @server_cred nvarchar(1000) = 'cos-tccc-t01-nsr-emea'

declare @view_name sysname = 'tcc_nsr_emea_uat_cee_dm_dim_calendar'
declare @connection nvarchar(1000) = 'Account=cos-tccc-t01-nsr-emea;Database=tccc-nsr-emea-uat-cee'
declare @collection nvarchar(1000) = 'dm-dim-calendar'
declare @server_cred nvarchar(1000) = 'cos-tccc-t01-nsr-emea'

-- Create procedure

Drop  table if exists #frs

create table #frs
( is_hidden bit NOT NULL
, column_ordinal int NOT NULL
, name sysname NULL
, is_nullable bit NOT NULL
, system_type_id int NOT NULL
, system_type_name nvarchar(256) NULL
, max_length smallint NOT NULL
, precision tinyint NOT NULL
, scale tinyint NOT NULL
, collation_name sysname NULL
, user_type_id int NULL
, user_type_database sysname NULL
, user_type_schema sysname NULL
, user_type_name sysname NULL
, assembly_qualified_type_name nvarchar(4000)
, xml_collection_id int NULL
, xml_collection_database sysname NULL
, xml_collection_schema sysname NULL
, xml_collection_name sysname NULL
, is_xml_document bit NOT NULL
, is_case_sensitive bit NOT NULL
, is_fixed_length_clr_type bit NOT NULL
, source_server sysname NULL
, source_database sysname NULL
, source_schema sysname NULL
, source_table sysname NULL
, source_column sysname NULL
, is_identity_column bit NULL
, is_part_of_unique_key bit NULL
, is_updateable bit NULL
, is_computed_column bit NULL
, is_sparse_column_set bit NULL
, ordinal_in_order_by_list smallint NULL
, order_by_list_length smallint NULL
, order_by_is_descending smallint NULL
, tds_type_id int NOT NULL
, tds_length int NOT NULL
, tds_collation_id int NULL
, tds_collation_sort_id tinyint NULL
);

declare @openrowset nvarchar(max) = CONCAT(' FROM OPENROWSET ( PROVIDER = ''CosmosDB'',
                                                                                       CONNECTION = ''',@connection,''',
                                                                                       OBJECT = ''',@collection,''',
                                                                                       SERVER_CREDENTIAL = ''',@server_cred,''')'
)

declare @tsql nvarchar(max) = 'select top 0 * ' + @openrowset + ' AS docs ';
print @tsql

Insert #frs
exec sys.sp_describe_first_result_set @tsql;

select CONCAT('CREATE VIEW ', @view_name, 
                             ' AS SELECT * ', @openrowset, '
                             WITH (' + STRING_AGG(CAST( QUOTENAME (name) + ' ' + system_type_name AS NVARCHAR(MAX)), ',')) + ') AS docs'
 from #frs;



From: Jovan Popovic <jovanpop@microsoft.com> 
Sent: Tuesday, April 27, 2021 17:51 PM
To: Vlado Tosev <Vlado.Tosev@microsoft.com>
Subject: CosmosDb generator

declare @view_name sysname = 'Hrkljush'
declare @connection nvarchar(1000) = 'Hrkljush connection'
declare @collection nvarchar(1000) = 'COLLECTION'
declare @server_cred nvarchar(1000) = 'CREDENTIAL'

Drop  table if exists #frs

create table #frs
( is_hidden bit NOT NULL
, column_ordinal int NOT NULL
, name sysname NULL
, is_nullable bit NOT NULL
, system_type_id int NOT NULL
, system_type_name nvarchar(256) NULL
, max_length smallint NOT NULL
, precision tinyint NOT NULL
, scale tinyint NOT NULL
, collation_name sysname NULL
, user_type_id int NULL
, user_type_database sysname NULL
, user_type_schema sysname NULL
, user_type_name sysname NULL
, assembly_qualified_type_name nvarchar(4000)
, xml_collection_id int NULL
, xml_collection_database sysname NULL
, xml_collection_schema sysname NULL
, xml_collection_name sysname NULL
, is_xml_document bit NOT NULL
, is_case_sensitive bit NOT NULL
, is_fixed_length_clr_type bit NOT NULL
, source_server sysname NULL
, source_database sysname NULL
, source_schema sysname NULL
, source_table sysname NULL
, source_column sysname NULL
, is_identity_column bit NULL
, is_part_of_unique_key bit NULL
, is_updateable bit NULL
, is_computed_column bit NULL
, is_sparse_column_set bit NULL
, ordinal_in_order_by_list smallint NULL
, order_by_list_length smallint NULL
, order_by_is_descending smallint NULL
, tds_type_id int NOT NULL
, tds_length int NOT NULL
, tds_collation_id int NULL
, tds_collation_sort_id tinyint NULL
);

declare @openrowset nvarchar(max) = CONCAT(' FROM OPENROWSET ( PROVIDER = ''CosmosDB'',
                                                                                       CONNECTION = ''',@connection,''',
                                                                                       SERVER_CREDENTIAL = ''',@server_cred,''',
                                                                                       OBJECT = ''',@collection,''')' )


declare @tsql nvarchar(max) = 'select top 0 * ' + @openrowset;
print @tsql


Insert #frs
exec sys.sp_describe_first_result_set @tsql;

select CONCAT('CREATE VIEW ', @view_name, 
                             ' AS SELECT * ', @openrowset, '
                             WITH (' + STRING_AGG(CAST( QUOTENAME (name) + ' ' + system_type_name AS NVARCHAR(MAX)), ',')) 
 from #frs;

