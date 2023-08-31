# dbt-source_db

The `dbt-source_db` package allows you to specify the source database that dbt should read from. This enables reading from one database and writing to another. 

## Getting Started 

Install the package:


In your `packages.yml` file, add the package:

```yml
packages:
  - package: BfdCampos/source_db
```

Then update the dependancies in your project with
```bash
dbt deps
```

## Usage

Set the `SRC_DB` environment variable to the source database you want dbt to read from:

```bash
export SRC_DB=dev_db
```

Then run dbt as usual. The `ref()` and `source()` macros will read from `SRC_DB` instead of the default target database. 

Or you can set the variable within the same command.

For example:

```bash
SRC_DB=dev_db dbt run
```

This will read all sources and refs from `dev_db`, but write to the database in your profile/target.

## Example

You have a _sandbox_ and _production_ database. You want to test a new model `my_model` in _sandbox_, but reading data from _production_.

Run the model:

```bash
SRC_DB=prod_db dbt run --models my_model
```

This will read from `prod_db` but write `my_model` to _sandbox_.

## Macro reference

- `ref(model_name)`: Reads `model_name` from `SRC_DB` instead of target database.

- `source(source_name, table_name)`: Reads `table_name` from `SRC_DB` instead of target database.
