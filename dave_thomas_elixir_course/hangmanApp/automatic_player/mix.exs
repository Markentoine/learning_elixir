defmodule AutomaticPlayer.MixProject do
  use Mix.Project

  def project do
    [
      app: :automatic_player,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hangman, path: "../hangman"},
      {:dictionary, path: "../dictionary"}
    ]
  end
end
