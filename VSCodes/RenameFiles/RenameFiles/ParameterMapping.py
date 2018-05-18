
import io 
import string 
import re

def paramMapping(lst,lst2):
    i = 0; 
    for item in lst:
        i_str = str(item)
        i_number = re.findall('\\d+', i_str)
           
        #step1 = this code gives me the top section of powershell which is mapping parrams 
        print('$pSource'+i_number[0]+'Param' + "          " + " = " + '"'+ i_str+'"'+';')
        print('$PTarget'+i_number[0]+'Param' + "          " + " = " + '"'+ i_str+'"'+';')
       

        #step2 = this code gives me the environment mapping                                                                                         

        print("$environment.Variables.Add("+'"'+"eSource"+i_number[0]+'Param'+'"'+','+ " [System.TypeCode]::String,"+ '$pSource'+i_number[0]+'Param'+','+" $false,"+ '"'+ i_number[0] +" Source Param Name"+'"'+");")
        print("$environment.Variables.Add("+'"'+"eTarget"+i_number[0]+'Param'+'"'+','+ " [System.TypeCode]::String,"+ '$pTarget'+i_number[0]+'Param'+','+" $false,"+ '"'+ i_number[0] +" Target Param Name"+'"'+");")
        
        #step3 = this code snipped gives me the package mapping
      
        s_param = 'pSource'+i_number[0]+'Param';
        s_paramt = 'pTarget'+i_number[0]+'Param';
        
        print("#new-object --" + lst2[i])
        print('Write-Host "Adding package reference ...'+lst2[i]+'"')
        print("$$package=$project.Packages["+'"'+lst2[i]+".dtsx"+'"'+']')
        print('$package.Parameters["'+s_param+'"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"e'+s_param+'"'+");")
        print('$package.Parameters["'+s_paramt+'"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"e'+s_paramt+'"'+");")
        print('$package.Alter()')
        print('')
        i = i + 1

 
def paramMappingfromTableList(lst,lst2):
     i = 0; 
     for item in lst:
        i_str = str(item)
        i_number = re.findall('\\d+', i_str)
           
        #step1 = this code gives me the top section of powershell which is mapping parrams 
        print('$pSource'+i_number[0]+'Param' + "          " + " = " + '"'+ lst2[i]+'"'+';')
        print('$PTarget'+i_number[0]+'Param' + "          " + " = " + '"'+ lst2[i]+'"'+';')
       

        #step2 = this code gives me the environment mapping                                                                                         

        print("$environment.Variables.Add("+'"'+"eSource"+i_number[0]+'Param'+'"'+','+ " [System.TypeCode]::String,"+ '$pSource'+i_number[0]+'Param'+','+" $false,"+ '"'+ i_number[0] +" Source Param Name"+'"'+");")
        print("$environment.Variables.Add("+'"'+"eTarget"+i_number[0]+'Param'+'"'+','+ " [System.TypeCode]::String,"+ '$pTarget'+i_number[0]+'Param'+','+" $false,"+ '"'+ i_number[0] +" Target Param Name"+'"'+");")
        
        #step3 = this code snipped gives me the package mapping
      
        s_param = 'pSource'+str(i_number[0])+'Param';
        s_paramt = 'pTarget'+str(i_number[0])+'Param';
        
        print("#new-object --" + lst[i])
        print('Write-Host "Adding package reference ...'+lst[i]+'"')
        print("$package=$project.Packages["+'"'+lst[i]+".dtsx"+'"'+']')
        print('$package.Parameters["'+s_param+'"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"e'+s_param+'"'+");")
        print('$package.Parameters["'+s_paramt+'"].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,"e'+s_paramt+'"'+");")
        print('$package.Alter()')
        print('')
        i = i + 1
    

sourcetable = [
        ' ttcibd100800' 
        ,'ttiipd001800'
        ,'ttdipu001800'
        ,'ttcibd200800'
        ,'tticpr110800'
        ,'ttiedm110800'
        ,'ttibom010800'
        ,'tticpr007800'
        ,'tcprpd100800'
        ,'tticpr300800'
        ,'twhwmd400800'
        ,'tticpr160800'
        ,'ttcmcs061800'
        ,'ttcibd001800'
        ,'ttcmcs015800'
        ,'ttcmcs062800'
        ,'tttadv140000'
        ,'tttadv401000'
        ]        

packagenames = [
        'InternalInboundERPLNttcibd100100Init'
        ,'InternalInboundERPLNttiipd001100Init'
        ,'InternalInboundERPLNttdipu001100Init'
        ,'InternalInboundERPLNttcibd200100Init'
        ,'InternalInboundERPLNtticpr110100Init'
        ,'InternalInboundERPLNttiedm110100Init'
        ,'InternalInboundERPLNttibom010100Init'
        ,'InternalInboundERPLNtticpr007100Init'
        ,'InternalInboundERPLNtcprpd100800Init'
        ,'InternalInboundERPLNtticpr300100Init'
        ,'InternalInboundERPLNtwhwmd400100Init'
        ,'InternalInboundERPLNtticpr160100Init'
        ,'InternalInboundERPLNttcmcs061100Init'
        ,'InternalInboundERPLNttcibd001100Init'
        ,'InternalInboundERPLNttcmcs015100Init'
        ,'InternalInboundERPLNttcmcs062800Init'
        ,'InternalInboundERPLNtttadv140000Init'
        ,'InternalInboundERPLNtttadv401000Init'
            ]
        

#paramMapping(sourcetable,packagenames)
           
#strip out table name from package name 



paramMappingfromTableList(packagenames,sourcetable);














