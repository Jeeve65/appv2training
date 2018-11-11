 function timestamp(){
     return "[{0:HH:mm:ss}]" -f (Get-Date)
 }


Add-AzureRmAccount
Select-AzureRmSubscription -Subscription "MSDN - QBS Azure"
$pass= "VeryLongP@ss-AA05"



$resGroup= 'qbsextensionsv2training'
#Create VMs from 0 to 9

$vmName = "qbsappv2-0"
$serverCount = 10
$serverOffset = 0

#Create VMs from 10 to 15
#$vmName = "qbsappv2-1"
#$serverCount = 6
#$serverOffset = 0

$navVersion = "microsoft/bcsandbox:12.3.23590.23828-us"

$resLocation = 'West Europe'

# GO!
Write-Host "$(timestamp) Creating Azure resource group $resGroup"
$resourceGroup = Get-AzureRmResourceGroup -name $resGroup -ErrorAction Ignore
if (!$resourceGroup) {
    $resourceGroup = New-AzureRmResourceGroup -Name $resGroup -Location $resLocation
}
       
Write-Host "$(timestamp) Creating Azure resource group servers"
#$Servers  = Import-Csv  C:\DeployVMs\usersn.csv -Delimiter ";" 

#    $server= $_.Server
 #   $user= $_.User
  #  $pass= $_.Password
    
    Write-Host "$(timestamp) Creating Server $server"
    
    # ARM template
    # $templateUri = "https://raw.githubusercontent.com/andriusandrulevicius/WorkshopVM/master/getnavworkshopvms.json"
    # $templateUri = "C:\PSScripts\WorkshopVM-master\getnavworkshopvms.json"
    $templateUri = "https://github.com/Jeeve65/appv2training/blob/master/getnavworkshopvms.json"
        
    # Setup parameter array for ARM template
    $Parameters = New-Object -TypeName Hashtable
    $Parameters.Add("vmName", $vmName)
    $Parameters.Add("vmSize", "Standard_D11_v2")
    $Parameters.Add("vmAdminUsername", "student")
    $Parameters.Add("navAdminUsername", "student")
    $Parameters.Add("LicenseFileUri", "https://github.com/Jeeve65/appv2training/blob/master/MSDyn365BC.flf")
    $Parameters.Add("adminPassword", (ConvertTo-SecureString -String $pass -AsPlainText -Force))
    $Parameters.Add("navDockerImage", $navVersion)
    $Parameters.Add("count", $serverCount)
    $Parameters.Add("offset", $serverOffset)
    $Parameters.Add("RunWindowsUpdate", "Yes")

    
    #$Parameters.Add("country", $country.ToUpperInvariant())
    #$Parameters.Add("navVersion", $NavVersion)
    #$Parameters.Add("WorkshopFilesUrl", "https://www.dropbox.com/s/ubt7zdqvvlagzqx/Workshopfiles_AA.zip?dl=1")
    $Parameters.Add("WorkshopFilesUrl", "https://www.dropbox.com/s/3hk3xhzy0p8ngg3/Workshopfiles_AA.zip?dl=1")
    #$Parameters.Add("style", "workshop")        

    # $resourceGroup | Test-AzureRmResourceGroupDeployment -TemplateUri $templateUri -TemplateParameterObject $Parameters
    $resourceGroup | Test-AzureRmResourceGroupDeployment -TemplateUri $templateUri -TemplateParameterObject $Parameters
    $resourceGroup | New-AzureRmResourceGroupDeployment -TemplateUri $templateUri -TemplateParameterObject $Parameters -Name $vmName -ErrorAction Ignore
       
    #Restart-AzureRmVM -ResourceGroupName $resGroup -Name $vmName  

