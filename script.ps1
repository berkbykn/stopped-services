# Email Parameters
$smtpServer = ""
$smtpPort = 587
$smtpEmail = ""
$smtpPass = ""
$Emailto = ""
$Emailfrom = ""

# Server Name for Email Subject and Logs
$serverName = $env:COMPUTERNAME
$subject = "Stopped Service Detected on $serverName"

# Path of the Log File
$logFile = "C:\Logs\StoppedServiceMonitor.log"

# Not Monitored Services
$allowedStoppedServices = @(
  "AeLookupSvc",
  "BcastDVRUserService",
  "KeyIso",
  "EventSystem"
)

# Monitored Critical Services
$criticalServices = @(
  "NTDS", "kdc", "IsmServ", "DNS", "Netlogon",
  "W32Time", "DFSR", "RPCSS", "LanmanServer",
  "LanmanWorkstation", "lmhosts", "EventLog"
)

# Retrieve Stopped Services
$stoppedServices = Get-Service | Where-Object {
  $_.Status -eq 'Stopped' -and
  ($allowedStoppedServices -notcontains $_.Name)
}

# Parse Critical Services from Stopped
$stoppedCriticalServices = $stoppedServices | Where-Object {
  $criticalServices -contains $_.Name
}

# Parse Non-critical Services from Stopped
$stoppedNonCriticalServices = $stoppedServices | Where-Object {
  $criticalServices -notcontains $_.Name
}

# Condition to Run For Stopped Services
if ($stoppedServices.Count -gt 0) {
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $body = "[$timestamp] Service Status Alert from $serverName`n`n"

  if ($stoppedCriticalServices.Count -gt 0) {
      $body += "**!! CRITICAL SERVICES STOPPED:**`n !!"
      $body += ($stoppedCriticalServices | Select-Object DisplayName, Name, Status | Format-Table | Out-String)
      $body += "`n"
    }

  if ($stoppedNonCriticalServices.Count -gt 0) {
      $body += "[Warning!] Unexpected Non-Critical Stopped Services:`n"
      $body += ($stoppedNonCriticalServices | Select-Object DisplayName, Name, Status | Format-Table | Out-String)
      $body += "`n"
    }

  # Local Log File
  Add-Content -Path $logFile -Value $body

  # Email Sender
  $smtp = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
  $smtp.EnableSsl = $true
  $smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass)

  $mailMessage = New-Object System.Net.Mail.MailMessage
  $mailMessage.From = $from
  $mailMessage.To.Add($to)
  $mailMessage.Subject = $subject
  $mailMessage.Body = $body

  $smtp.Send($mailMessage)

  Write-Output "[$timestamp] Email Alert Sent for Stopped Services on $serverName."}

# Condition for No Stopped Services
else {
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $logEntry = "[$timestamp] No unexpectedly stopped services detected on $serverName.`n"
  Add-Content -Path $logFile -Value $logEntry
  Write-Output $logEntry
}
