

$vcenterservers = "vcenterserver1","vcenterserver2"
$cssfile = "C:\temp\Style.css"
$temphtmlfile = "C:\Temp\VMsOfflineReport.html"
$reporttitle = "VMs Offline Report"
$smtpserver = "smtpserver.myorg.com.au"
$to = "admin@myorg.com.au"
$from = "PowerShell Reports <donotreply@myorg.com.au>"


Connect-VIServer -Server $vcenterservers

$CSS = get-content $cssfile
$head1 = "<style>$CSS</style>"
$precon = "<H1>$reporttitle</H1></p>"  + "Report generated on: " + (get-date).ToString()


$ReportData = Get-VM | where {$_.PowerState -ne 'PoweredOn'}| Select-Object @(
        'Name'
        @{Name = 'HostName' ; Expression = {$_.Guest.HostName}}
        'PowerState'
        'Notes'
        @{Name = 'OSFullName'; Expression = {$_.Guest.OSFullName}}
        @{Name = 'NICS' ; Expression = {$_.Guest.NICS}}
        )|
	Sort Name	

$ReportData |ConvertTo-HTML -Head $head1 -Title $reporttitle -PreContent $precon  -PostContent "</p>This is a demo report."|
Out-File $temphtmlfile

Disconnect-VIServer -Server $vcenterservers -Force -Confirm:$false

$HashParams = @{

    From = $from
    To = $to
    Subject = "VMs Offline Report"
    Body = "Attached is a list of VMs found in offline state today."
    Attachments = $temphtmlfile
    SmtpServer = $smtpserver
    port = "25"
    Credential = New-Object System.Management.Automation.PSCredential("anonymous",(ConvertTo-SecureString -String "anonymous" -AsPlainText -Force))
    DeliveryNotificationOption= "OnSuccess"
}

Send-MailMessage @HashParams


