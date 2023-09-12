[CmdletBinding()]
param (
    [Parameter(Mandatory=$False, ParameterSetName="method")]
    [ValidateSet("Get","Delete","Post","PUT")]
    $method,
    $VGName,
    $PAT
)

[string]$Organization = "safiquddinkhan"
[string]$Project = "onestop"
$jsonFilePath = ".\variables.json" #sample file DevopsVG-variables.json attached in the same folder
$jsonbackupfolder = ".\"
$variableGroupName = $VGName
$DevopsPAT = $PAT

$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($DevopsPAT)"))
$header = @{authorization = "Basic $token"}

$projects = @()
$url = "https://dev.azure.com/$organization/_apis/projects?api-version=7.0"
$projects = Invoke-RestMethod -Uri $url -Method Get -Headers $header
$prjectid = ($projects.value|Where-Object{$_.name -eq $Project}).id

$url = $null
$varjson = @()

# Define the ID of the variable group you want to update, or use $null if you want to add a new variable group
$variableGroupId = $null # Replace this with the actual ID of the variable group, or use $null to add a new variable group
$variableGroup = @()
$url = "https://dev.azure.com/$organization/$project/_apis/distributedtask/variablegroups?api-version=7.0"

# Get a list of all variable groups using the REST API
$variableGroups = Invoke-RestMethod -Uri $url -Method Get -Headers $header

$variableGroup = $variableGroups.value | Where-Object { $_.name -eq $variableGroupName }
$date = Get-Date -format "yyyyMMddTHH-mm"
$BackupjsonFilePath = $jsonbackupfolder+$organization+"_"+$project+"_"+$variableGroupName+"_"+$date.ToString()+'.json'

If($variableGroup)
{
 $variableGroupId = $variableGroup.id
 Try
 {
     $result = @()
     $varjson = @()
     $url = "https://dev.azure.com/$organization/$project/_apis/distributedtask/variablegroups?groupIds="+$variableGroupId+'&api-version=7.0'
     $varjson = Invoke-RestMethod -Uri $url -Method Get -Headers $header
     $result = $varjson.value|ConvertTo-Json
     set-content -Path $BackupjsonFilePath -Value $result -Force
 }
 catch
 {
   exit
 }
}
$variables = Get-Content $jsonFilePath | ConvertFrom-Json
$requestBody = @()
if ($variableGroupId) {
    $url = "https://dev.azure.com/$organization/$project/_apis/distributedtask/variablegroups/"+$variableGroupId+"?api-version=7.0"
     $requestBody = @{
    name = $variableGroupName
    type= "Vsts"
    variables = $variables.variables
    variableGroupProjectReferences = @(@{
    name =  $variableGroupName
    projectReference = @{
        id = $prjectid
        name = $Project
    }
    })
    }| ConvertTo-Json -Depth 10
} else {
   $url= "https://dev.azure.com/$organization/$project/_apis/distributedtask/variablegroups?api-version=7.0"
   $requestBody = @{
    name = $variableGroupName
    type= "Vsts"
    variables = $variables.variables
    variableGroupProjectReferences = @(@{
    name =  $variableGroupName
    projectReference = @{
        id = $prjectid
        name = $Project
    }
    })
    }| ConvertTo-Json -Depth 10
}

if ($method -eq 'Get') {
    Write-Host "Requested method is $method"
    Write-Host "Variable Group Name:$variableGroupName"
    Write-Host "Variable Group ID:$variableGroupId"
    $Get_url = "https://dev.azure.com/$organization/$project/_apis/distributedtask/variablegroups/?groupIds="+$variableGroupId+"&api-version=7.0"
    $Result = Invoke-RestMethod -Uri $Get_url -Headers $header -Method Get
    $Variable = $Result.value.variables | ConvertTo-Json -Depth 100
    Write-Host $Variable
    Break
}
elseif ($method -eq 'Delete') {
    Write-Host "Requested method is $method"
    Write-Host "Variable Group Name:$variableGroupName"
    Write-Host "Variable Group ID:$variableGroupId"
    Write-Host "projectid is $prjectid"
    $Delete_URL = "https://dev.azure.com/$organization/$project/_apis/distributedtask/variablegroups/"+$variableGroupId+"?projectIds="+$prjectid+"+&api-version=7.0"
    try {
        $Result = Invoke-RestMethod -Uri $Delete_URL -Headers $header -Method Delete
        Write-Host $Result
    } catch {
        Write-Host $_
    }
    Break
}

# Define the HTTP method to use (Post for adding a new variable group, Patch for updating an existing variable group)
$method = if ($variableGroupId) { "PUT" } else { "Post" }

# Add or update the variable group using the REST API
try {
    Write-Host "Requested method is $method"
    Write-Host "Variable Group Name:$variableGroupName"
    Write-Host "Variable Group ID:$variableGroupId"
    Invoke-RestMethod -Uri $url -Method $method -ContentType "application/json" -Body $requestBody -Headers $header
} catch {
    Write-Host $_
}