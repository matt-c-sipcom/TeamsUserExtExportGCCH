This script exports ONLY the LineURI and TeamsUpgradeEffectiveMode information for all users with Teams Phone System. The script connects to your AzureAD tenant using the Teams PowerShell Module and requires "Teams Administrator" permissions to run.

Once the data has been exported to a local CSV file, it is then secure stored in an Azure blob (US Located) provided by your Direct Routing provider. This will then be used to provide continual extention support required due to MS487014

The local CSV file is deleted as part of the script.
