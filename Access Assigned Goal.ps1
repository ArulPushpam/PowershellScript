# Get all forms in Sitecore
$forms = Get-Item -Path "\sitecore\Forms" | Get-ChildItem | Where-Object { $_.TemplateName -eq "Form" }


# Loop through each form and retrieve the relevant information
foreach ($form in $forms) {
    $formPath = $form.Paths.Path

$RedirecttoPage = Get-Item -Path $formPath"\Page\Submit Button\SubmitActions" | Get-ChildItem | Where-Object { $_.Name -eq "Your Template Name" }
Write-Host "RedirecttoPages:" $RedirecttoPage
$ParametersField= "Parameters"
    
 # Convert JSON string to PowerShell object
$jsonObject = $RedirecttoPage[$ParametersField] | ConvertFrom-Json

# Access the value from the PowerShell object
$referenceId = $jsonObject.referenceId

$successPageItem = Get-Item -Path "master:" -ID $referenceId

if (Test-Path -Path $successPageItem.Paths.Path) 
{
# Get the assigned goals for the item using the Goals property
$trackingField = $successPageItem.Fields["__Tracking"].Value 

Write-Host "trackingField Fields: "$trackingField , $successPageItem.Paths.Path



if (![string]::IsNullOrEmpty($trackingField)) {


$xml = New-Object System.Xml.XmlDocument
$xml.LoadXml("$trackingField")

$xmls = [xml]$xml

# Select the first node using the SelectSingleNode method
$firstNode = $xmls.SelectSingleNode("/*/*[1]")

#form Json Object
$jsonObject = @{
    "referenceId" = $firstNode.id
}

# Get the first assigned goal here
$triggerGoalString = $jsonObject | ConvertTo-Json

}

}

}

