function translate
{
    [CmdletBinding()]
    param 
            (
            [Parameter (Mandatory=$true, Position=1, HelpMessage ="Enter the path to the source .\module1-task3.txt")]
            [ValidateLength(1,20)]
            [string]$source,

            [Parameter (Mandatory=$true, Position=2, HelpMessage ="Enter the name of object parameter")]
            [AllowEmptyCollection()]
            [ValidateLength(1,20)]
            [string]$name 
            )
    function send ($a,$b)
        {
            Invoke-WebRequest -Body $a -Headers $b -ContentType "application/json; charset=utf-8" "https://translate.api.cloud.yandex.net/translate/v2/translate" -Method Post             
        }
    $content = Get-Content $source -Encoding UTF8
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
}

translate @args -Verbose