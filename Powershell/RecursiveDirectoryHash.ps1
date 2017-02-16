#Recursively hash a directory using built-in Windows tools
#Outputs to a csv or xml file, comma delimited

$myInput = Read-Host "Enter the directory you'd like to enumerate"
$myHashType = Read-Host "Enter the hashtype you would like to use"
$fileNames = Get-ChildItem -Recurse $myInput | % {$_.FullName}
$Output = Read-Host "Enter the location where you would like to output(will be overwritten)"

$list = ''

foreach ($filename in $fileNames) {
    $hash = $(CertUtil -hashfile $filename $myHashType.ToUpper())[1] -replace " ",""
    $list += "$filename\*$hash`n"
}
$list | % { $_ -replace '\*', ","} | out-file $Output -Encoding ascii
