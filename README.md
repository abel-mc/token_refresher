# TokenRefresher

TokenRefresher is a library to manage and refresh tokens for multiple providers based on their expiration configuration.

## Installation

Add `token_refresher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:token_refresher, "~> 0.1.0"}
  ]
end
```

## Configuration

Configure the providers in your application configuration:

```elixir
config :token_refresher, :providers, [
  {MyApp.Provider1, 3600},
  {MyApp.Provider2, 7200}
]
```

## Usage

Implement the TokenRefresher.Provider behaviour in your provider modules:

```elixir
defmodule MyApp.Provider1 do
  @behaviour TokenRefresher.Provider

  @impl true
  def fetch_token do
    # Logic to fetch the token
    {:ok, "new_token"}
  end
end
```

Start the application:

```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      TokenRefresher
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Now TokenRefresher will periodically refresh tokens for the configured providers.

