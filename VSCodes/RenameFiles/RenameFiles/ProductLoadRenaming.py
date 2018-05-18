import io 
import os
import sys
import fileinput
import re

#rename variable names in package.
def RenameParamaterNames(tpl_packagename,file_path,replaceword,newword):
    for filename in os.listdir(file_path):
        if(filename.endswith('.dtsx') and filename.split('.')[0] in tpl_packagename):
            with open(os.path.join(file_path,filename)) as f:
                newtext = f.read().replace(replaceword,newword)
            with open(os.path.join(file_path,filename),"w") as f:
                f.write(newtext)
#function to change package names in master package
def RenameMasterPackageNamesInSolution(file_path,tpl_masterpackage,tpl_packagenames):
    for filename in os.listdir(file_path):
        if(filename.endswith('.dtsx')):
            with open(os.path.join(file_path,filename)) as f:
                for line in f:
                    for pck in tpl_packagenames:
                        if pck in line:
                            frst_token = pck.split('00Init')[0]
                            lst_token = pck.split('00Init')[1]
                            lst_token = '11Init'
                            full_token = frst_token+lst_token
                            write_text = f.read().replace(pck,full_token)
            with open(os.path.join(file_path,filename),'w') as f:
                f.write(write_text)
                    
 #create a tuples for old package names
lst_old_package_names = (
        'InternalInboundERPLNttcibd100100Init'
        ,'InternalInboundERPLNttiipd001100Init'
        ,'InternalInboundERPLNttdipu001100Init'
        ,'InternalInboundERPLNttcibd200100Init'
        ,'InternalInboundERPLNtticpr110100Init'                                                             
        ,'InternalInboundERPLNttiedm110100Init'
        ,'InternalInboundERPLNtticpr007100Init'
        ,'InternalInboundERPLNtcprpd100800Init'
        ,'InternalInboundERPLNtticpr300100Init'
        ,'InternalInboundERPLNtwhwmd400100Init'
        ,'InternalInboundERPLNtticpr160100Init'        
        )

lst_package_master_package = (
      'InternalInboundERPLNEDWStagingProductLoadMaster') 

#path for packages before renamed 
filepath =  r'C:\del\ProductDimension\PackagesBeforeRenamed';
masterpackagefilepath = r'C:\del\ProductDimension\MasterPackage';
replaceword  = '100Param'
newword  = '111Param'

#val = RenameParamaterNames(lst_old_package_names,filepath,replaceword,newword);

RenameMasterPackageNamesInSolution(masterpackagefilepath,lst_package_master_package,lst_old_package_names)


 #Obsoluted codes 
 # with open(os.path.join(file_path,filename),'r+') as f:
 #               content = f.read().split("\n")
 #               for line in content:
 #                  if replaceword in line:
 #                       line.replac    e(replaceword,newword) 