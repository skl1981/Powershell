Invoke-WebRequest https://www.nuget.org/api/v2/package/HtmlAgilityPack/1.11.24 -OutFile C:\Users\Denis\Documents\Git\Denis-s_repository\htmlagilitypack.1.11.24.zip
Expand-Archive -LiteralPath ./htmlagilitypack.1.11.24.zip -DestinationPath ./HtmlAgilityPack.1.11.24
[Reflection.Assembly]::LoadFile("C:\Users\Denis\Documents\Git\Denis-s_repository\HtmlAgilityPack.1.11.24\lib\Net45\HtmlAgilityPack.dll") | Out-Null
[HtmlAgilityPack.HtmlWeb]$webaccess = @{}
[HtmlAgilityPack.HtmlDocument]$data = $webaccess.LoadFromBrowser("https://github.com/trending") 
[HtmlAgilityPack.HtmlNodeCollection]$Names = $data.DocumentNode.SelectNodes("//h1[1][@class='h3 lh-condensed']")
$NamesList = $Names.innertext | foreach {$_.split('/')[1]}
[HtmlAgilityPack.HtmlNodeCollection]$Address = $data.DocumentNode.SelectNodes("//h1[1][@class='h3 lh-condensed']")
$AddressList = $Address.innertext | foreach {$_.replace(" ","")}
[HtmlAgilityPack.HtmlNodeCollection]$Stars = $data.DocumentNode.SelectNodes("//a[1][@class='muted-link d-inline-block mr-3']") 
$Starscount = $Stars.innertext
[HtmlAgilityPack.HtmlNodeCollection]$Starstoday = $data.DocumentNode.SelectNodes("//span[@class='d-inline-block float-sm-right']")     
$Starstodaycount = $Starstoday.innertext | foreach {$_.split(' ')[0]}
[HtmlAgilityPack.HtmlNodeCollection]$Language = $data.DocumentNode.SelectNodes("//article[@class='Box-row']//span[@itemprop='programmingLanguage']")
$LanguageList = $Language.innertext  
$addr = "https://github.com/"
$result = 
    @{
        TrendingGithubRepositories = @()
    }
$i = 1
for ($n = 0; $n -lt $NamesList.Count; $n++) 
{
    $result.TrendingGithubRepositories += 
    @{"$i" = 
    [ordered]@{ 
        Name       = "$($Nameslist[$n])";
        Addres     = "$addr/$($AddressList[$n])";
        Language   = "$($LanguageList[$n])";
        StarsTotal = "$($StarsCount[$n])";
        StarsToday = "$($Starstodaycount[$n])" 
        }
    }
    $i++
}
$result | ConvertTo-json -Depth 5| Out-File '.\module4-task3.json' -Force
