#param([string]$ServerName, [string]$ProjectFilePath)

$ServerName = "USMK-DODSQA"
#need to Edit this Parameter "ProjectFilePath" with the main file path 
$ProjectFilePath = "\\kansas.us\qfs\IS\Shared\Projects\ValueCentric\Development\SSIS Projects\InternalSalesForceLoad\InternalSalesForceLoad\bin\Development\InternalSalesForceLoad.ispac"
                   
                   
$SSISCatalog     = "SSISDB"
$CatalogPwd      = "@909dev1!29db*"
$ProjectName     = "InternalSalesForceLoad"
$FolderName      = "SalesForce"
$EnvironmentName = "InternalSalesForceLoad"



#Exit Function to Dynamically Control Errors In Script upon deployments 
function ExitWithCode 
{ 
    param 
    ( 
        $exitcode 
    )
    $host.SetShouldExit($exitcode) 
}


#Dynamically configure the temp and archive file paths depending on server name
switch ($ServerName)
       {
              "USMK-DODSDEV" 
              
                           {
                                $SalesforceUserName   = "darlington.nwemeh@quidel.com"
                                $SalesforcePassword   = "Nndidi@4003ZJthPKcUHiiQ2bNF6TeGrVVn"
                                $SalesforceURLAddress = "https://test.salesforce.com/services/Soap/u/36.0"
								$NotificationEmail = "darlington.nwemeh@quidel.com"; break                   
                           }
                           
              "USMK-DODSQA"
               
                           {
 
                                $SalesforceUserName   = "sfdc.etl@quidel.com.fulldata"
                                $SalesforcePassword   = "12345dbaNyWKwGnKStFp39ATGqR17XEE5"
                                $SalesforceURLAddress = "https://test.salesforce.com/services/Soap/u/36.0"
								$NotificationEmail = "BISupport@quidel.com"; break                   
 
                           }
                           
           "USMK-DODSPROD" 
              
                           {

                                $SalesforceUserName   = "sfdc.etl@quidel.com"
                                $SalesforcePassword   = "12345dbaNyWKwGnKStFp39ATGqR17XEE5"
                                $SalesforceURLAddress = "https://login.salesforce.com/services/Soap/u/35.0"
								$NotificationEmail = "BISupport@quidel.com"; break   

                           }

                  default
                  
                           {     
                           
                                $SalesforceUserName   = "darlington.nwemeh@quidel.com"
                                $SalesforcePassword   = "Nndidi@4003ZJthPKcUHiiQ2bNF6TeGrVVn"
                                $SalesforceURLAddress = "https://test.salesforce.com/services/Soap/u/36.0"
								$NotificationEmail = "darlington.nwemeh@quidel.com"; break        
                                
                           }
       
       }


$eBLOBTempStoragePath = "";
$eBLOBTempStoragePath = "";


#Load Assembly for SQLServer Management Objects (SMO)
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')


$svr = New-Object('Microsoft.SqlServer.Management.Smo.Server')

#region SSIS Setup

    #Load the IntegrationServices Assembly
    [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices")

    # Store the IntegrationServices Assembly namespace to avoid typing it every time
    $ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"
 
  
    
#Begin Try (Error-Handling)
try
{

    Write-Host "Connecting to server"  $ServerName " ..."

    #Create a connection to the server
    $sqlConnectionString = "Data Source=$ServerName;Initial Catalog=master;Integrated Security=SSPI;"
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

    $integrationServices = New-Object "$ISNamespace.IntegrationServices" $sqlConnection


    #creating new catalog if ssisdb catalog doesn't exist 
    if ($integrationservices.catalogs.count -lt 1) 
    {
           write-host "creating new ssisdb catalog ..."            
           $cat = new-object $isnamespace".catalog" ($integrationservices,"ssisdb","@909dev1!29db*")            
           $cat.create()  
    }

    $catalog = $integrationServices.Catalogs["SSISDB"]

      #creating new project folder if folder doesn't exist
    if (!$catalog.folders[$foldername])
    {
           write-host "creating " $foldername " folder ..."
           $folder = new-object $isnamespace".catalogfolder" ($catalog, $foldername, "")
           $folder.create()
    }

 #endregion

$folder = $catalog.Folders[$foldername]

 #region deploying projects

    if ($folder.Projects.Item($ProjectName))
    {
        $folder.Projects.Item($ProjectName).Drop()
    }

     Write-Host "Deploying Projects ..."
    [byte[]] $projectFile = [System.IO.File]::ReadAllBytes($ProjectFilePath)
    $folder.DeployProject($ProjectName, $projectFile)
    #endregion

  #region Creating Environment for Initial-Load 

    $environment = $folder.Environments[$EnvironmentName]

    if ($environment)
    {
        Write-Host "Dropping environment..." 
        $environment.Drop()
    }

    write-host "creating " $environmentname " environment ..."
    $environment = New-Object $ISNamespace".EnvironmentInfo" ($folder, $EnvironmentName, $EnvironmentName)
    $environment.create()

    #Create project reference
    $project = $folder.Projects[$ProjectName]
    $ref = $project.References[$EnvironmentName, $folder.Name]

    if (!$ref)
    {
           Write-Host "Adding Project Reference ..."
           $project.References.Add($EnvironmentName, $folder.Name)
           $project.Alter()
    }


    #Add variable to environment
    Write-Host "Adding environment variables ..." 
    $environment.Variables.Add("eAuditServer", [System.TypeCode]::String, $ServerName, $false, "Audit Server Name")
    $environment.Variables.Add("eAuditDatabase", [System.TypeCode]::String, "ETLAudit", $false, "ETLAudit Database Name")
    $environment.Variables.Add("eTargetDatabase", [System.TypeCode]::String, "DODS", $false, "DODS Target Database Name")
    $environment.Variables.Add("eSourceServer", [System.TypeCode]::String, $ServerName, $false, "Source Server Name")
    $environment.Variables.Add("eTargetServer", [System.TypeCode]::String, $ServerName, $false, "Target Server Name")
    $environment.Variables.Add("eDebugMode", [System.TypeCode]::Boolean,"TRUE", $false, "SSIS Package DebugMode Set to TRUE")
    $environment.Variables.Add("eBLOBTempStoragePath", [System.TypeCode]::String, "", $false, "BLOBTempStoragePath")
    $environment.Variables.Add("eBufferTempStoragePath", [System.TypeCode]::String, "", $false, "BufferTempStoragePath")
    $environment.Variables.Add("eSalesForceUserName", [System.TypeCode]::String,$SalesforceUserName, $false, " SalesForce UserName")
    $environment.Variables.Add("eSalesForcePwd", [System.TypeCode]::String,$SalesforcePassword, $true, "SalesForce Password")
    $environment.Variables.Add("eURLAddress", [System.TypeCode]::String,$SalesforceURLAddress, $false, "SalesForce URL Address")
    $environment.Alter()

    #endregion

    #region InternalSalesForceLoad Project & Package Level Parameter Mapping
    Write-Host "Adding project reference ..."  
    $project.Parameters["pBLOBTempStoragePath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eBLOBTempStoragePath")
    $project.Parameters["pBufferTempStoragePath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eBufferTempStoragePath")
    $project.Parameters["pAuditServer"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eAuditServer")
    $project.Parameters["pAuditDatabase"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eAuditDatabase")
    $project.Parameters["pSourceServer"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSourceServer")
    $project.Parameters["pTargetDatabase"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eTargetDatabase")
    $project.Parameters["pTargetServer"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eTargetServer")
	$project.Parameters["pDebugMode"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eDebugMode") 
    $project.Parameters["pSalesForceUserName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSalesForceUserName")
    $project.Parameters["pSalesForcePwd"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSalesForcePwd")  
    $project.Parameters["pURLAddress"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eURLAddress")
    $project.Alter()   
    
    
	#new-object  -- InternalInboundNewDistributorAccounts
	Write-Host "Adding package reference ...InternalInboundNewDistributorAccounts"      
	$package =$project.Packages["InternalInboundNewDistributorAccounts.dtsx"]    
    #$package.Parameters["pNotificationEmail"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter()
    

    #new-object  -- InternalInboundSalesForceNewDirectAccounts
	Write-Host "Adding package reference ...InternalInboundSalesForceNewDirectAccounts"      
	$package =$project.Packages["InternalInboundSalesForceNewDirectAccounts.dtsx"]    
    #$package.Parameters["pNotificationEmail"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter()


    
	#new-object  -- InternalInBoundSalesforceAccountSetup 
	Write-Host "Adding package reference ...InternalInBoundSalesforceAccountSetup"      
    $package =$project.Packages["InternalInBoundSalesforceAccountSetup.dtsx"]       
    #$package.Parameters["pNotificationEmail"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter() 	 

      
    #new-object  -- InternalInBoundSalesforceMaster 
	Write-Host "Adding package reference ...InternalInBoundSalesforceMaster"      
    $package =$project.Packages["InternalInBoundSalesforceMaster.dtsx"]       
    #$package.Parameters["pNotificationEmail"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter() 	
    
    #endregion    
    
  }

catch

{
    $err = $Error[0].Exception ; 
    write-host "--> Deployment Error caught: " $err.Message ; 
    ExitWithCode 1
}

    
    
    


