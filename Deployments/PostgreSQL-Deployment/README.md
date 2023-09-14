# PostgreSQL Deployment

# **References**

- [Postgres Information](https://www.postgresql.org/docs/current/tutorial-install.html)
- [Installation Guide](https://www.postgresqltutorial.com/postgresql-getting-started/)
- [Listen Addresses](https://databasefaqs.com/postgresql-listen_addresses/)
- [Remote Connection](https://www.bigbinary.com/blog/configure-postgresql-to-allow-remote-connection)
# Overview

PostgreSQL is a powerful, open source object-relational database system that uses and extends the SQL language combined with many features that safely store and scale the most complicated data workloads. Postgres will be used in our project as part of the 3 databased used with trino. Below you will find instrunctions for installing and navigating through PostgreSQL.

# Deployment
## Download and Install
We suggest using the latest version, as downloaded by apt-get.

```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql
```

After running the above commands PostgreSQL will take a few minutes to download and install.

## Connecting

When Postgres was created these were the default parameters: 

- `user` → postgres
- `password`→ postgres

Connect to postgres:

```bash
sudo -i -u postgres
```

Access PostgreSQL using the `psql`:
```bash
psql
```
## Basic Usage
Create new user:
```postgres
CREATE USER yourusername WITH PASSWORD 'yourpassword';
```
Create new database:
```postgres
CREATE DATABASE yourdbname;
```
Grant Privilages:
```postgres
GRANT ALL PRIVILEGES ON DATABASE yourdbname TO yourusername;
```

Exit Postgres:
```postgres
\q
```