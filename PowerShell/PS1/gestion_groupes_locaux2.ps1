#Creation d'un nouveau groupe local et d'un user de test
New-LocalGroup -Name "TestGroup" -Description "Groupe de test"
#Ajouter l’utilisateur TestUser à ce groupe
Add-LocalGroupMember -Group "TestGroup" -Member "TestUser"
#Verification de la création du groupe TestGroup
Get-LocalGroupMember -Group "TestGroup"
Get-LocalUser -Name "TestUser" | Select-Object -ExpandProperty PrincipalSource
net localgroup TestGroup