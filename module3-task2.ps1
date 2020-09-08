function Check-FilesInParallel 
{    
    param
        (
        [parameter(mandatory=$false, position=1)]
        [string[]]$Path = "C:\test",
        [parameter(mandatory=$false, position=2)]
        [int]$session = 3
        )
    $files = Get-ChildItem $path -File -Recurse 
    foreach ($element in $files)
    { 
        if ((Get-Job).count -ge $session ) 
        {
            $t = Get-job | Wait-Job -any; Receive-Job $t; Remove-job $t 
        }
        Start-Job -scriptblock {
            param($element,$Path)
            $waittime = Get-Random -Minimum 5 -Maximum 15
            Start-Sleep -Seconds $waittime
            Get-ChildItem $path\$element -Name
        } -ArgumentList $element, $Path
    }
    Wait-Job * | Receive-Job;
    Remove-job *
    Write-Verbose ("Emulating the failed job")
    Start-Job -ScriptBlock{Start-Sleep 99999999}
    Wait-Job *
    $job = Get-Job -State Failed
        if ($job.State -eq 'Failed') 
        {
            Write-Warning ($job.ChildJobs[0].JobStateInfo.Reason.Message)
        } 
}

$args = @{
    Path = "C:\test"
    session = 3
}

Check-FilesInParallel @args -Verbose