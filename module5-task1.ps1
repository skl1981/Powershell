
Configuration Test
{
    param(
        $nodename="localhost",
        $value = $false,
        $Path = $PSScriptRoot
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $nodename
    {   if ($value)
        {
        Script DownloadFile
            {
                GetScript = 
                {
                    @{
                        GetScript = $GetScript
                        SetScript = $SetScript
                        TestScript = $TestScript
                        Result = ('True' -in (Test-Path $using:Path\MARSAgentInstaller.exe))
                    }
                }
                SetScript = 
                {
                    Invoke-WebRequest -Uri "https://aka.ms/azurebackup_agent" -OutFile "$using:Path\MARSAgentInstaller.exe"
                } 
                TestScript = 
                {
                    $Status = ('True' -in (Test-Path $using:Path\MARSAgentInstaller.exe))
                    $Status -eq $True
                } 
            } 
            Package MARSAgentInstaller 
            {
                Ensure = "Present"
                Name = "MARSAgent"
                Path = "$Path\MARSAgentInstaller.exe"
                ProductId = "FFE6D16C-3F87-4192-AF94-DDBEFF165106"
                Arguments = "/q /m"
            } 
            $Passwd = ConvertTo-SecureString "12#QWEasd" -AsPlainText -Force
            $Credential = New-Object -TypeName pscredential -ArgumentList "Backup", $Passwd
            User LocalUser
            {
                UserName = "Backup"
                Ensure = "Present"
                Password = $Credential
            }
            Group GExample
            {
                Ensure = "Present"
                GroupName = "Backup Operators"
                Members = "Backup"
            } 
            Service SExample
            {
                Name = "RecoveryServicesManagementAgent"
                StartupType = "Automatic"
                State = "Running"
                Credential = $Credential
            }
            File Clean
            {
                Type = "File"
                Ensure = "Absent"
                DestinationPath = "$Path\Test\localhost.mof"
                DependsOn = "[Package]MARSAgentInstaller"     
            }
            File Clean1
            {
                Type = "File"
                Ensure = "Absent"
                DestinationPath = "$Path\MARSAgentInstaller.exe"
                DependsOn = "[Package]MARSAgentInstaller"     
            }
            File CleanFolder1
            {
                Type = "Directory"
                Ensure = "Absent"
                DestinationPath = "$Path\test"
                DependsOn = "[File]Clean"     
            }
            Log Log1
            {
                Message = "The test mesage for checking the logging"
                DependsOn = "[File]CleanFolder1"
                PsDscRunAsCredential = $Credential
            }
        }
    else
        {
        Script MARSAgentUnInstaller
            {
                TestScript = 
                {
                $null -eq $(Get-WmiObject Win32_Product -Filter "name = 'Microsoft Azure Recovery Services Agent'")
                }

                SetScript = 
                {
                $(Get-WmiObject Win32_Product -Filter "name = 'Microsoft Azure Recovery Services Agent'").uninstall()
                }

                GetScript = 
                {
                @{ result = ( $null -eq $(Get-WmiObject Win32_Product -Filter "name = 'Microsoft Azure Recovery Services Agent'") ) }
                }
            }
        User LocalUser1
            {
                UserName = "Backup"
                Ensure = "Absent"
            } 
        }
    }
}
$configData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            PsDscAllowPlainTextPassword = $true
            PsDscAllowDomainUser = $true   
        }
    )
}

Test -nodename "localhost" -ConfigurationData $configData



