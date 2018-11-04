defmodule Atmos.Fetcher do
  def fetch() do
    HTTPoison.get(weather_api_url)
  end

  def weather_api_url do
    Application.get_env(:atmos, :weather_api_url)
  end
end
