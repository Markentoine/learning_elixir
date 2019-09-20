defmodule TryPlug.MixProject do
  use Mix.Project

  def project do
    [
      app: :try_plug,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:cowboy, :plug]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :plug, "~> 1.0" },
      { :plug_cowboy, "~> 1.0" }
    ]
  end
end
