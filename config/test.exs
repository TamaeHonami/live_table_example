import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :live_table_example, LiveTableExample.Repo,
  username: "root",
  password: "maria",
  hostname: "db",
  database: "live_table_example_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_table_example, LiveTableExampleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "esso10Id+UYGlwOhzx7BM+4hSLVnPGKVH1/ixK/XkzqT7nAXTpOQYB1dsLyyvyJS",
  server: false

# In test we don't send emails.
config :live_table_example, LiveTableExample.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
