[![Elixir CI](https://github.com/laiboonh/asset_tracker/actions/workflows/elixir.yml/badge.svg)](https://github.com/laiboonh/asset_tracker/actions/workflows/elixir.yml)

# Setup
- Install asdf
- `asdf install`
- Install direnv
- `curl -sfL https://direnv.net/install.sh | bash`
- `direnv allow`

# Run
- `mix phx.server`

# How to manage giglixir database

## Reset database
- `gigalixir ps:remote_console -a asset-tracker`
- `Ecto.Migrator.run(AssetTracker.Repo, Application.app_dir(:asset_tracker, "priv/repo/migrations"), :down, [all: true])`
- `Ecto.Migrator.run(AssetTracker.Repo, Application.app_dir(:asset_tracker, "priv/repo/migrations"), :up, [all: true])`

## Run migration
- `gigalixir ps:migrate -a asset-tracker`
