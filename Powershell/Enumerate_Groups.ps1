import-module activedirectory

#Will enumerate all the users in a group

# optional, add a wild card..
$GroupName = Read-Host "Enter the Group Name: "
$outfile = Read-Host "Where to output: "

$Groups = Get-ADGroup -filter {Name -like $GroupName} -Properties Name | Select-Object Name, Description

ForEach ($Group in $Groups)
   {
    $ArrayofMembers = Get-ADGroupMember -identity $($group.name) -recursive | Select-Object samaccountname, Name
    foreach($Member in $ArrayofMembers)
    {
        Add-Content $outfile "`n `"$($group.name)`",  `"$($Member.samaccountname)`",  `"$($Member.name)`" "
    }

}
