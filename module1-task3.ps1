$content = Get-Content C:\Users\Denis\Documents\Курсы\Powershell\lesson\module1-task3.txt #read the text for translating
$headers = @{Authorization = "Api-Key AQVNwJk4LrB8dHJGajPiTjPLPPM0M80ATXA7XdSx"}
$content
$n = 0
$array = @()
foreach($i in $content)
{ $n = $n + 1;$hash = @{folder_id = "b1gm9l1i1gm7erlhrs5o"; texts = "$i" ; targetLanguageCode = "en"}| ConvertTo-Json; $h = 0; foreach($i1 in $i.ToCharArray())
{if ($i1 -cmatch "a-z"){$h =$h + 1}}; if ($h -eq 0) `
{$tr = Invoke-WebRequest -Body $hash -Headers $headers -ContentType "application/json; charset=utf-8" "https://translate.api.cloud.yandex.net/translate/v2/translate" -Method Post;`
 $rez = ($tr | ConvertFrom-Json).translations.text; $array=$array + @(@{"$n"= @{'original' = "$i";'translated' = $rez}})}}

$result = @{text = @{paragraph = $array}};
$result | ConvertTo-Json -Depth 4 
#| Out-File C:/module1-task3.json



</SPAN><A class="muted-link d-inline-block mr-3" 

"//a[1][@class='muted-link d-inline-block mr-3']"

<H1 class="h3 lh-condensed"><A href="/htop-dev/htop"

h1[1][@class='h3 lh-condensed']"


Name       = "$($Nameslist[$n] -match "^.*\s$")";

$extra = $logs | where {$_ -match "[0,8][x,0]\d\w\d.*\w"} | foreach {$Matches[0]}
article