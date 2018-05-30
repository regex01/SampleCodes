#param([string]$ServerName, [string]$ProjectFilePath)

$ServerName = "USMK-DODSDEV"
#need to Edit this with the main file path 
$ProjectFilePath = "\\Kansas.us\qfs\IS\Shared\Projects\ValueCentric\Development\SSIS Projects\SFTPUtility\SFTPUtility\bin\Development\SFTPUtility.ispac"
                   

$SSISCatalog     = "SSISDB"
$CatalogPwd      = "@909dev1!29db*"
$ProjectName     = "SFTPUtility"
$FolderName      = "Utility"
$EnvironmentName = "SFTPUtility"


#Function to Contol Errors (Error-Handling) while deploying project 
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
                                 
                                $pLocalRemoteUploadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\OutBoundFiles\"
                                $pLocalRemoteDownloadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\InBoundFiles\"
                                $pSFTPRemoteUploadPath = "/Home/quidelsftp/Inbound/"
                                $pSFTPRemoteDownloadPath = "/Home/quidelsftp/Outbound/"
                                $pVCSFTPConnectionString = "b2b.valuecentric.com"
								$NotificationEmail = "darlington.nwemeh@quidel.com"
                                $pVCSFTPUserName = "quidelsftp"
                                $pVCSFTPPassword = "Blue12sky09"; break    

                                               
                           }
                           
            "USMK-DODSQA" 
                           
                           {

                                $pLocalRemoteUploadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\OutBoundFiles\"
                                $pLocalRemoteDownloadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\InBoundFiles\"
                                $pSFTPRemoteUploadPath = "/Home/quidelsftp/Inbound/"
                                $pSFTPRemoteDownloadPath = "/Home/quidelsftp/Outbound/"
                                $pVCSFTPConnectionString = "b2b.valuecentric.com"
								$NotificationEmail = "BISupport@quidel.com"
                                $VCSFTPUserName = "quidelsftp"
                                $VCSFTPPassword = "Blue12sky09"; break      
                                
                           }
                           
           "USMK-DODSPROD" 
           
                           {
                           
                                $pLocalRemoteUploadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\OutBoundFiles\"
                                $pLocalRemoteDownloadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\InBoundFiles\"
                                $pSFTPRemoteUploadPath = "/Home/quidelsftp/Inbound/"
                                $pSFTPRemoteDownloadPath = "/Home/quidelsftp/Outbound/"
                                $pVCSFTPConnectionString = "b2b.valuecentric.com"
								$NotificationEmail = "BISupport@quidel.com"
                                $pVCSFTPUserName = "quidelsftp"
                                $pVCSFTPPassword = "Blue12sky09"; break    
                                
                           }

                  default
                           {     
                                
                                $pLocalRemoteDownloadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\InBoundFiles\"
                                $NotificationEmail = "BISupport@quidel.com" 
                           }
      
       }



$eBLOBTempStoragePath = "";
$eBLOBTempStoragePath = "";
$pLocalRemoteUploadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\OutBoundFiles\";
$pLocalRemoteDownloadPath = "\\kansas.us\qfs\IS\Selective Access\VC Data\VCDataProcessings\InBoundFiles\";
$pSFTPRemoteUploadPath = "/Home/quidelsftp/Inbound/";
$pSFTPRemoteDownloadPath = "/Home/quidelsftp/Outbound/";




#Load Assembly for SQLServer Management Objects (SMO)
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')


$svr = New-Object('Microsoft.SqlServer.Management.Smo.Server')

#region SSIS Setup

    # Load the IntegrationServices Assembly
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
           $cat = new-object $isnamespace".catalog" ($integrationservices,"ssisdb","#password1")            
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
    $environment.Variables.Add("eTargetDatabase", [System.TypeCode]::String, "DODSStaging", $false, "Target Database Name")
    $environment.Variables.Add("eTargetServer", [System.TypeCode]::String, $ServerName, $false, "Target Server Name")
    $environment.Variables.Add("eDebugMode", [System.TypeCode]::Boolean,"TRUE", $false, "SSIS Package Debug Mode")
    $environment.Variables.Add("eSFTPRemoteUploadPath", [System.TypeCode]::String,$pSFTPRemoteUploadPath, $false, "VC File Remote Upload Path")
    $environment.Variables.Add("eSFTPRemoteDownloadPath", [System.TypeCode]::String,$pSFTPRemoteDownloadPath, $false, "VC File Remote Download Path")
    $environment.Variables.Add("eLocalRemoteUploadPath", [System.TypeCode]::String,$pLocalRemoteUploadPath, $false, "Local File Upload Path")
    $environment.Variables.Add("eLocalRemoteDownloadPath", [System.TypeCode]::String,$pLocalRemoteDownloadPath, $false, "Local File Download Path")
    $environment.Variables.Add("eSFTPConnectionString", [System.TypeCode]::String,$pVCSFTPConnectionString, $false, "Value Centric SFTP Connection")
    $environment.Variables.Add("eSFTPDownloadFileIndicator", [System.TypeCode]::Int64,"0", $false, "VC SFTP Download File Indicator for Downloading Files OnDemand")
    $environment.Variables.Add("eSFTPUserName", [System.TypeCode]::String,$pVCSFTPUserName, $false, "Value Centric SFTP UserName")
    $environment.Variables.Add("eSFTPPassword", [System.TypeCode]::String,$pVCSFTPPassword, $true, "Value Centric SFTP Password")
    $environment.Variables.Add("eBLOBTempStoragePath", [System.TypeCode]::String, "", $false, "BLOBTempStoragePath")
    $environment.Variables.Add("eBufferTempStoragePath", [System.TypeCode]::String, "", $false, "BufferTempStoragePath")
    $environment.Alter()


#endregion

#region SFTPUtility Project & Package Level Parameter Mapping
    Write-Host "Adding project reference ..."  
    $project.Parameters["pAuditServer"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eAuditServer")
    $project.Parameters["pAuditDatabase"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eAuditDatabase")
    $project.Parameters["pBLOBTempStoragePath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eBLOBTempStoragePath")
    $project.Parameters["pBufferTempStoragePath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eBufferTempStoragePath")
    $project.Parameters["pTargetDatabase"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eTargetDatabase")
    $project.Parameters["pTargetServer"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eTargetServer")
	$project.Parameters["pDebugMode"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eDebugMode")   
    $project.Parameters["pSFTPRemoteUploadPath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSFTPRemoteUploadPath")
    $project.Parameters["pSFTPRemoteDownloadPath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSFTPRemoteDownloadPath")
    $project.Parameters["pLocalRemoteUploadPath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eLocalRemoteUploadPath")
    $project.Parameters["pLocalRemoteDownloadPath"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eLocalRemoteDownloadPath")
    $project.Parameters["pSFTPUserName"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSFTPUserName")
    $project.Parameters["pSFTPPassword"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSFTPPassword")
    $project.Parameters["pSFTPConnectionString"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSFTPConnectionString")
    $project.Parameters["pSFTPDownloadFileIndicator"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eSFTPDownloadFileIndicator")
    $project.Alter()   
    
    
    
	#new-object  -- SFTPFilesDownloadPackage
	Write-Host "Adding package reference ...SFTPFilesDownloadPackage"      
	$package =$project.Packages["SFTPFilesDownloadPackage.dtsx"]    
    #$package.Parameters["paramSSISOpsNF_To"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter()
    
    
    #new-object  -- SFTPFilesDeletePackage 
	Write-Host "Adding package reference ...SFTPFilesDeletePackage"      
    $package =$project.Packages["SFTPFilesDeletePackage.dtsx"]       
    #$package.Parameters["paramSSISOpsNF_To"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter() 	
    
    
	#new-object  -- SFTPFilesUploadPackage 
	Write-Host "Adding package reference ...SFTPFilesUploadPackage"      
    $package =$project.Packages["SFTPFilesUploadPackage.dtsx"]       
    #$package.Parameters["paramSSISOpsNF_To"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, "eNotificationEmail") 
    $package.Alter() 	
    
    
#endregion

#End Catch
}
catch
{
    $err = $Error[0].Exception ; 
    write-host "--> Deployment Error caught: " $err.Message ; 
    ExitWithCode 1
}
