function get-weather
{
    [CmdletBinding()]
    param 
            (
            [Parameter (Mandatory=$true, Position=1, HelpMessage ="Enter the name of city Minsk")]
            [ValidateLength(1,30)]
            [string]$CityName,

            [Parameter (Mandatory=$true, Position=2, HelpMessage ="Enter the temperature Default, Metric, Imperial")]
            [ValidateLength(1,20)]
            [string]$TemperatureFormat,

            [Parameter (Mandatory=$true, Position=3, HelpMessage ="Enter the API key")]
            [string]$APIKey
            )

    $today = Invoke-WebRequest "api.openweathermap.org/data/2.5/weather?q=$CityName&appid=$APIKey&units=$TemperatureFormat" | ConvertFrom-Json 
    $tomorrow = Invoke-WebRequest "api.openweathermap.org/data/2.5/forecast?q=$CityName&appid=$APIKey&units=$TemperatureFormat" | ConvertFrom-Json
    $result = @{ City = $today.name
                 ID = $today.id
                 Country = $today.sys.country
                 WeatherToday = $today.weather.main
                 TemperatureToday = $today.main.temp
                 WeatherTomorrow = $tomorrow.list.weather.main[7]
                 TemperatureTomorrow = $tomorrow.list.main.temp[7]
                }
    $result
}

$args = @{
    CityName = "Minsk"
    TemperatureFormat = "Metric"
    APIKey = "001abf212cdee8941b71ff7eb93a05b1"
}

get-weather @args -Verbose

Export-ModuleMember -Function get-weather
