# dbt package: source_db
This is a dbt package that allows the user to specify where the dbt command should read the data from.

## Use case
For when you have multiple environments/warehouses/accounts/schema's in your work and at times you want to WRITE to one place, but READ from another. 

dbt already comes with the WRITE solution with the `--target` by creating multiple profiles with the appropriate settings, and then specifying where you want your `run` to READ from and WRITE to. ([Choosing the right Snowflake warehouse when running dbt](https://about.gitlab.com/handbook/business-technology/data-team/platform/dbt-guide/#choosing-the-right-snowflake-warehouse-when-running-dbt)).

However, for some cases you may want to READ from a particular warehouse, and WRITE to the warehouse you have specified in your `profile`. Say if you work with a "sandbox" environment before sending the PR that pulls the code into a production environment.

## Example use
Let's say you want to run a model in your dbt project called `my_model_a`.

In your project you have a *sandbox* environment where you are free to develop and try different solutions, and a *prd* environment where once the code has been looked over and approved, those changes get released to *prd*.

For you to develop in your *sandbox* environment you need to have the tables copied or cloned from *prd*. This can be easy to do if you only need one or two tables, but when you need multiple, this can become a pain.

The default behaviour of `dbt run --models +my_model_a` is to compile all the dbt code and READ all `ref`s and `source`s from the specified warehouse.

> So it compiles the code: `SELECT * FROM { ref('my_upstream_model') }` to `SELECT * FROM sandbox.schema.my_upstream_model`.

What if we want to develop __only__ our new model but with data from a particular environment like *dev*? With this package, you can run:

```bash
SRC_DB=DEV dbt run --models +my_model_a
```
What this will do, is it will compile` SELECT * FROM { ref('my_upstream_model') }` to `SELECT * FROM DEV.schema.my_upstream_model`, and it will write into the profile env as expected: `CREATE OR REPLACE TABLE sandbox.schema.my_model AS ( ... )`.

This can be really handy for when you need to test something locally without copying everyting one by one, all done directly from within your dbt project.
