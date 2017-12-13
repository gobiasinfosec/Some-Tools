# Note- this must be run as workstation/domain admin to connect to machines as it reads folders for last updated

# Turn off Error notices (makes it quieter, you can take out if you want
$ErrorActionPreference= 'silentlycontinue'

# Set OU and output location
$ou = "*OU=Workstations*"
$output = 'c:\temp\workstation_owners.csv'
$error_output = 'c:\temp\workstation_owners_error.csv'

# Search the selected OU and save machines as an array
$computers = Get-ADComputer -filter {Enabled -eq $true} | Where-Object{$_.DistinguishedName -like $ou } | Select-Object Name

# Create a new empty arrays for results and machines you were unable to connect to
$results = @()
$unconnected = @()


# Loop through each computer
foreach($computer in $computers.name)
{
    try 
    {
        # connect to machine and look at the last write time for the users folder, select the most recently logged in and pull the name, email and time last logged in
        $info = Get-ChildItem "\\$computer\c$\Users" | Sort-Object LastWriteTime -Descending | Select-Object @{l='Computer'; e = {$computer}}, Name, LastWriteTime -first 1
        $user = $info.Name
        $email = Get-ADUser -Filter {samAccountName -like $user} | Select UserPrincipalName

        # take filtered info and create a new object with properties to add to the results arrary
        $computerinfo = New-Object psobject
        $computerinfo | Add-Member -membertype NoteProperty -name "Computer" -value $info.Computer
        $computerinfo | Add-Member -membertype NoteProperty -name "Last User" -value $info.Name
        $computerinfo | Add-Member -membertype NoteProperty -name "Email" -value $email.UserPrincipalName
        $computerinfo | Add-Member -membertype NoteProperty -name "Time" -value $info.LastWriteTime
        $results += $computerinfo
    }
    catch
    {
        echo "Unable to connect to $computer"
        $unconnected += $computer
    }
}

# write results to output file
$results | convertto-csv -NoTypeInformation -Delimiter "," | % { $_ -replace '"', ""} | out-file $output -Encoding ascii
$unconnected | out-file $error_output -Encoding ascii
