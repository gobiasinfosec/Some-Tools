#Must run as admin
#Make sure the list of machines does not contain extra spaces

$servers= Read-Host "Enter the Machine List Location: "
$outfile= Read-Host "Where to output: "
foreach($server in $servers)
{
 $output = $outfile
 }

$results = @()

foreach($server in $servers)
{
 $group =[ADSI]"WinNT://$server/Administrators" 
 $members = $group.Members() | foreach {$_.GetType().InvokeMember("Adspath", 'GetProperty', $null, $_, $null) } 
 $results += New-Object PsObject -Property @{
  Server = $server
  Members = $members -join ","
  }
}

$results | convertto-csv -NoTypeInformation -Delimiter "," | % { $_ -replace '"', ""} | out-file $Output -Encoding ascii
