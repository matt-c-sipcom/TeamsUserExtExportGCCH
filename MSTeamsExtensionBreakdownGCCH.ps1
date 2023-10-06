# Connect to Microsoft Teams
Connect-MicrosoftTeams

#Get CustomerID from PSTN gateway to identify customer
$VoiceRoutes = Get-CsOnlineVoiceRoute
$GatewayFQDN = ""

foreach ($i in $VoiceRoutes){
if ($i.OnlinePstnGatewayList -like "*halo.sipcom.cloud")
{
$b = $i.OnlinePstnGatewayList
    foreach ($i in $b){
    $GatewayFQDN = $i
    }
}
}

# Generate the file name based on the Customer ID
$CustID = $GatewayFQDN.SubString(0,9) + ".csv"
$FilePath = "$env:APPDATA\$CustID"

# Get the results of the search
$results1 = Get-CsOnlineUser | Where-Object { $_.LineURI } | Select-Object LineUri, TeamsUpgradeEffectiveMode 

#Export the results of the search to a CSV file, or inform the user if it fails
try {
    $results1 | Export-Csv -Path "$FilePath" -NoTypeInformation
    Write-Host "Output saved to $CustID"
}
catch {
    Write-Host "Error saving output to $CustID"
}

#Add access key to the key variable to be able to upload file to secure storage
Write-Host "Please input the shared key from the email"
$key = Read-Host

#The target URL with SAS Token
$uri = "https://samsteamsextensionus.blob.core.windows.net/msteamsextension/$($CustID)?sp=racw&st=2023-10-06T14:08:27Z&se=2024-10-10T22:08:27Z&spr=https&sv=2022-11-02&sr=c&sig=$key"


#Define required Headers
$headers = @{
    'x-ms-blob-type' = 'BlockBlob'
}

#Upload File...
Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -InFile $FilePath

#Clean up file from roaming folder
remove-item -Path $FilePath -Force

#Process Complete
Write-Host "Process complete"
