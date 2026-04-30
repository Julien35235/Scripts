#Recuperation des informations de l'OS
Get-WmiObject Win32_OperatingSystem
Get-WmiObject Win32_OperatingSystem | gm -MemberType Property
Get-WmiObject Win32_OperatingSystem | Select-Object Caption, Version, ServicePackMajorVersion, OSArchitecture, CSName, WindowsDirectory, NumberOfUsers, BootDevice
$OSInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, Version, ServicePackMajorVersion, OSArchitecture, CSName, WindowsDirectory, NumberOfUsers, BootDevic
$OSInfo.OSArchitecture
Get-WmiObject SoftwareLicensingService | Select-Object OA3xOriginalProductKey
Get-WmiObject SoftwareLicensingService -ComputerName FloHypervisor,FloStation