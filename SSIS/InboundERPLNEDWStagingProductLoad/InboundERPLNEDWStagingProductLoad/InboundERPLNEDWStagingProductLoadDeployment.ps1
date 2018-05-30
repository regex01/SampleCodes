#param([string]$ServerName, [string]$ProjectFilePath)

$ServerName = "USLV-BIDBDEV"
#need to Edit this Portion "ProjectFilePath" with the main file path 
$ProjectFilePath = "\\kansas.us\qfs\IS\Shared\Projects\Cognos\BI-013 - LN EMEA\Development\SSIS Projects\InboundERPLNEDWStagingProductLoad\InboundERPLNEDWStagingProductLoad\bin\Development\InboundERPLNEDWStagingProductLoad.ispac"
                   
$SSISCatalog     = "SSISDB"
$CatalogPwd      = "@909dev1!29db*"
$ProjectName     = "InboundERPLNEDWStagingProductLoad"
$FolderName      = "ERPLN"
$EnvironmentName = "InboundERPLNEDWStagingProductLoad"


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
								$NotificationEmail            = "darlington.nwemeh@quidel.com"; 
                                $LNSourceServer               = "10.150.4.107";
                                $SourceDatabase               = "inforlndb";
                                $TargetDatabase				  = "EDW_STAGE";                          
								$pSource100111Param           = "ttcibd100711";
								$pTarget100111Param           = "ttcibd100711";  
								$pSourcePd001111Param         = "ttiipd001711";
								$pTargetPd001111Param         = "ttiipd001711";
								$pSourcePu001111Param         = "ttdipu001711";
								$pTargetPu001111Param         = "ttdipu001711";
								$pSource200111Param           = "ttcibd200711";
								$pTarget200111Param           = "ttcibd200711";
								$pSourceCpr110111Param        = "tticpr110711";
								$pTargetCpr110111Param        = "tticpr110711";
								$pSource110100Param           = "ttiedm110700";
								$PTarget110100Param           = "ttiedm110700";
								$pSource010100Param           = "ttibom010700";
								$PTarget010100Param           = "ttibom010700";
								$pSource007111Param           = "tticpr007711";
								$PTarget007111Param           = "tticpr007711";
								$pSourcePd100111Param         = "tcprpd100711";
								$pTargetPd100111Param         = "tcprpd100711";
								$pSource300111Param           = "tticpr300711";
								$PTarget300111Param           = "tticpr300711";
								$pSource400111Param           = "twhwmd400711";
								$PTarget400111Param           = "twhwmd400711";
								$pSource160111Param           = "tticpr160711";
								$PTarget160111Param           = "tticpr160711";
								$pSource061100Param           = "ttcmcs061700";
								$PTarget061100Param           = "ttcmcs061700";
								$pSourceBd001100Param         = "ttcibd001700";
								$PTargetBd001100Param         = "ttcibd001700";
								$pSource015100Param           = "ttcmcs015700";
								$PTarget015100Param           = "ttcmcs015700";
								$pSource062100Param           = "ttcmcs062700";
								$pTarget062100Param           = "ttcmcs062700";
								$pSource140000Param           = "tttadv140000";
								$PTarget140000Param           = "tttadv140000";
								$pSource401000Param           = "tttadv401000";
								$PTarget401000Param           = "tttadv401000";
                                $pSourceBOM010111Param        = "ttibom010711";
                                $pTargetBOM010111Param        = "ttibom010711";
                                $ERPLNUserUserName            = "CognosETLSQL";
                                $ERPLNPassword                = "CuwzJijhQMCnLcMzx2JW";
                                $pERPLNConnectionString    = "Data Source=10.150.4.107; User ID=CognosETLSQL; Initial Catalog=inforlndb; Provider=SQLNCLI11.1; Persist Security Info=True; Auto Translate=False;";
                                 break;
  
                                                
                           }
                           
              "USLV-BIDBQA"
               
                           {
 
								$NotificationEmail            = "BISupport@quidel.com";
                                $LNSourceServer               = "";
                                $SourceDatabase               = "inforlndb";
                                $TargetDatabase				  = "EDW_STAGE";                          
								$pSource100111Param           = "ttcibd100911";
								$pTarget100111Param           = "ttcibd100911";  
								$pSourcePd001111Param         = "ttiipd001911";
								$pTargetPd001111Param         = "ttiipd001911";
								$pSourcePu001111Param         = "ttdipu001911";
								$pTargetPu001111Param         = "ttdipu001911";
								$pSource200111Param           = "ttcibd200911";
								$pTarget200111Param           = "ttcibd200911";
								$pSourceCpr110111Param        = "tticpr110911";
								$pTargetCpr110111Param        = "tticpr110911";
								$pSource110100Param           = "ttiedm110800";
								$PTarget110100Param           = "ttiedm110800";
								$pSource010100Param           = "ttibom010800";
								$PTarget010100Param           = "ttibom010800";
								$pSource007111Param           = "tticpr007911";
								$PTarget007111Param           = "tticpr007911";
								$pSourcePd100111Param         = "tcprpd100711";
								$pTargetPd100111Param         = "tcprpd100711";
								$pSource300111Param           = "tticpr300911";
								$PTarget300111Param           = "tticpr300911";
								$pSource400111Param           = "twhwmd400911";
								$PTarget400111Param           = "twhwmd400911";
								$pSource160111Param           = "tticpr160911";
								$PTarget160111Param           = "tticpr160911";
								$pSource061100Param           = "ttcmcs061800";
								$PTarget061100Param           = "ttcmcs061800";
								$pSourceBd001100Param         = "ttcibd001800";
								$PTargetBd001100Param         = "ttcibd001800";
								$pSource015100Param           = "ttcmcs015800";
								$PTarget015100Param           = "ttcmcs015800";
								$pSource062100Param           = "ttcmcs062700";
								$pTarget062100Param           = "ttcmcs062700";
								$pSource140000Param           = "tttadv140000";
								$PTarget140000Param           = "tttadv140000";
								$pSource401000Param           = "tttadv401000";
								$PTarget401000Param           = "tttadv401000";
                                $pSourceBOM010111Param        = "ttibom010611";
                                $pTargetBOM010111Param        = "ttibom010611";
                                $ERPLNUserUserName            = "CognosETL";
                                $ERPLNPassword                = "CuwzJijhQMCnLcMzx2JW";
                                $pERPLNConnectionString       = "Data Source=10.150.4.107; User ID=CognosETLSQL; Initial Catalog=inforlndb; Provider=SQLNCLI11.1; Persist Security Info=True; Auto Translate=False;";
                                break;
   
                           }
                           
              "USLV-BIDBPROD" 
              
                           {

								$NotificationEmail		      = "BISupport@quidel.com"
                                $SourceServer                 = "";
                                $SourceDatabase				  = "inforlndb";
                                $TargetDatabase				  = "EDW_STAGE";                            
								$pSource100111Param           = "ttcibd100111";
								$pTarget100111Param           = "ttcibd100111"; 
								$pSourcePd001111Param         = "ttiipd001111";
								$pTargetPd001111Param         = "ttiipd001111";
								$pSourcePu001111Param         = "ttdipu001111";
								$pTargetPu001111Param         = "ttdipu001111";
								$pSource200111Param           = "ttcibd200111";
								$pTarget200111Param           = "ttcibd200111";
								$pSourceCpr110111Param        = "tticpr110111";
								$pTargetCpr110111Param        = "tticpr110111";
								$pSource110100Param           = "ttiedm110100";
								$PTarget110100Param           = "ttiedm110100";
								$pSource010100Param           = "ttibom010100";
								$PTarget010100Param           = "ttibom010100";
								$pSource007111Param           = "tticpr007111";
								$PTarget007111Param           = "tticpr007111";
								$pSourcePd100111Param         = "tcprpd100711";
								$pTargetPd100111Param         = "tcprpd100711";
								$pSource300111Param           = "tticpr300111";
								$PTarget300111Param           = "tticpr300111";
								$pSource400111Param           = "twhwmd400111";
								$PTarget400111Param           = "twhwmd400111";
								$pSource160111Param           = "tticpr160111";
								$PTarget160111Param           = "tticpr160111";
								$pSource061100Param           = "ttcmcs061100";
								$PTarget061100Param           = "ttcmcs061100";
								$pSourceBd001100Param         = "ttcibd001100";
								$PTargetBd001100Param         = "ttcibd001100";
								$pSource015100Param           = "ttcmcs015100";
								$PTarget015100Param           = "ttcmcs015100";
								$pSource062100Param           = "ttcmcs062700";
								$pTarget062100Param           = "ttcmcs062700";
								$pSource140000Param           = "tttadv140000";
								$PTarget140000Param           = "tttadv140000";
								$pSource401000Param           = "tttadv401000";
								$PTarget401000Param           = "tttadv401000";
                                $pSourceBOM010111Param        = "ttibom010111";
                                $pTargetBOM010111Param        = "ttibom010111";
                                $ERPLNUserUserName            = "CognosETL";
                                $ERPLNPassword                = ""
                                $pERPLNConnectionString       = "Data Source=10.150.4.107; User ID=CognosETLSQL; Initial Catalog=inforlndb; Provider=SQLNCLI11.1; Persist Security Info=True; Auto Translate=False;";
                                break;     
                            
							}

                  default
                  
                           {     
                           
                                $NotificationEmail = "";
                                $LNSourceServer    = "";
                                $SourceDatabase    = "inforlndb";
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
    $environment.Variables.Add("eAuditServer",[System.TypeCode]::String, $ServerName, $false, "Audit Server Name");
    $environment.Variables.Add("eAuditDatabase",[System.TypeCode]::String, "ETLAudit", $false, "Audit Database name");
    $environment.Variables.Add("eTargetDatabase",[System.TypeCode]::String,$TargetDatabase, $false, "Target Database Name");
    $environment.Variables.Add("eSourceDatabase",[System.TypeCode]::String,$SourceDatabase, $false, "ERPLN Source Database Name");
    $environment.Variables.Add("eSourceServer",[System.TypeCode]::String, $LNSourceServer, $false, "ERPLN Source Server Name");
    $environment.Variables.Add("eTargetServer",[System.TypeCode]::String, $ServerName, $false, "Target Server Name");
    $environment.Variables.Add("eDebugMode",[System.TypeCode]::Boolean,"TRUE", $false, "SSIS Package DebugMode Set to TRUE");
    $environment.Variables.Add("eBLOBTempStoragePath", [System.TypeCode]::String, "", $false, "BLOBTempStoragePath");
    $environment.Variables.Add("eBufferTempStoragePath", [System.TypeCode]::String, "", $false, "BufferTempStoragePath");
    $environment.Variables.Add("eERPLNConnectionString", [System.TypeCode]::String,$pERPLNConnectionString, $false, "ERPLN Cloud Connection String");
	$environment.Variables.Add("eSource100111Param", [System.TypeCode]::String,$pSource100111Param, $false,"100111 Source Param Name");
	$environment.Variables.Add("eTarget100111Param", [System.TypeCode]::String,$pTarget100111Param, $false,"100111 Target Param Name");
	$environment.Variables.Add("eSourcePd001111Param", [System.TypeCode]::String,$pSourcePd001111Param, $false,"001111 Source Param Name");
	$environment.Variables.Add("eTargetPd001111Param", [System.TypeCode]::String,$pTargetPd001111Param, $false,"001111 Target Param Name");
	$environment.Variables.Add("eSourcePu001111Param", [System.TypeCode]::String,$pSourcePu001111Param, $false,"001111 Source Param Name");
	$environment.Variables.Add("eTargetPu001111Param", [System.TypeCode]::String,$pTargetPu001111Param, $false,"001111 Target Param Name");
	$environment.Variables.Add("eSource200111Param", [System.TypeCode]::String,$pSource200111Param, $false,"200111 Source Param Name");
	$environment.Variables.Add("eTarget200111Param", [System.TypeCode]::String,$pTarget200111Param, $false,"200111 Target Param Name");
	$environment.Variables.Add("eSourceCpr110111Param", [System.TypeCode]::String,$pSourceCpr110111Param, $false,"110111 Source Param Name");
	$environment.Variables.Add("eTargetCpr110111Param", [System.TypeCode]::String,$pTargetCpr110111Param, $false,"110111 Target Param Name");
	$environment.Variables.Add("eSource110100Param", [System.TypeCode]::String,$pSource110100Param, $false,"110100 Source Param Name");
	$environment.Variables.Add("eTarget110100Param", [System.TypeCode]::String,$pTarget110100Param, $false,"110100 Target Param Name");
	$environment.Variables.Add("eSource010100Param", [System.TypeCode]::String,$pSource010100Param, $false,"010100 Source Param Name");
	$environment.Variables.Add("eTarget010100Param", [System.TypeCode]::String,$pTarget010100Param, $false,"010100 Target Param Name");
	$environment.Variables.Add("eSource007111Param", [System.TypeCode]::String,$pSource007111Param, $false,"007111 Source Param Name");
	$environment.Variables.Add("eTarget007111Param", [System.TypeCode]::String,$PTarget007111Param, $false,"007111 Target Param Name");
	$environment.Variables.Add("eSourcePd100111Param", [System.TypeCode]::String,$pSourcePd100111Param, $false,"Pd100111 Source Param Name");
	$environment.Variables.Add("eTargetPd100111Param", [System.TypeCode]::String,$pTargetPd100111Param, $false,"Pd100111 Target Param Name");
	$environment.Variables.Add("eSource300111Param", [System.TypeCode]::String,$pSource300111Param, $false,"300111 Source Param Name");
	$environment.Variables.Add("eTarget300111Param", [System.TypeCode]::String,$PTarget300111Param, $false,"300111 Target Param Name");
	$environment.Variables.Add("eSource400111Param", [System.TypeCode]::String,$pSource400111Param, $false,"400111 Source Param Name");
	$environment.Variables.Add("eTarget400111Param", [System.TypeCode]::String,$PTarget400111Param, $false,"400111 Target Param Name");
	$environment.Variables.Add("eSource160111Param", [System.TypeCode]::String,$pSource160111Param, $false,"160111 Source Param Name");
	$environment.Variables.Add("eTarget160111Param", [System.TypeCode]::String,$pTarget160111Param, $false,"160111 Target Param Name");
	$environment.Variables.Add("eSource061100Param", [System.TypeCode]::String,$pSource061100Param, $false,"061100 Source Param Name");
	$environment.Variables.Add("eTarget061100Param", [System.TypeCode]::String,$pTarget061100Param, $false,"061100 Target Param Name");
	$environment.Variables.Add("eSourceBd001100Param", [System.TypeCode]::String,$pSourceBd001100Param, $false,"001100 Source Param Name");
	$environment.Variables.Add("eTargetBd001100Param", [System.TypeCode]::String,$pTargetBd001100Param, $false,"001100 Target Param Name");
	$environment.Variables.Add("eSource015100Param", [System.TypeCode]::String,$pSource015100Param, $false,"015100 Source Param Name");
	$environment.Variables.Add("eTarget015100Param", [System.TypeCode]::String,$pTarget015100Param, $false,"015100 Target Param Name");
	$environment.Variables.Add("eSource062100Param", [System.TypeCode]::String,$pSource062100Param, $false,"062100 Source Param Name");
	$environment.Variables.Add("eTarget062100Param", [System.TypeCode]::String,$pTarget062100Param, $false,"062100 Target Param Name");
	$environment.Variables.Add("eSource140000Param", [System.TypeCode]::String,$pSource140000Param, $false,"140000 Source Param Name");
	$environment.Variables.Add("eTarget140000Param", [System.TypeCode]::String,$pTarget140000Param, $false,"140000 Target Param Name");
	$environment.Variables.Add("eSource401000Param", [System.TypeCode]::String,$pSource401000Param, $false,"401000 Source Param Name");
	$environment.Variables.Add("eTarget401000Param", [System.TypeCode]::String,$pTarget401000Param, $false,"401000 Target Param Name");
	$environment.Variables.Add("eSourceBOM010111Param", [System.TypeCode]::String,$pSourceBOM010111Param, $false,"BOM010111 Source Param Name");
	$environment.Variables.Add("eTargetBOM010111Param", [System.TypeCode]::String,$pTargetBOM010111Param, $false,"BOM010111 Target Param Name");
    $environment.Alter()
  
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
    $project.Parameters["pERPLNConnectionString"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eERPLNConnectionString");   
    $project.Alter() 
    
  
	#new-object --InternalInboundERPLNttcibd100111Init
	Write-Host "Adding package reference ...InternalInboundERPLNttcibd100111Init"
	$package=$project.Packages["InternalInboundERPLNttcibd100111Init.dtsx"]
	$package.Parameters["pSource100111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource100111Param");
	$package.Parameters["pTarget100111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget100111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNttiipd001111Init
	Write-Host "Adding package reference ...InternalInboundERPLNttiipd001111Init"
	$package=$project.Packages["InternalInboundERPLNttiipd001111Init.dtsx"]
	$package.Parameters["pSourcePd001111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourcePd001111Param");
	$package.Parameters["pTargetPd001111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTargetPd001111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNttdipu001111Init
	Write-Host "Adding package reference ...InternalInboundERPLNttdipu001111Init"
	$package=$project.Packages["InternalInboundERPLNttdipu001111Init.dtsx"]
	$package.Parameters["pSourcePu001111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourcePu001111Param");
	$package.Parameters["pTargetPu001111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTargetPu001111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNttcibd200111Init
	Write-Host "Adding package reference ...InternalInboundERPLNttcibd200111Init"
	$package=$project.Packages["InternalInboundERPLNttcibd200111Init.dtsx"]
	$package.Parameters["pSource200111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource200111Param");
	$package.Parameters["pTarget200111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget200111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNtticpr110111Init
	Write-Host "Adding package reference ...InternalInboundERPLNtticpr110111Init"
	$package=$project.Packages["InternalInboundERPLNtticpr110111Init.dtsx"]
	$package.Parameters["pSourceCpr110111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceCpr110111Param");
	$package.Parameters["pTargetCpr110111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTargetCpr110111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNtticpr007111Init
	Write-Host "Adding package reference ...InternalInboundERPLNtticpr007111Init"
	$package=$project.Packages["InternalInboundERPLNtticpr007111Init.dtsx"]
	$package.Parameters["pSource007111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource007111Param");
	$package.Parameters["pTarget007111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget007111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNtcprpd100111Init
	Write-Host "Adding package reference ...InternalInboundERPLNtcprpd100111Init"
	$package=$project.Packages["InternalInboundERPLNtcprpd100111Init.dtsx"]
	$package.Parameters["pSourcePd100111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourcePd100111Param");
	$package.Parameters["pTargetPd100111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTargetPd100111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNtticpr300111Init
	Write-Host "Adding package reference ...InternalInboundERPLNtticpr300111Init"
	$package=$project.Packages["InternalInboundERPLNtticpr300111Init.dtsx"]
	$package.Parameters["pSource300111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource300111Param");
	$package.Parameters["pTarget300111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget300111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNtwhwmd400111Init
	Write-Host "Adding package reference ...InternalInboundERPLNtwhwmd400111Init"
	$package=$project.Packages["InternalInboundERPLNtwhwmd400111Init.dtsx"]
	$package.Parameters["pSource400111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource400111Param");
	$package.Parameters["pTarget400111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget400111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNtticpr160111Init
	Write-Host "Adding package reference ...InternalInboundERPLNtticpr160111Init"
	$package=$project.Packages["InternalInboundERPLNtticpr160111Init.dtsx"]
	$package.Parameters["pSource160111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource160111Param");
	$package.Parameters["pTarget160111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget160111Param");
	$package.Alter()

	#new-object --InternalInboundERPLNttcmcs061100Init
	Write-Host "Adding package reference ...InternalInboundERPLNttcmcs061100Init"
	$package=$project.Packages["InternalInboundERPLNttcmcs061100Init.dtsx"]
	$package.Parameters["pSource061100Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource061100Param");
	$package.Parameters["pTarget061100Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget061100Param");
	$package.Alter()

	#new-object --InternalInboundERPLNttcibd001100Init
	Write-Host "Adding package reference ...InternalInboundERPLNttcibd001100Init"
	$package=$project.Packages["InternalInboundERPLNttcibd001100Init.dtsx"]
	$package.Parameters["pSourceBd001100Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceBd001100Param");
	$package.Parameters["pTargetBd001100Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTargetBd001100Param");
	$package.Alter()

	#new-object --InternalInboundERPLNttcmcs015100Init
	Write-Host "Adding package reference ...InternalInboundERPLNttcmcs015100Init"
	$package=$project.Packages["InternalInboundERPLNttcmcs015100Init.dtsx"]
	$package.Parameters["pSource015100Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource015100Param");
	$package.Parameters["pTarget015100Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget015100Param");
	$package.Alter()

	#new-object --InternalInboundERPLNttcmcs062100Init
	Write-Host "Adding package reference ...InternalInboundERPLNttcmcs062100Init"
	$package=$project.Packages["InternalInboundERPLNttcmcs062100Init.dtsx"]
	$package.Parameters["pSource062100Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource062100Param");
	$package.Parameters["pTarget062100Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget062100Param");
	$package.Alter()

	#new-object --InternalInboundERPLNtttadv140000Init
	Write-Host "Adding package reference ...InternalInboundERPLNtttadv140000Init"
	$package=$project.Packages["InternalInboundERPLNtttadv140000Init.dtsx"]
	$package.Parameters["pSource140000Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource140000Param");
	$package.Parameters["pTarget140000Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget140000Param");
	$package.Alter()

	#new-object --InternalInboundERPLNtttadv401000Init
	Write-Host "Adding package reference ...InternalInboundERPLNtttadv401000Init"
	$package=$project.Packages["InternalInboundERPLNtttadv401000Init.dtsx"]
	$package.Parameters["pSource401000Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSource401000Param");
	$package.Parameters["pTarget401000Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTarget401000Param");
	$package.Alter()


	#new-object --InternalInboundERPLNttibom010111Init
	Write-Host "Adding package reference ...InternalInboundERPLNttibom010111Init"
	$package=$project.Packages["InternalInboundERPLNttibom010111Init.dtsx"]
	$package.Parameters["pSourceBOM010111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eSourceBOM010111Param");
	$package.Parameters["pTargetBOM010111Param"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"eTargetBOM010111Param");
	$package.Alter()


	 #new-object  -- InternalInboundERPLNEDWStagingProductLoadMaster 
	Write-Host "Adding package reference ...InternalInboundERPLNEDWStagingProductLoadMaster"      
    $package =$project.Packages["InternalInboundERPLNEDWStagingProductLoadMaster.dtsx"]       
    #$package.Parameters["pNotificationEmail"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter() 
 }	

catch

{
    $err = $Error[0].Exception ; 
    write-host "--> Deployment Error caught: " $err.Message ; 
    #ExitWithCode 0
}

   
#endregion

