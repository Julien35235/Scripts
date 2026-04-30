#Installation de MailKit 
Install-Module -Name "Send-MailKitMessage" -Scope CurrentUser
Import-Module Send-MailKitMessage
Import-Module Send-MailKitMessage

# SMTP: Serveur
$SMTPServer = "smtp.ionos.fr"

# SMTP : Port
$SMTPPort = 587

# SMTP : Expéditeur
$SMTPSender = [MimeKit.MailboxAddress]"expediteur@tssr.local"

# SMTP : Destinataire(s)
$SMTPRecipientList = [MimeKit.InternetAddressList]::new()
$SMTPRecipientList.Add([MimeKit.InternetAddress]"destinataire@domaine.fr")

# SMTP : Identifiants
$SMTPCreds = Get-Credential -UserName "user@tssr.local" -Message "Veuillez saisir le mot de Passe"

# E-mail : objet
$EmailSubject = "E-mail envoyé avec Send-MailKitMessage"

# E-mail : corps
$EmailBody = "<h1>Démo Send-MailKitMessage</h1>"

# Envoyer l'e-mail
Send-MailKitMessage -SMTPServer $SMTPServer -Port $SMTPPort -From $SMTPSender -RecipientList $SMTPRecipientList `
                    -Subject $EmailSubject -HTMLBody $EmailBody -Credential $SMTPCreds -UseSecureConnectionIfAvailable