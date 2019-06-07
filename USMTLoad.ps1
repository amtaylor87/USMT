#Check if user is Admin. If not, break script and fail
If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{

    Write-Warning "You do not have Administrator rights to run this script! Re-run with admin rights!"
    Pause
    exit

}
#This script must be run from the file store. This first bit gets the current drive letter
$Drive = (get-location).drive.name
#User prompt for the workstation name. Used to ensure that the correct user profiles are moved back
$WSName = Read-Host "Please enter the Old Computer Name"
#Tests to see if a directy exists. If it does not, end script.
If (!(Test-path "$Drive`:\Profiles\$WSName")) 
{
    Write-error "No path found! Please check the computer name"
    exit
}
#Execute loadstate.exe for the selected WS
$Update = New-Object System.Diagnostics.ProcessStartInfo
$Update.filename = "$Drive`:\USMT\Loadstate.exe"
$Update.arguments = "$Drive`:\Profiles\$WSName","/c"
$Monitor = Get-Process -name loadstate
$Monitor.WaitForExit()
If ($LASTEXITCODE -eq 0) 
{
    Write-Output "Operation completed with no fatal errors! Press any button to exit"
    Pause
    Exit
}
else 
{
    Write-Error "A fatal error occured, exit code $LASTEXITCODE. Reference support documents for troubleshooting"
    Pause    
}
