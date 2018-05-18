import os
import mmap
import io



#packages list. 
packages = ['FactPackageOperations','DimsOpsPackage','Costing_FactPackage','Costing_DimPackage']
tableName = r'InboundERPLNEDWSTAGEProductLoad'
#C:\del\legacyPackages
# Point this url to your local file location. 
localfilePathforLegacy = r'C:\del\legacyPackages'

def searchInFile(path,files,packages,tablename): 
    for file in files:
        fileName = str(file.split('.dtsx')[0])
        if fileName in packages:
            if (checkIfExist(fileName,tableName,path) == 1):
                print(fileName + r'.dtsx CONTAINS '+ tablename + r" So This table is in use ")
            else:
                print(fileName + r" doesn't CONTAIN " + tablename + r" So This table is not in use")

#if object  exists
def checkIfExist(f_name,t_name,path):
    f_url = str(path)+"\\"+str(f_name)+'.dtsx'; 
    with open(f_url) as f:
        for line in f:
            l_line = str(line).lower()
            if str(l_line).find(t_name.lower()) == -1: #if it is not exists in this line 
                return 'NaN'
            else:
                return 1;
 
searchInFile(localfilePathforLegacy,os.listdir(localfilePathforLegacy),packages,tableName)







             



