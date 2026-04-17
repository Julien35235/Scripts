Get-WmiObject -Class Win32_LogicalDisk | 
    Select-Object -Property DeviceID, VolumeName, @{
       label='FreeSpace'
       expression={($_.FreeSpace/1GB).ToString('F2')}
    }