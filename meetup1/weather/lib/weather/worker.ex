defmodule Weather.Worker do

  def temperature_of(location) do
    weather_data =
      url_for(location)
      |> HTTPoison.get
      |> parse_response

    case weather_data do
      {:ok, temp} -> "#{location}: #{temp} Celcius"
      :error      -> "#{location}: Not Found"
    end
  end

  def url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end

  def parse_response({:ok, %HTTPoison.Response{ body: body, status_code: 200 }}) do
    body
    |> JSON.decode!
    |> compute_temperature
  end

  def parse_response(_) do
    :error
  end

  def compute_temperature(json) do
    temp =
      (json["main"]["temp"] - 273.15)
      |> Float.round(1)
    {:ok, temp}
  end

  def apikey do
    "COLOCA TU API KEY DENTRO DE ESTAS COMILLAS"
  end

  
end
