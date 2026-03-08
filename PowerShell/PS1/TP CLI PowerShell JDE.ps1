cd C:\Users\usertai\Documents
New-Item -Name "backups" -ItemType Directory 
cd .\backups
Copy-Item -Path .\users.txt -Destination autres.txt
Get-ChildItem -Path C:\Users\usertai\Documents
Rename-Item -Path .\autres.txt -NewName lesautres.txt
New-Item -Path "C:\save" -ItemType Directory
Get-ChildItem -Path \
Copy-Item -Path C:\Users\usertai\Documents\backups\*.* -Destination C:\save -Recurse
Get-ChildItem -Path C:\save
cd C:\Users\usertai\Documents
Remove-Item  C:\Users\usertai\Documents\backups -Recurse
Get-ChildItem -Path C:\Users\usertai\Documents


