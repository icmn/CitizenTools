<# 
.SYNOPSIS
    Simple StarCitizen User directory Reset script. 

.DESCRIPTION 
    Just set the variables below and run it. I didn't want to deal with 
    parameters every time I used it, so I didn't write that functionality 
    in. If editing this file makes you uncomfortable, this script probably
    isn't for you. :(
 
.NOTES 
    Nothing to note 

.COMPONENT 
    None (Default)

.LINK 
    N/A
#>


#####################################
###   BEGIN USER CONFIGURABLES    ###
#####################################

# Installation location for Star Citizen
$ScInstallDir = "EXAMPLE--C:\MainGames\StarCitizen\StarCitizen"

# Folder that will be used to backup the "USER" folder
$backupDir = "EXAMPLE--C:\MainGames\StarCitizen\backups"

# Option for LIVE or PTU. 
$installType = "LIVE" 

#####################################
###    END USER CONFIGURABLES!    ###
#####################################


# Check if you skipped an important step.
if ($backupDir -like "*EXAMPLE*" -or $ScInstallDir -like "*EXAMPLE*") {
    Write-Output 'You MUST set $backupDir and $ScInstallDir to match you installation. If your backup or install locations include the word "Example", then you''re out of luck! Sorry!'
    Exit
}

## This generates a tag to use for your backed-up USER folder.
$datetag = get-date -format 'yyyy-MM-ddTHH-mm-ss'

## Don't do anything is star citizen is running!!
if (get-process *StarCitizen*) {
    Write-Output "Star Citizen is running. Stop and try again."
    Exit

}

$destname = "$backupDir\USER-$datetag"
Write-Output "Backing up to: $destname"

# Create backup
copy-item -Path "$ScInstallDir\$installType\USER" -Destination "$destname" -Recurse -Force

# Remove original
remove-item -Path "$ScInstallDir\$installType\USER" -Recurse -Force

# Option to reset your Star Citizen AppData folder too.
$resp = Read-Host -prompt "Do you wish to remove the appdata folder as well?
'Y' for yes."

if ($resp -like "*y*") {
    Write-Output "Removing appdata cache."
    remove-item "$(Get-Item  Env:\USERPROFILE)\AppData\Local\Star Citizen" -Recurse -Force
}

# Restore Backed up bindings
Write-Output "Restoring backed up Binding/control mapping files. You'll still have to configure them in game."
Copy-Item -Path "$destname\Client\0\Controls\Mappings" -Destination "$ScInstallDir\LIVE\USER\Client\0\Controls\Mappings" -Force -Recurse


write-host 'Reminder: You can load back in exported bindings using the console command "pp_RebindKeys <filename>"
Note: Do not use the full path. The file names are in the folder listed above (USER\Client\0\Controls\Mappings).
Ex: "pp_RebindKeys my_backedup_bindings.xml"'

