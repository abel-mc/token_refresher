defmodule TokenRefresher.MixProject do
  use Mix.Project

  def project do
    [
      app: :token_refresher,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A library to refresh tokens for multiple providers continuously.",
      package: package(),
      # Add this line
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: [
        # The main page in the docs
        main: "readme",
        logo: "assets/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README.md"
      ],
      maintainers: ["Abel Mesfin Cherinet"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/abel-mc/token_refresher"}
    ]
  end

  # Add this line
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
