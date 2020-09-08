$VerbosePreference = 'Continue'
function translate
{
    [CmdletBinding()]
    param 
            (
            [Parameter (Mandatory=$false, Position=1, HelpMessage ="Enter the path to the source .\module1-task3.txt")]
            [ValidateLength(1,20)]
            [string]$source = ".\module1-task3.txt",

            [Parameter (Mandatory=$false, Position=2, HelpMessage ="Enter the name of object parameter")]
            [AllowEmptyCollection()]
            [ValidateLength(1,20)]
            [string]$name = "Denis",

            [Parameter (Mandatory=$false, Position=1, HelpMessage ="Enter the URL to the source ")]
            [ValidateLength(1,100)]
            [string]$url = "https://translate.api.cloud.yandex.net/translate/v2/translate"
            )
    function send ($a,$b)
        {
            try
            {
                Invoke-WebRequest -Body $a -Headers $b -ContentType "application/json; charset=utf-8" $url -Method Post
            }
            catch [System.Net.WebException]
            {
                Write-Host "Appeared the Operation error"
                $er = $Error[0].Exception.GetType()
                Write-Verbose ("The exception  $er")
                try
                {
                    Invoke-WebRequest -Body $a -Headers $b -ContentType "application/json; charset=utf-8" "https://translate.api.cloud.yandex.net/translate/v2/translate" -Method Post
                }
                catch
                {
                    Write-Host "Appeared the error again, check the issue"
                    $e = $Error[0].Exception.GetType()
                    Write-Verbose ("The exception  $e")
                }
            }
        }

    try
    {    
        $content = Get-Content $source -Encoding UTF8 -ErrorAction Stop
    }
    catch [System.UnauthorizedAccessException],[System.Management.Automation.ItemNotFoundException] 
    {
        Write-Host "Check the access permissions or the path is wrong"
        $err = $Error[0].Exception.GetType()
        Write-Verbose ("The exception  $err")
    }
    $headers = @{Authorization = "Api-Key AQVNwJk4LrB8dHJGajPiTjPLPPM0M80ATXA7XdSx"}
    $array = @()
    foreach($i in $content)
    {
        $n++
        $hash = @{folder_id = "b1gm9l1i1gm7erlhrs5o"; texts = "$i" ; targetLanguageCode = "en"} | ConvertTo-Json
        $h = 0
        foreach($i1 in $i.ToCharArray())
        {
            if ($i1 -match "[a-zA-Z]")
            {
                $h++
            }
        }
            if ($h -eq 0)
            {
                $rez = (send $hash $headers | ConvertFrom-Json).translations.text
                $array = $array + @(@{"$n" = @{'original' = "$i";'translated' = $rez}})
            }
    }
    $result = @{text = @{paragraph = $array}};
    $final = New-Object PSCustomObject
    Add-Member -InputObject $final -MemberType NoteProperty -Name "$name" -Value "$result"
    $final."$name"    
}

$args = @{
    source = ".\module1-task3.txt"
    name = "Data"
    url = "https://translate.api.cloud.yandex.net/translate/v2/translate"
}

translate @args -Verbose