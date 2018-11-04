defmodule Atmos.CLI do
  require Logger

  @moduledoc """
  Fetch and print weather data
  """

  def main(_) do
    fetch()
    |> handle_response()
  end

  @doc """
  Fetches latest atmospheric data from the weather api
  """
  def fetch() do
    Atmos.Fetcher.fetch()
  end

  @doc """
  Flow control for response pattern
  """
  def handle_response({:ok, %{status_code: 200, body: xml}}) do
    xml
    |> parse()
    |> print()
  end

  @doc """
  Flow control for response pattern
  """
  def handle_response({:ok, %{status_code: code} = response}) do
    handle_response({:error, "Failed to fetch weather data #{code}"})
  end

  @doc """
  Flow control for response pattern
  """
  def handle_response({:error, error}) do
    Logger.info("Failed to fetch result: #{inspect error}")

    System.halt(2)
  end

  @doc """
  Parse fetched weather data as a map
  """
  def parse(xml) do
    Atmos.Parser.parse(xml)
  end

  @doc """
  Prints parsed weather data in table format
  """
  def print(data) do
    Atmos.Printer.print(data)
  end
end
