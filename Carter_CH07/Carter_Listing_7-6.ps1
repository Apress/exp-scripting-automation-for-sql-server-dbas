# To specify multiple members of the sysadmin server role, 
# pass a comma seperate list to the -Administrators parameter
./AutoBuild.ps1 -InstanceName 'ESPROD5' -SQLServiceAccount 'SQLServiceAccount' -SQLServiceAccountPassword 'Pa££w0rd' -AgentServiceAccount 'SQLServiceAccount' -AgentServiceAccountPassword 'Pa££w0rd' -Administrators 'SQLAdmin'  
