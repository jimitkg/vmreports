
$vcenterservers = 'vcenter1', 'vcenter2'

Connect-VIServer $vcenterservers

$CSS2 =  get-content C:\temp\styles2.css

#Capturing data for VMs

$vms = Get-VM

#reportgeneratedtag
$reportgeneratedtag = (Get-Date -Format "dd MMMM yyyy HH:mm:ss")

#Capturing data for snapshots

    $paramsSnapshotFragment = @{'As'='Table';
            'PreContent'='<h2>VM Snapshots</h2>';
            'MakeTableDynamic'=$true;
            'TableCssClass'='grid';
            'Properties' = 'VM',@{Name = 'SnapshotName';Expression = {$_.Name}},'Created', @{Name = 'AgeDays';Expression = {((New-TimeSpan -Start $_.Created -End (get-date)).Days)};css={if (((New-TimeSpan -Start $_.Created -End (get-date)).Days) -gt 120) {'red'}}},'Description', @{name = 'SizeGB';expression = {[math]::Round($_.sizegb,2)};css={if ($_.sizegb -gt 100) {'red'}}}, 'PowerState','IsCurrent','ParentSnapshot','Children'
    }
    $snapshots = $vms |Get-Snapshot |ConvertTo-EnhancedHTMLFragment @paramsSnapshotFragment 

#PoweredOff

$paramsPoweredoff = @{'As'='Table';
'PreContent'='<h2>Powered Off VMs</h2>';
'MakeTableDynamic'=$true;
'TableCssClass'='grid';
'Properties' = 'Name','PowerState', 'Notes' , 'Folder'
}
$poweredoffvms = $vms |Where-Object {$_.PowerState -ne 'PoweredOn'}|ConvertTo-EnhancedHTMLFragment @paramsPoweredoff   

#PoweredOn

$paramsPoweredon = @{'As'='Table';
'PreContent'='<h2>Powered On VMs</h2>';
'MakeTableDynamic'=$true;
'TableCssClass'='grid';
'Properties' = 'Name','PowerState', 'Notes' , 'Folder'
}
$poweredonvms = $vms |Where-Object {$_.PowerState -eq 'PoweredOn'}|ConvertTo-EnhancedHTMLFragment @paramsPoweredon   


    # Finalising main html report
    $paramsMainHTML = @{
        'HTMLFragments' =  $reportgeneratedtag, $snapshots, $poweredoffvms, $poweredonvms
        'CssStyleSheet' =  $CSS2;
        'Title' = 'VM Status Report';
        'PreContent' = "<h1>VM Status Report</h1>"
    }
    ConvertTo-EnhancedHTML  @paramsMainHTML|Out-File "C:\Temp\VMStatusReport.html" -Encoding utf8


Disconnect-VIServer -Server $vcenterservers -Force -Confirm:$false
