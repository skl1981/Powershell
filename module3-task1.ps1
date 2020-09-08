function Get-PSREmoting
{
    [CmdletBinding()]
    param 
        (
        [string]$ServersList = ".\list.txt",
        [string]$login = "Denis",
        [string]$Password = "12#QWEasd",
        [int]$throttlelimit = 3
        )
$Passwd = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object -TypeName pscredential -ArgumentList $login, $Passwd
$data = Get-Content $ServersList
$GetInfo = {
     @{
        TopCPU = get-process |
                 Sort-Object CPU |
                 Select-Object -Last 5 -Property ProcessName, Id
        FreeSp = Get-WmiObject win32_logicaldisk |
                 Where-Object{$_.DeviceID -eq 'C:'} |
                 Select-Object -Property Freespace;
        ProcUs = Get-WmiObject win32_processor | 
                 Select-Object LoadPercentage
    }
}
$result = Invoke-Command -ScriptBlock $GetInfo `
                         -ComputerName $data `
                         -ErrorAction SilentlyContinue `
                         -ThrottleLimit $throttlelimit `
                         -Credential $Credential

foreach ($value in $data)
{
    if ($value -notin  $result.Pscomputername) 
    {
        $result+= @(@{"PSComputerName" = "$value";"status" = "unavaiable"}) 
    }
}
$result1 = $result | ConvertTo-Json -Depth 4 | Out-File .\module3-task1.json
}

$args = @{
    ServersList = ".\list.txt"
    login = "Denis"
    Password = "12#QWEasd"
    throttlelimit = 3
}

Measure-Command {Get-PSREmoting @args -Verbose} | Select-Object -Property TotalSeconds

$args1 = @{
    ServersList = ".\list.txt"
    login = "Denis"
    Password = "12#QWEasd"
    throttlelimit = 10
}

Measure-Command {Get-PSREmoting @args1 -Verbose} | Select-Object -Property TotalSeconds