defmodule Weather.Proceso do

  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})
      _ -> IO.puts "I don't know how to process this message"
    end
    loop()
  end

  def temperature_of(location) do
    weather_data = 
      url_for(location)
      |> HTTPoison.get()
      |> parse_response

    case weather_data do
      {:ok, temp} -> "Temperature for #{location}: #{temp} Celcius"
      :error      -> "Un able to find #{location}"
    end
  end

  def url_for(location) do
    decoded_location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{decoded_location}&appid=#{apikey()}"
  end

  def parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
    |> JSON.decode!
    |> compute_temperature
  end

  def parse_response(_) do
    :error
  end

  def compute_temperature(json_body) do
    temp =
      (json_body["main"]["temp"] - 273.15)
      |> Float.round(1)
    {:ok, temp}
  end

  def apikey do
    "COLOCA TU API KEY DENTRO DE ESTAS COMILLAS"
  end
    
end
