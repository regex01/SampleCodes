

import os


filepath  =r'\\kansas.us\qfs\IS\Shared\Projects\Cognos\BI-013 - LN EMEA\Development\SSIS Projects\InboundERPLNEDWSTAGEProductLoad'

def listFiles(path):
    for item in os.listdir(path):
        print(item) 


listFiles(filepath)


