Supported Postgres extensions
Neon supports the Postgres extensions shown in the following table. The supported version of the extension sometimes differs by Postgres version. A dash (-) indicates that an extension is not yet supported.

Need an extension we don't have? 📩 Request an extension

Extension PG14 PG15 PG16 PG17 PG18 Notes
address_standardizer 3.3.3 3.3.3 3.3.3 3.5.0 3.6.0
address_standardizer_data_us 3.3.3 3.3.3 3.3.3 3.5.0 3.6.0
anon 2.4.1 2.4.1 2.4.1 2.4.1 2.4.1
autoinc (spi) 1.0 1.0 1.0 1.0 1.0
bloom 1.0 1.0 1.0 1.0 1.0
btree_gin 1.3 1.3 1.3 1.3 1.3
btree_gist 1.6 1.7 1.7 1.7 1.8
citext 1.6 1.6 1.6 1.6 1.8
cube 1.5 1.5 1.5 1.5 1.5
dblink 1.2 1.2 1.2 1.2 1.2
dict_int 1.0 1.0 1.0 1.0 1.0
earthdistance 1.1 1.1 1.2 1.2 1.2 To use earthdistance, you first need to install its dependency, the cube extension. Run: CREATE EXTENSION IF NOT EXISTS cube; CREATE EXTENSION IF NOT EXISTS earthdistance;
fuzzystrmatch 1.1 1.1 1.2 1.2 1.2
h3 4.1.3 4.1.3 4.1.3 4.1.3 4.2.3 Some components have been split out into the h3_postgis extension. Install both the h3 and h3_postgis extensions.
h3_postgis 4.1.3 4.1.3 4.1.3 4.1.3 4.2.3 Install with CREATE EXTENSION h3_postgis CASCADE; (requires postgis and postgis_raster)
hll 2.19 2.19 2.19 2.19 2.19
hstore 1.8 1.8 1.8 1.8 1.8
hypopg 1.4.2 1.4.2 1.4.2 1.4.2 1.4.2
insert_username (spi) 1.0 1.0 1.0 1.0 1.0
intagg 1.1 1.1 1.1 1.1 1.1
intarray 1.5 1.5 1.5 1.5 1.5
ip4r 2.4 2.4 2.4 2.4 2.4
isn 1.2 1.2 1.2 1.2 1.3
lo 1.1 1.1 1.1 1.1 1.2
ltree 1.2 1.2 1.2 1.3 1.3
moddatetime (spi) 1.0 1.0 1.0 1.0 1.0
neon 1.9 1.9 1.9 1.9 1.9
neon_utils 1.0 1.0 1.0 1.0 1.0
online_advisor - - - 1.0 -
pg_cron 1.6 1.6 1.6 1.6 1.6 To install pg_cron, it must first be enabled. See Enable the pg_cron extension for instructions. Please note that pg_cron jobs will only run when your compute is active. We therefore recommend only using pg_cron on computes that run 24/7 or where you have disabled scale to zero.
pg_graphql 1.5.11 1.5.11 1.5.11 1.5.11 -
pg_hashids 1.2.1 1.2.1 1.2.1 1.2.1 1.2.1
pg_hint_plan 1.4.1 1.5.0 1.6.0 1.7.0 1.8.0
pg_ivm 1.9 1.9 1.9 1.9 1.12 The create_immv function is created in the Postgres public schema by default, not the pg_ivm schema. In this case, run SELECT create_immv() instead of SELECT pg_ivm.create_immv().
pg_jsonschema 0.3.3 0.3.3 0.3.3 0.3.3 -
pg_mooncake 0.1.2 0.1.2 0.1.2 0.1.2 - This extension is experimental. Using a separate, dedicated Neon project is recommended. Run SET neon.allow_unstable_extensions='true'; before installing. See the YouTube demo and the pg_mooncake documentation.
pg_partman 5.1.0 5.1.0 5.1.0 5.1.0 5.1.0
pg_prewarm 1.2 1.2 1.2 1.2 1.2
pg_repack 1.5.2 1.5.2 1.5.2 1.5.2 1.5.2 Available only on paid Neon plans. To install pg_repack, it must first be enabled by Neon Support. Open a support ticket with your endpoint ID and database name to request it. After it's enabled, you'll need to restart your compute before running CREATE EXTENSION pg_repack; To use pg_repack, you will need to install the pg_repack CLI.
pg_roaringbitmap 0.5 0.5 0.5 0.5 0.5 Install with CREATE EXTENSION roaringbitmap;
pg_session_jwt 0.3.1 0.3.1 0.3.1 0.3.1 0.3.1 This extension provides JWT session management functionality used by the Data API.
pg_stat_statements 1.9 1.10 1.10 1.11 1.12
pg_tiktoken 0.0.1 0.0.1 0.0.1 0.0.1 0.0.1 The neon_superuser role has EXECUTE privilege on the pg_stat_statements_reset() function.
pg_trgm 1.6 1.6 1.6 1.6 1.6
pg_uuidv7 1.6 1.6 1.6 1.6 1.6
pgcrypto 1.3 1.3 1.3 1.3 1.4
pgjwt 0.2.0 0.2.0 0.2.0 0.2.0 0.2.0
pgrag 0.0.0 0.0.0 0.0.0 0.0.0 0.0.0 This extension is experimental. Using a separate, dedicated Neon project is recommended. Run SET neon.allow_unstable_extensions='true'; before installing.
pgrouting 3.4.2 3.4.2 3.4.2 3.6.2 3.8.0 The PostGIS extension must be installed first.
pgrowlocks 1.2 1.2 1.2 1.2 1.2
pgstattuple 1.5 1.5 1.5 1.5 1.5
pgtap 1.3.3 1.3.3 1.3.3 1.3.3 1.3.3
pgvector 0.8.0 0.8.0 0.8.0 0.8.0 0.8.1 Install with CREATE EXTENSION vector;
pg_search 0.15.26 0.15.26 0.15.26 0.15.26 - Install with CREATE EXTENSION pg_search; on Postgres 17.
pgx_ulid 0.1.5 0.1.5 0.1.5 0.2.0 - Install with CREATE EXTENSION ulid; on Postgres 14, 15, 16. Install with CREATE EXTENSION pgx_ulid; on Postgres 17.
plcoffee 3.1.10 3.1.10 3.1.10 - -
plls 3.1.10 3.1.10 3.1.10 - -
plpgsql 1.0 1.0 1.0 1.0 1.0 Pre-installed with Postgres.
plpgsql_check 2.8.2 2.8.2 2.8.2 2.8.2 2.8.2
plv8 3.1.10 3.1.10 3.1.10 3.2.3 -
postgis 3.3.3 3.3.3 3.3.3 3.5.0 3.6.0
postgis_raster 3.3.3 3.3.3 3.3.3 3.5.0 3.6.0
postgis_sfcgal 3.3.3 3.3.3 3.3.3 3.5.0 3.6.0
postgis_tiger_geocoder 3.3.3 3.3.3 3.3.3 3.5.0 3.6.0 Cannot be installed using the Neon SQL Editor. Use your psql user credentials to install this extension.
postgis_topology 3.3.3 3.3.3 3.3.3 3.5.0 3.6.0
postgres_fdw 1.1 1.1 1.1 1.1 1.2
prefix 1.2.0 1.2.0 1.2.0 1.2.0 1.2.0
rdkit 4.3.0 4.3.0 4.3.0 4.6.0 4.8.0
refint (spi) 1.0 1.0 1.0 1.0 1.0
rum 1.3 1.3 1.3 1.3 -
seg 1.4 1.4 1.4 1.4 1.4
semver 0.32.1 0.32.1 0.32.1 0.40.0 0.40.0
tablefunc 1.0 1.0 1.0 1.0 1.0
tcn 1.0 1.0 1.0 1.0 1.0
timescaledb 2.10.1 2.10.1 2.13.0 2.17.1 - Only Apache-2 licensed features are supported. Compression is not supported.
tsm_system_rows 1.0 1.0 1.0 1.0 1.0
tsm_system_time 1.0 1.0 1.0 1.0 1.0
unaccent 1.1 1.1 1.1 1.1 1.1
unit 7 7 7 7 -
uuid-ossp 1.1 1.1 1.1 1.1 1.1 Double-quote the extension name when installing: CREATE EXTENSION "uuid-ossp"
wal2json 2.6 2.6 2.6 2.6 2.6 CREATE EXTENSION not required. This decoder plugin is available by default but requires enabling logical replication in Neon.
xml2 1.1 1.1 1.1 1.1 1.2
Install an extension
Unless otherwise noted, supported extensions can be installed using CREATE EXTENSION syntax.

CREATE EXTENSION <extension_name>;
You can install extensions from the Neon SQL Editor or from a client such as psql that permits running SQL queries. For information about using the Neon SQL Editor, see Query with Neon's SQL Editor. For information about using the psql client with Neon, see Connect with psql.

Update an extension version
Neon updates supported extensions as new versions become available. Version updates are communicated in the Changelog. To check the current version of extensions you have installed, query the pg_extension table:

SELECT \* FROM pg_extension;
You can update an extension to the latest version using ALTER EXTENSION <extension_name> UPDATE TO <new_version> syntax. For example:

ALTER EXTENSION vector UPDATE TO '0.7.0';
important
When Neon releases a new extension or new extension version, a compute restart is required to make the new extension or extension version available for installation or update. A compute restart may occur on its own due to Neon's default scale to zero behavior. However, if your compute never restarts because you disabled scale to zero or because your compute is constantly active, you may need to force a restart. To force a restart, you can issue Restart endpoint API call. Please be aware that restarting a compute temporarily interrupts any connections currently using the compute.

Extensions installations and updates are automatically applied to any read replica computes on the same branch as your primary compute the next time the read replica compute restarts.

Request an extension
Request a new extension
Looking for a specific extension in Neon? Suggest one using this form.

Select an extension

Email
We appreciate all extension requests. While we can’t guarantee support, we regularly review requests and prioritize them based on factors like user demand, popularity in the Postgres ecosystem, and Neon’s product direction. Some extensions are simple to add, while others require significant integration work.

Custom-built extensions
For Scale plan customers, Neon supports custom-built Postgres extensions for exclusive use with your Neon account. If you developed your own Postgres extension and want to use it with Neon, please reach out to us as described above. Please include the following information in your request:

A repository link or archive file containing the source code for your extension
A description of what the extension does, instructions for compiling it, and any prerequisites
Whether an NDA or licensing agreement is necessary for Neon to provide support for your extension
Please keep in mind that certain restrictions may apply with respect to Postgres privileges and local file system access. Additionally, Neon features such as Autoscaling and Scale to Zero may limit the types of extensions we can support.

Depending on the nature of your extension, Neon may also request a liability waiver.

Custom-built extensions are not yet supported for Neon projects provisioned on Azure.

Extension support
Neon supports a large number of Postgres extensions. When we say an extension is “supported,” we mean that it's available for you to enable and use in your project.

We don’t actively maintain third-party extension code. If you run into an issue or discover a bug with an extension, we recommend reporting it to the extension’s upstream maintainers. If a fix is released, we’re happy to update to the latest version of the extension.

For the extension versions that Neon supports, refer to the Supported extensions table above. You can request support for a new version of an extension by opening a support ticket or by reaching out to us on Discord.

Experimental extensions
Neon occasionally adds support for extensions that are in early stages of development or undergoing validation. These extensions require an explicit opt-in and are not recommended for production use.

To run these extensions, you'll be required to configure the following session variable before installing the extension:

SET neon.allow_unstable_extensions = 'true';
note
"Unstable" doesn’t mean the extension is buggy. It means that we have not yet met service level expectations for the extension, often related to testing and Neon integration requirements.

Things to know about experimental extensions:

Use with caution: We recommend trying experimental extensions in a separate project—not in the Neon project you use for production.
Limited support: Experimental extensions aren’t covered by Neon support. If an extension causes your database to fail or prevents it from starting, we’ll help you disable it if possible—but we can’t guarantee more than that.
No guarantees: An experimental extension might never become fully supported. It could require significant work from Neon or the extension’s maintainers before it’s ready for general use.
Subject to change or removal: Experimental extensions may be updated at any time, including breaking changes. They can also be removed—especially if they pose security or operational risks.
If you're experimenting with an extension and run into trouble, we recommend checking with the extension’s maintainers or community for support.

Extensions with preloaded libraries
A preloaded library in Postgres is a shared library that must be loaded into memory when the Postgres server starts. These libraries are specified in your Postgres server's startup configuration using the shared_preload_libraries parameter and cannot be added dynamically after the server has started.

Some Postgres extensions require preloaded libraries but most do not. Neon Postgres servers preload libraries for certain extensions by default. You can view currently enabled libraries by running the following command.

SHOW shared_preload_libraries;
neon,pg_stat_statements,timescaledb,pg_cron,pg_partman_bgw,rag_bge_small_en_v15,rag_jina_reranker_v1_tiny_en
Viewing available libraries
You can view available libraries by running List preloaded libraries API:

curl --request GET \
 --url https://console.neon.tech/api/v2/projects/your_project_id/available_preload_libraries \
 --header 'accept: application/json' \
 --header 'authorization: Bearer $NEON_API_KEY'
The response body lists available libraries and whether the libraries are enabled by default. Response body attributes include:

library_name — library name, typically named for the associated extension
description — a description of the extension
is_default — whether the library is enabled by default
is_experimental — whether the extensions is experimental
version — the extension version
Response body
Important notes about libraries for Postgres extensions:

Available libraries and those enabled by default may differ by Postgres version
Neon does not enable libraries for all extensions that have them
Enabling preloaded libraries
You can enable available libraries using the preloaded_libraries object in a Create project or Update project API call. For example, this Update project call enables the specified libraries for the Neon project. When running this call, you have to provide a Neon project ID and a Neon API key.

curl --request PATCH \
 --url https://console.neon.tech/api/v2/projects/<your_project_id> \
 --header 'accept: application/json' \
 --header 'authorization: Bearer $NEON_API_KEY' \
 --header 'content-type: application/json' \
 --data '
{
"project": {
"settings": {
"preload_libraries": {
"enabled_libraries": [
"neon","pg_stat_statements","timescaledb","pg_cron","pg_partman_bgw","rag_bge_small_en_v15,rag_jina_reranker_v1_tiny_en","pg_search"
]
}
}
}
}
'
When running a Create project or Update project API call to enable libraries:

Library names must be quoted, comma-separated, and specified in a single string.
Specify all libraries that should be enabled. If a library is not included in the API call, it will not be enabled.
The "use_defaults": trueoption overrides the"enabled_libraries"` option, enabling only default libraries
The neon and pg_stat_statements libraries will remain enabled whether you include them in your API call or not — they're used by a Neon system-managed database.
If you do not use one of the libraries enabled by default, you can exclude it from your API call. For example, if you do not use the pgrag extension, you can exclude its libraries ("rag_bge_small_en_v15,rag_jina_reranker_v1_tiny_en").
Extension notes
Neon supports the uuid-ossp extension for generating UUIDs instead of the uuid extension.
The sslinfo extension is not supported. Neon handles connections via a proxy that checks SSL.
The file_fdw extension is not supported. Files would not remain accessible when Neon scales to zero.
