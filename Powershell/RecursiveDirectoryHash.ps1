$myInput = Read-Host "Enter the directory you'd like to enumerate: "
$myHashType = Read-Host "Enter the hashtype you would like to use: "
$myDownloads = Get-ChildItem -Recurse $myInput
$Output = Read-Host "Enter the location where you would like to output(will be overwritten): "

$fileNames = ForEach-Object -InputObject $myDownloads -Process {$_.FullName}
$list = ''

foreach ($filename in $fileNames) {
    $hash = $(CertUtil -hashfile $filename $myHashType.ToUpper())[1] -replace " ",""
    $list += "$filename\*$hash`n"
}
$list | % { $_ -replace '\*', ","} | out-file $Output -Encoding ascii
