import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :blog_app, BlogApp.Mongo,
  url: "mongodb://localhost:27017/elixirblog",
  timeout: 60_000,
  idle_interval: 10_000,
  queue_target: 5_000

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blog_app, BlogAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OoMozFNowHVcH4VlsBTGEC2MW4Jl+hbZGlqWcvJQIEv6JPNjdUMUtKqGltmV5X5G",
  server: false

# In test we don't send emails
config :blog_app, BlogApp.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
