function New-Password
{
param (
[string]$password = “1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ”,
[int]$length_of_password = 12
)
$temp = [char[]]$password
$new_password = ($temp | Get-Random -Count $length_of_password) -join ""
Write-Output $new_password
}