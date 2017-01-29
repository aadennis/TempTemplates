https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-common-deployment-errors
GET https://management.azure.com/subscriptions/{subscription-id}/providers/Microsoft.Compute/skus?api-version=2016-03-30

/Subscriptions/9xxx/Providers/Microsoft.Compute/Locations/uksouth/Publishers/MicrosoftSQLServer

https://management.azure.com/subscriptions/xxx/providers/Microsoft.Compute/skus?api-version=2016-03-30

{"error":{"code":"AuthenticationFailed","message":"Authentication failed. The 'Authorization' header is missing."}}

(First login to get the subscription id)
Get-AzureRmVMImagePublisher -Location uksouth | Out-GridView
Add criteria..
PublisherName contains microsoftsql
returns 1 row
MicrosoftSQLServer
get that into a variable:
$publisher = Get-AzureRmVMImagePublisher -Location uksouth | ? {$_.PublisherName -like "*microsoftsql*"}
$publisher
$publisher | Get-Member
Get-AzureRmVMImageOffer -Location "uksouth" -PublisherName $publisher.PublisherName
Now you have the 2 parameters that provide to get the third, ie the sku:
1. Offer
2. PublisherName

So finally you can get
3. SKU



Get-AzureRmVMImageSku -Location "uksouth" -PublisherName "MicrosoftSQLServer"  -Offer "SQL2016SP1-WS2016"



Skus       Offer             PublisherName      Location
----       -----             -------------      --------
Enterprise SQL2016SP1-WS2016 MicrosoftSQLServer uksouth
Express    SQL2016SP1-WS2016 MicrosoftSQLServer uksouth
SQLDEV     SQL2016SP1-WS2016 MicrosoftSQLServer uksouth
Standard   SQL2016SP1-WS2016 MicrosoftSQLServer uksouth
Web        SQL2016SP1-WS2016 MicrosoftSQLServer uksouth

In the deployment template, this is what to apply:
"imagePublisher": {
      "type": "string",
      "defaultValue": "MicrosoftSQLServer",
      "metadata": {
        "description": "Image Publisher"
      }
    },

"imageOffer": {
      "type": "string",
      "defaultValue": "SQL2016SP1-WS2016",
      "metadata": {
        "description": "Image Offer"
      }
    },

 "imageSKU": {
      "type": "string",
      "defaultValue": "Express",
      "metadata": {
        "description": "Image SKU"
      }
    },


--
nice summary of what you are using:
Get-AzureRmVMUsage -Location "uksouth"

Name                         Current Value Limit  Unit
----                         ------------- -----  ----
Availability Sets                        1  2000 Count
Total Regional Cores                     8    20 Count
Virtual Machines                         2 10000 Count
Virtual Machine Scale Sets               0  2000 Count
Standard F Family Cores                  8    20 Count
Basic A Family Cores                     0    20 Count
Standard A0-A7 Family Cores              0    20 Count
Standard A8-A11 Family Cores             0    20 Count
Standard D Family Cores                  0    20 Count
Standard Dv2 Family Cores                0    20 Count
Standard G Family Cores                  0    20 Count
Standard DS Family Cores                 0    20 Count
Standard DSv2 Family Cores               0    20 Count
Standard GS Family Cores                 0    20 Count
Standard FS Family Cores                 0    20 Count
Standard NV Family Cores                 0    18 Count
Standard NC Family Cores                 0    18 Count
Standard H Family Cores                  0     8 Count
Standard Av2 Family Cores                0    20 Count
Standard LS Family Cores                 0    20 Count


