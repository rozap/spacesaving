defmodule Spacesaving.Mixfile do
  use Mix.Project

  def project do
    [app: :spacesaving,
     version: "0.0.1",
     elixir: "~> 1.2",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
      stream count distinct element estimation using the "space saving"
      algorithm.
    """
  end

  defp deps do
    [{:ex_doc, github: "elixir-lang/ex_doc"}]
  end

  defp package do
    [# These are the default files included in the package
     files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: ["Chris Duranti"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/rozap/spacesaving",
              "Docs" => "http://hexdocs.pm/spacesaving"}]
  end
end
