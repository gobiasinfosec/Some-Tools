#This was given to me by a coworker, he did not write it, not sure where it can from. 
#
#=============
# Instructions
# =============
#
# 1) Open Powershell
# 2) Navigate to directory where powershell script resides
# 3) Enter script name to execute
# 4) You will be prompted for UNC path
# 5) You will be prompted for output file name
#
#
# NOTE: A "Results" directory needs to be created prior to execution
#
#




#Set variables
$path = Read-Host "Enter the path you wish to check - ex \\servername\dir1\dir1-1\"
$outfile = Read-Host "Enter Directory Location for Output File -ex C:\Temp\Results"
$filename = Read-Host "Enter Name for Output File - ex My_NTFS_ACLs"
$date = Get-Date

#Place Headers on out-put file
$list = "Permissions for directories in: $Path"
$list | format-table | Out-File "$outfile\$filename.txt"
$datelist = "Report Run Time: $date"
$datelist | format-table | Out-File -append "$outfile\$filename.txt"
$spacelist = " "
$spacelist | format-table | Out-File -append "$outfile\$filename.txt"

#Populate Folders Array
[Array] $folders = Get-ChildItem -path $path -force -recurse | Where {$_.PSIsContainer}

#Process data in array
ForEach ($folder in [Array] $folders)
{
#Convert Powershell Provider Folder Path to standard folder path
$PSPath = (Convert-Path $folder.pspath)
$list = ("Path: $PSPath")
$list | format-table | Out-File -append "$outfile\$filename.txt"

Get-Acl -path $PSPath | Format-List -property AccessToString | Out-File -append "$outfile\$filename.txt"

} #end ForEach
