defmodule Servy.MixProject do
  use Mix.Project

  def project do
    [
      app: :servy,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      # OTP will use the callback module below and call start, to starts it automatically
      # mix run --no-halt will do the job, no halt is here to not exit the beam after runnning
      mod: {Servy, []},
      env: [port: 4000]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0"},
      {:httpoison, "~> 0.12.0"}
    ]
  end
end
