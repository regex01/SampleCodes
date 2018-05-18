

#rename the existing file names

import os
path = 'C:\del\dtsx'
for dir, subdirs, files in os.walk(path):
    for f in files:
        print(f)
		#f_new = f + 'bak'
        #os.rename(os.path.join(root, f), os.path.join(root, f_new))
		

		
