 #!/bin/bash
 #better to use 5min timeout in codespace setting from github web
 #install gh
 pkg update
 pkg install gh

 #login with gh
 gh auth login

 #get the codespace name if available. 
 gh codespace list

 #create codespace if not available 
 gh codespace create -R apon77/linux 

 #login in codespace
 gh codespace ssh -c solid-space-fortnight-r6qwx9jqg4535g5g 
