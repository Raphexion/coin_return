import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :coin_return, CoinReturnWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "eEi6bmLd8TlJ+C3QQOgivjWIqdebiNA7GBGmWEBKaAz4P/Sfr8so/aBJQZ55d1a0",
  server: false

# In test we don't send emails.
config :coin_return, CoinReturn.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
