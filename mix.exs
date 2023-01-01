defmodule MAVLink.Util.MixProject do
  use Mix.Project

  def project do
    [
      app: :xmavlink_util,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/fancydrones/xmavlink-util",
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MAVLink.Util.Application, []},
      extra_applications: [:xmavlink, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xmavlink, "~> 0.1.0"}
    ]
  end

  defp description() do
    "A helper layer on top of MAVLink for performing common commands
     and tasks with one or more remote vehicles. It can either be
     used as an API or directly from iex with an experience similar
     to Ardupilot's MAVProxy."
  end

  defp package() do
    [
      name: "xmavlink-util",
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      exclude_patterns: [".DS_Store"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/fancydrones/xmavlink-util"},
      maintainers: ["Roy Veshovda"]
    ]
  end
end