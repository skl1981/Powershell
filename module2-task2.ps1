function get-weather
{
    [CmdletBinding()]
    param 
            (
            [Parameter (Mandatory=$false, Position=1, HelpMessage ="Enter the name of city Minsk")]
            [string]$CityName,

            [Parameter(Mandatory=$false, Position=2)]
            [ValidatePattern("[0-9]")]
            [string]$CityId = "625144",

            [Parameter (Mandatory=$true, Position=3, HelpMessage ="Enter the temperature Default, Metric, Imperial")]
            [ValidateLength(1,20)]
            [string]$TemperatureFormat,

            [Parameter (Mandatory=$true, Position=4, HelpMessage ="Enter the API key")]
            [string]$APIKey
            )

    if ($CityName) {
        $today = Invoke-WebRequest http://api.openweathermap.org/data/2.5/weather?q=$CityName"&"appid=$APIKey"&"units=$TemperatureFormat | ConvertFrom-Json
        $tomorrow = Invoke-WebRequest http://api.openweathermap.org/data/2.5/forecast?q=$CityName"&"appid=$APIKey"&"units=$TemperatureFormat | ConvertFrom-Json
                }

    elseif ($CityId) {
        $today = Invoke-WebRequest http://api.openweathermap.org/data/2.5/weather?id=$CityId"&"appid=$APIKey"&"units=$TemperatureFormat | ConvertFrom-Json
        $tomorrow = Invoke-WebRequest http://api.openweathermap.org/data/2.5/forecast?id=$CityId"&"appid=$APIKey"&"units=$TemperatureFormat | ConvertFrom-Json
    }
   
    $result = @{ City = $today.name
                 ID = $today.id
                 Country = $today.sys.country
                 WeatherToday = $today.weather.main
                 TemperatureToday = $today.main.temp
                 WeatherTomorrow = $tomorrow.list.weather.main[9]
                 TemperatureTomorrow = $tomorrow.list.main.temp[9]
                }
    $result
}

# $args = @{
#     CityName = "Minsk"
#     TemperatureFormat = "Metric"
#     APIKey = "001abf212cdee8941b71ff7eb93a05b1"
# }

# get-weather @args -Verbose