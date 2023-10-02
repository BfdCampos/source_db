# dbt source_db

The `source_db` package allows you to specify the source database that dbt should read from. This enables reading from one database and writing to another. 

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

---
# FAQ

## How is this different to dbt's --defer?
The source_db package allows for dynamic database routing based on environment variables. Specifically, it lets you read from one database while writing to another. This feature is useful when you need to test new models in a **non-production** environment while **sourcing** data from a production database. It does *not* require any previous dbt artifacts, making it ideal if you don't have access to production-level artifacts.

dbt's `--defer` feature is designed to save computational resources in CI/CD pipelines. It uses previously-built models if they exist, allowing you to switch between databases or schemas based on these models' availability. This feature requires a prior manifest to be provided through the `--state` flag or an environment variable.

### When to Use source_db?
- **Scenario 1**: You have a production database (`prod_db`) and a sandbox database (`sandbox`). You want to build a new model (`my_model`) in the `sandbox` while using data from `prod_db`.
```bash
SRC_DB=prod_db dbt run --models my_model
```
- Scenario 2: You are testing new dbt features locally, and you want to source data from a development database (`dev_db`) without affecting your production database.
```bash
SRC_DB=dev_db dbt run
```

### When to Use --defer?
- Scenario 1: You are running a CI/CD pipeline and want to skip rebuilding models that haven't changed. Provide a manifest from a previous run.
```bash
dbt run --defer --state ./path/to/previous/manifest
```
- Scenario 2: You are developing locally and want to use pre-existing production models to avoid costly rebuilds. Again, you would provide a manifest from a previous production run.
```bash
dbt run --defer --state ./path/to/production/manifest
```


In summary, `source_db` provides flexible database routing through environment variables, while `--defer` is tailored for computational efficiency and requires prior state information.
