defmodule WeatherServiceTest do
  use ExUnit.Case
  doctest Weather.WeatherService

  import Weather.WeatherService, only: [ airport_weather_url: 1, weather_xsd_url: 0 ]

  test "airport_weather_url" do
    assert airport_weather_url("WWWW") == "https://w1.weather.gov/xml/current_obs/WWWW.xml"
  end

  test "weather_xsd_url" do
    assert weather_xsd_url() == "http://www.nws.noaa.gov/view/current_observation.xsd"
  end
end
