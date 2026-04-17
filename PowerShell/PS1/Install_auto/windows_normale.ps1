$isoPath = "C:\ISO\Windows.iso"

Mount-DiskImage -ImagePath $isoPath
$driveLetter = (Get-DiskImage -ImagePath $isoPath | Get-Volume).DriveLetter + ":"

Start-Process "$driveLetter\setup.exe"