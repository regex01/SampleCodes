#param([string]$ServerName, [string]$ProjectFilePath)

$ServerName = "USLV-BIDBDEV"
#need to Edit this Portion "ProjectFilePath" with the main file path 
$ProjectFilePath = "\\kansas.us\qfs\IS\Shared\Projects\Cognos\BI-013 - LN EMEA\Development\SSIS Projects\InboundERPLNEDWSTAGEProductLoad\bin\Development\InboundERPLNEDWSTAGEProductLoad.ispac"
                   

$SSISCatalog     = "SSISDB"
$CatalogPwd      = "@909dev1!29db*"
$ProjectName     = "InboundERPLNEDWSTAGEProductLoad"
$FolderName      = "ERPLN"
$EnvironmentName = "InboundERPLNEDWSTAGEProductLoad"



#Exit Function to Dynamically Control Errors In Scripts upon deployments 
function ExitWithCode 
{ 
    param 
    ( 
        $exitcode 
    )
    $host.SetShouldExit($exitcode) 
}


# Dynamically configure the temp and archive file paths depending on server name
switch ($ServerName)
       {
              "USLV-BIDBDEV" 
              
                           {

								$NotificationEmail         = "darlington.nwemeh@quidel.com"; 
                                $SourceDatabase                 = "EDW_STAGE";
                                $TargetDatabase                 = "EDW_STAGE";
                                $pSourceBOMTableName            = "ttibom010711";
                                $pSourceEnumsTableName          = "tttadv401000";
                                $pSourceLabelsTableName         = "tttadv140000";
                                $pSourceItemCostTableName       = "tticpr007711";
                                $pSourceItemOrdersTableName     = "ttcibd200711"; 
                                $pSourceItemPlanTableName       = "tcprpd100711";
                                $pSourceItemProdTableName       = "ttiipd001711";
                                $pSourceItemPurchaseTableName   = "ttdipu001711";
                                $pSourceItemsTableName          = "ttcibd001800";
                                $pSourceItemStandardTableName   = "tticpr300711";
                                $pSourceItemSubContTableName    = "tticpr160711";
                                $pSourceItemSurchargeTableName  = "tticpr110711";
                                $pSourceItemWHTableName         = "twhwmd400711";
                                $pSourceProdClassTableName      = "ttcmcs062700";
                                $pSourceProdLineTableName       = "ttcmcs061700";
                                $pSourceProdTypeTableName       = "ttcmcs015700";
                                 break;
  
                                                
                           }
                           
              "USLV-BIDBQA"
               
                           {
 
								$NotificationEmail         = "darlington.nwemeh@quidel.com"; 
                                $SourceDatabase                 = "EDW_STAGE";
                                $TargetDatabase                 = "EDW_STAGE";
                                $pSourceBOMTableName            = "ttibom010711";
                                $pSourceEnumsTableName          = "tttadv401000";
                                $pSourceLabelsTableName         = "tttadv140000";
                                $pSourceItemCostTableName       = "tticpr007711";
                                $pSourceItemOrdersTableName     = "ttcibd200711"; 
                                $pSourceItemPlanTableName       = "tcprpd100711";
                                $pSourceItemProdTableName       = "ttiipd001711";
                                $pSourceItemPurchaseTableName   = "ttdipu001711";
                                $pSourceItemsTableName          = "ttcibd001800";
                                $pSourceItemStandardTableName   = "tticpr300711";
                                $pSourceItemSubContTableName    = "tticpr160711";
                                $pSourceItemSurchargeTableName  = "tticpr110711";
                                $pSourceItemWHTableName         = "twhwmd400711";
                                $pSourceProdClassTableName      = "ttcmcs062700";
                                $pSourceProdLineTableName       = "ttcmcs061700";
                                $pSourceProdTypeTableName       = "ttcmcs015700";
                                 break;
   
                           }
                           
              "USLV-BIDBPROD" 
              
                           {

								$NotificationEmail              = "darlington.nwemeh@quidel.com"; 
                                $SourceDatabase                 = "EDW_STAGE";
                                $TargetDatabase                 = "EDW_STAGE";
                                $pSourceBOMTableName            = "ttibom010711";
                                $pSourceEnumsTableName          = "tttadv401000";
                                $pSourceLabelsTableName         = "tttadv140000";
                                $pSourceItemCostTableName       = "tticpr007711";
                                $pSourceItemOrdersTableName     = "ttcibd200711"; 
                                $pSourceItemPlanTableName       = "tcprpd100711";
                                $pSourceItemProdTableName       = "ttiipd001711";
                                $pSourceItemPurchaseTableName   = "ttdipu001711";
                                $pSourceItemsTableName          = "ttcibd001800";
                                $pSourceItemStandardTableName   = "tticpr300711";
                                $pSourceItemSubContTableName    = "tticpr160711";
                                $pSourceItemSurchargeTableName  = "tticpr110711";
                                $pSourceItemWHTableName         = "twhwmd400711";
                                $pSourceProdClassTableName      = "ttcmcs062700";
                                $pSourceProdLineTableName       = "ttcmcs061700";
                                $pSourceProdTypeTableName       = "ttcmcs015700";
                                 break;
   
                           }

                  default
                  
                           {     
                           
                                $NotificationEmail = "";
                                $LNSourceServer    = "";
                                $SourceDatabase    = "EDW_STAGE";
                                $TargetDatabase    = "EDW_STAGE";
                                $ERPLNUserUserName = "CognosETL";
                                $ERPLNPassword     = "";  break 

                                
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

    # Create a connection to the server
    $sqlConnectionString = "Data Source=$ServerName;Initial Catalog=master;Integrated Security=SSPI;"
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

    $integrationServices = New-Object "$ISNamespace.IntegrationServices" $sqlConnection


    # creating new catalog if ssisdb catalog doesn't exist 
    if ($integrationservices.catalogs.count -lt 1) 
    {
           write-host "creating new ssisdb catalog ..."            
           $cat = new-object $isnamespace".catalog" ($integrationservices,"ssisdb","#Passoword1")            
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

#region Creating Environment for Incremental-Load 

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
    $environment.Variables.Add("eAuditServer",[System.TypeCode]::String, $ServerName, $false, "Audit Server Name");
    $environment.Variables.Add(“eAuditDatabase”,[System.TypeCode]::String, "ETLAudit", $false, "Audit Database name");
    $environment.Variables.Add("eTargetDatabase",[System.TypeCode]::String,$TargetDatabase, $false, "Target Database Name");
    $environment.Variables.Add("eSourceDatabase",[System.TypeCode]::String,$SourceDatabase, $false, "ERPLN Source Database Name");
    $environment.Variables.Add("eSourceServer",[System.TypeCode]::String, $ServerName, $false, "ERPLN Source Server Name");
    $environment.Variables.Add("eTargetServer",[System.TypeCode]::String, $ServerName, $false, "Target Server Name");
    $environment.Variables.Add("eDebugMode",[System.TypeCode]::Boolean,"TRUE", $false, "SSIS Package DebugMode Set to TRUE");
    $environment.Variables.Add("eBLOBTempStoragePath", [System.TypeCode]::String, "", $false, "BLOBTempStoragePath");
    $environment.Variables.Add("eBufferTempStoragePath", [System.TypeCode]::String, "", $false, "BufferTempStoragePath");
    $environment.Variables.Add("eSourceBOMTableName", [System.TypeCode]::String,$pSourceBOMTableName, $false, "BOM Source Table Name");
    $environment.Variables.Add("eSourceEnumsTableName", [System.TypeCode]::String,$pSourceEnumsTableName, $false, "ENUM Source Table Name");
    $environment.Variables.Add("eSourceLabelsTableName", [System.TypeCode]::String,$pSourceLabelsTableName, $false, "Labels Source Table Name");
    $environment.Variables.Add("eSourceItemCostTableName", [System.TypeCode]::String,$pSourceItemCostTableName, $false, "Item Costs  Source Table Name");
    $environment.Variables.Add("eSourceItemOrdersTableName", [System.TypeCode]::String,$pSourceItemOrdersTableName, $false, "Items Orders Source Table Name");
    $environment.Variables.Add("eSourceItemPlanTableName", [System.TypeCode]::String,$pSourceItemPlanTableName, $false, "Item Plans Source Table Name");
    $environment.Variables.Add("eSourceItemProdTableName", [System.TypeCode]::String,$pSourceItemProdTableName, $false, "Prod Table Source Table Name");
    $environment.Variables.Add("eSourceItemPurchaseTableName", [System.TypeCode]::String,$pSourceItemPurchaseTableName, $false, "Item Purch  Source Table Name");
    $environment.Variables.Add("eSourceItemsTableName", [System.TypeCode]::String,$pSourceItemsTableName, $false, "Items Source Table Name");
    $environment.Variables.Add("eSourceItemStandardTableName", [System.TypeCode]::String,$pSourceItemStandardTableName, $false, "Items Stand Source Table Name");
    $environment.Variables.Add("eSourceItemSubContTableName", [System.TypeCode]::String,$pSourceItemSubContTableName, $false, "Item Sub Cont Source Table Name");
    $environment.Variables.Add("eSourceItemSurchargeTableName", [System.TypeCode]::String,$pSourceItemSurchargeTableName, $false, "Items Surch  Source Table Name");
    $environment.Variables.Add("eSourceItemWHTableName", [System.TypeCode]::String,$pSourceItemWHTableName, $false, "Item WH Source Table Name");
    $environment.Variables.Add("eSourceProdClassTableName", [System.TypeCode]::String,$pSourceProdClassTableName, $false, "Prod Class Source Table Name");
    $environment.Variables.Add("eSourceProdLineTableName", [System.TypeCode]::String,$pSourceProdLineTableName, $false, "Prod Line Source Table Name");
    $environment.Variables.Add("eSourceProdTypeTableName", [System.TypeCode]::String,$pSourceProdTypeTableName, $false, "Prod Type Source Table Name");
    $environment.Alter()
#
    
#endregion

#region SalesForceDODSStagingLoad Project & Package Level Parameter Mapping
    Write-Host "Adding project reference ..."  
    $project.Parameters["pBLOBTempStoragePath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eBLOBTempStoragePath");
    $project.Parameters["pBufferTempStoragePath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eBufferTempStoragePath");
    $project.Parameters["pAuditServer"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eAuditServer");
    $project.Parameters["pAuditDatabase"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eAuditDatabase");
    $project.Parameters["pSourceDatabase"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSourceDatabase");
    $project.Parameters["pSourceServer"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSourceServer");
    $project.Parameters["pTargetDatabase"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eTargetDatabase");
    $project.Parameters["pTargetServer"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eTargetServer");
	$project.Parameters["pDebugMode"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eDebugMode");
    $project.Alter() 
    
    
    #new-object  -- InternalInboundERPLNBOMIncr
	Write-Host "Adding package reference ...InternalInboundERPLNBOMIncr"      
	$package=$project.Packages["InternalInboundERPLNBOMIncr.dtsx"]    
    $package.Parameters["pSourceBOMTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceBOMTableName"); 
    $package.Alter()
   

    #new-object  -- InternalInboundERPLNCommonEnumsSetsIncr
	Write-Host "Adding package reference ...InternalInboundERPLNCommonEnumsSetsIncr"      
	$package =$project.Packages["InternalInboundERPLNCommonEnumsSetsIncr.dtsx"]    
    $package.Parameters["pSourceEnumsTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceEnumsTableName");  
    $package.Alter()
    

	#new-object  -- InternalInboundERPLNCommonLabelsByPackageIncr
	Write-Host "Adding package reference ...InternalInboundERPLNCommonLabelsByPackageIncr"      
	$package =$project.Packages["InternalInboundERPLNCommonLabelsByPackageIncr.dtsx"]    
    $package.Parameters["pSourceLabelsTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceLabelsTableName"); 
    $package.Alter()
    
   
    #new-object  -- InternalInboundERPLNItemCostingDataIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemCostingDataIncr"      
    $package =$project.Packages["InternalInboundERPLNItemCostingDataIncr.dtsx"]       
    $package.Parameters["pSourceItemCostTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemCostTableName");
    $package.Alter()    


    #new-object  -- InternalInboundERPLNItemOrderingIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemOrderingIncr"      
    $package =$project.Packages["InternalInboundERPLNItemOrderingIncr.dtsx"]       
    $package.Parameters["pSourceItemOrdersTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemOrdersTableName"); 
    $package.Alter()    
   
    
    #new-object  -- InternalInboundERPLNItemPlanningIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemPlanningIncr"      
    $package=$project.Packages["InternalInboundERPLNItemPlanningIncr.dtsx"]       
    $package.Parameters["pSourceItemPlanTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemPlanTableName"); 
    $package.Alter() 	
  
    #new-object  -- InternalInboundERPLNItemProductionDataIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemProductionDataIncr"      
    $package =$project.Packages["InternalInboundERPLNItemProductionDataIncr.dtsx"]       
    $package.Parameters["pSourceItemProdTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemProdTableName"); 
    $package.Alter() 	
    

    #new-object  -- InternalInboundERPLNItemPurchaseDataIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemPurchaseDataIncr"      
    $package =$project.Packages["InternalInboundERPLNItemPurchaseDataIncr.dtsx"]       
    $package.Parameters["pSourceItemPurchaseTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemPurchaseTableName"); 
    $package.Alter() 	

    #new-object  -- InternalInboundERPLNItemsIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemsIncr"      
    $package =$project.Packages["InternalInboundERPLNItemsIncr.dtsx"]       
    $package.Parameters["pSourceItemsTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemsTableName"); 
    $package.Alter() 	

    #new-object  -- InternalInboundERPLNItemStandardCostIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemStandardCostIncr"      
    $package =$project.Packages["InternalInboundERPLNItemStandardCostIncr.dtsx"]       
    $package.Parameters["pSourceItemStandardTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemStandardTableName"); 
    $package.Alter() 	

    #new-object  -- InternalInboundERPLNItemSubcontractingIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemSubcontractingIncr"      
    $package =$project.Packages["InternalInboundERPLNItemSubcontractingIncr.dtsx"]       
    $package.Parameters["pSourceItemSubContTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemSubContTableName"); 
    $package.Alter() 	


    #new-object  -- InternalInboundERPLNItemSurchargesIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemSurchargesIncr"      
    $package =$project.Packages["InternalInboundERPLNItemSurchargesIncr.dtsx"]       
    $package.Parameters["pSourceItemSurchargeTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemSurchargeTableName"); 
    $package.Alter() 
    	

    #new-object  -- InternalInboundERPLNItemWarehousingDataIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNItemWarehousingDataIncr"      
    $package =$project.Packages["InternalInboundERPLNItemWarehousingDataIncr.dtsx"]       
    $package.Parameters["pSourceItemWHTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceItemWHTableName"); 
    $package.Alter() 	

    #new-object  -- InternalInboundERPLNProductClassIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNProductClassIncr"      
    $package =$project.Packages["InternalInboundERPLNProductClassIncr.dtsx"]       
    $package.Parameters["pSourceProdClassTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceProdClassTableName"); 
    $package.Alter() 	

    #new-object  -- InternalInboundERPLNProductLineIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNProductLineIncr"      
    $package =$project.Packages["InternalInboundERPLNProductLineIncr.dtsx"]       
    $package.Parameters["pSourceProdLineTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceProdLineTableName"); 
    $package.Alter() 	

    #new-object  -- InternalInboundERPLNProductTypeIncr 
	Write-Host "Adding package reference ...InternalInboundERPLNProductTypeIncr"      
    $package =$project.Packages["InternalInboundERPLNProductTypeIncr.dtsx"]       
    $package.Parameters["pSourceProdTypeTableName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceProdTypeTableName"); 
    $package.Alter() 	

  
    #new-object  -- InternalInboundERPLNEDWSTAGEProductLoadMaster 
	Write-Host "Adding package reference ...InternalInboundERPLNEDWSTAGEProductLoadMaster"      
    $package =$project.Packages["InternalInboundERPLNEDWSTAGEProductLoadMaster.dtsx"]       
    #$package.Parameters["pNotificationEmail"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter() 	
  

  }

catch

{
    $err = $Error[0].Exception ; 
    write-host "--> Deployment Error caught: " $err.Message; 
    ExitWithCode 0
}
 
 
 
    
#endregion

