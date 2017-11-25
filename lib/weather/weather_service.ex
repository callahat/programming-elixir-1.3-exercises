defmodule Weather.WeatherService do
  import SweetXml

  require Logger

  @user_agent [ {"User-agent", "Elixir mrcallahat@yahoo.com"} ]
  @weather_url Application.get_env(:weather, :weather_url)
  @weather_xsd_url Application.get_env(:weather, :weather_xsd_url)

  @moduledoc """
  Retrieve the weather XML from the datasource.
  """

  @doc """
  Retrieve and parse the weather XML for the given airport.
  Takes the airport initials, ie `KMGY` and returns a map
  if successfully able to get the current weather there.

  `%{'station_id' => 'KMGY', ... }`
  """
  def fetch(airport) do
    Logger.info "Fetching information for airport #{airport}"
    airport_weather_url(airport)
    |> HTTPoison.get(@user_agent)
    |> handle_response
    |> decode_response
    |> xmap(current_observation_field_mapper())
  end
  
  @doc """
  Retrieve the full URL for the given airport
  """
  def airport_weather_url(airport) do
    "#{@weather_url}/#{airport}.xml"
  end

  @doc """
  Retrieve the XSD url
  """
  def weather_xsd_url() do
    "#{@weather_xsd_url}"
  end

  defp handle_response({ :ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    { :ok, body }
  end

  defp handle_response({ _, %{status_code: status, body: body}}) do
    Logger.info "Error #{status} returned"
    { :error, body }
  end

  @doc """
  Returns a list of tuples corresponding to each field and he xpath
  to get the text from that field.

  ie
  `[{'heat_index_c', ~x"//heat_index_c/text()"}, ... ]`
  """
  def current_observation_field_mapper() do
    Logger.info "Retrieving weather XSD"
    weather_xsd_url()
    |> HTTPoison.get(@user_agent)
    |> handle_response
    |> decode_response
    |> extract_current_observation_field_mapper
  end

  defp extract_current_observation_field_mapper(xml) do
    xpath(xml, ~x"//*[contains(@name,'current')]//xsd:element/@name"l)
    |> Enum.reduce( %{}, fn elem, acc -> Map.put(acc, elem, ~x"//#{elem}/text()") end)
    |> Map.to_list
  end

  defp decode_response({:ok, body}), do: body
  defp decode_response({:error, error}) do
    IO.puts "Error fetching data: #{error}"
    System.halt(2)
  end
end
