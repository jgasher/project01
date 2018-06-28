$array = @()
$volumes = @()
$linuser = "root"
$linpass = "cpoc81906"
$linsecpass = ConvertTo-SecureString $linpass -AsPlainText -Force
$lincreds = New-Object System.Management.Automation.PSCredential ($linuser, $linsecpass)



for ($i=1; $i -le 8; $i++)
    {#echo loadgen0$i
    $array += "loadgen0"+$i
    }

$session = New-SSHSession -ComputerName loadgen0$i -Credential $lincreds -AcceptKey
write-host $session
foreach ($loadgen in $array)
    {write-host "Current loadgen is"$loadgen"."
    for ($node=1; $node -le 2; $node++)
        {
        for ($vol=1; $vol -le 8; $vol++)
        {
        if ($vol -ge 1 -and $vol -le 4)
            {$last=1}
        else {$last=2}

        $ipaddr = "172.16."+$node+".20"+$last -replace '\s',''
        #$ipaddr = "$ipaddr"+$vol -replace '\s',''
        $volname = $loadgen+"vol"+$vol+"node"+$node
        $mountpoint = "/mnt/vol"+$vol+"node"+$node -replace '\s',''
        write-host "volume"$loadgen"vol"$vol"node"$node
        write-host $ipaddr"/"$volname $mountpoint "nfs defaults 0 0"
        $volumes += $volname}
        }
    
    }

