#Check if user is Admin. If not, break script and fail
If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{

    Write-Warning "You do not have Administrator rights to run this script! Re-run with admin rights!"
    Pause
    exit

}

#Gets the Drive Letter of the current path
$Drive = (get-location).drive.name
#Captures the current name of the workstation
$WSName = $Env:computername
#Tests to see if a directy exists. If it does not, create the directory. If it does, end script with a warning.
If (!(Test-path "$Drive`:\Profiles\$WSName")) 
{
    New-Item "$Drive`:\Profiles\$WSName" -ItemType directory
}
else 
{
    Write-Warning -Message "Path Exits! Ending script. Please delete path if a new scanstate is desired"
    pause
    exit
}

#Run Scanstate.exe, captureing profiles used in the last 180 days
$Update = New-Object System.Diagnostics.ProcessStartInfo
$Update.filename = "$Drive`:\USMT\scanstate.exe"
$Update.arguments =  "/i:$Drive`:\USMT\MigDocs.xml","/i:$Drive`:\USMT\MigApp.xml","$Drive`:\Profiles\$WSName","/v:5", "/c", "/uel:90"
[System.Diagnostics.Process]::Start($Update)
$Monitor = Get-Process -name scanstate
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
    pause    
}