#Prompt for parameter values
$InsanceName = Read-Host -Prompt "Please enter the name of the Instance: "
$SQLServiceAccount = Read-Host -Prompt "Please enter the SQL Server service account: "
$SQLServiceAccountPassword = read-host -Prompt "Please enter the SQL Server service account password: "
$AgentServiceAccount = Read-Host -Prompt "Please enter the SQL Server Agent service account: "
$AgentServiceAccountPassword = Read-Host -Prompt "Please enter the SQL Server Agent service account password: "
$Administrators = Read-Host -Prompt "Please enter the account that should be given SQL Administrative permissions: "
$InstanceWorkload = Read-Host -Prompt "Please enter the expected instance workload (OLTP, Data Warehouse or Mixed): "
$Port = Read-Host -Prompt "Please enter the name of the TCP Port that the instance should listen on: "

IF ($InstanceWorkload = "OLTP")
{
    $InstanceType = 1
}
ELSEIF ($InstanceWorkload = "Data Warehouse")
{
    $InstanceType = 2
}
ELSEIF ($InstanceType = "Mixed")
{
    $InstanceType = 3
}

$VMFlag = Read-Host -Prompt "Please indicate if the server is a VM (0 for physical, 1 for virtual): "

IF ($VMFlag = 1)
{
    $Hypervisor = read-host -Prompt "Please enter the name of the Hypervisor: "
}

$ApplicationOwner = read-host -prompt "Please enter the application owner: "
$ApplicationOwnerEmail = read-host -Prompt "Please enter the application owner's e-mail address: "
$saAccount = Read-Host -Prompt "Please enter the name of the sa account: "
$saAccountPassword = read-host -Prompt "Please enter the password of the sa account: "

#Install the Instance
./AutoBuild.ps1 -InstanceName $InstanceName -SQLServiceAccount $SQLServiceAccount -SQLServiceAccountPassword $SQLServiceAccountPassword -AgentServiceAccount $AgentServiceAccount -AgentServiceAccountPassword $AgentServiceAccountPassword -Administrators $Administrators

#Configure the Instance
./ConfigureInstance.ps1 -InstanceName $InstanceName -InstanceWorkload $InstanceWorkload

#Configure the Port
./ConfigurePort.ps1 -InstanceName $InstanceName -Port $Port


#Insert into the Inventory database
.\InsertInventory.ps1 -InstanceName $InstanceName -SQLServiceAccount $SQLServiceAccount -InstanceType $InstanceType -VMFlag $VMFlag -Hypervisor $Hypervisor -ApplicationOwner $ApplicationOwner -ApplicationOwnerEmail $ApplicationOwnerEmail -saAccount $saAccount -saAccountPassword $saAccountPassword 
