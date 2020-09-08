function Get-LogsFilter
{
    [CmdletBinding()]
    param 
        (
        [string]$log = ".\module4-task1-dism.log",
        [string]$keyword = "Error"
        )
    Write-Verbose ("Gathering the strings with state 'error'")
    $logs = Get-content -Path $log | where {$_ -match $keyword}
    Write-Verbose ("Gathering the Error codes")
    $extra = $logs | where {$_ -match "[0,8][x,0]\d\w\d.*\w"} | foreach {$Matches[0]}
    $i = 0
    foreach ($item in $logs)
    {
        if ($item -match "0x8" -or $item -match "0x0" -or $item -match "800[7,F]")
        {
            if ($item -notmatch "0x")
            {   
                "{0}    {1}" -f $extra[$i], $item | Out-File -FilePath .\task1-error.log -Append
                $i++
            }
            else 
            {
                "{0}  {1}" -f $extra[$i], $item | Out-File -FilePath .\task1-error.log -Append
                $i++
            }
        }
        else
        {
            "`t`t`t{0}" -f $item  | Out-File -FilePath .\task1-error.log -Append
        }
       
    }  
}

$args = @{
    log = ".\module4-task1-dism.log"
    keyword = "Failed"
}

Get-LogsFilter @args -Verbose