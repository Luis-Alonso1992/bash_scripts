$emailSubject = "Report of Aging AD Server Entries – No Communication in Past 60 Days"
$emailBodyNull = "No objects older than 60 days found"
# Connect to Microsoft Graph using Client Credentials
try {
    Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $Credential -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to Microsoft Graph API. Error: $_"
    return
}
function Send-Email($bodyContent) {
    $params = @{
        message = @{
            subject     = $emailSubject
            body        = @{
                contentType = 'HTML'  # You can use 'Text' if preferred
                content     = $bodyContent  # Email body content
            }
            toRecipients = @($smtpTo | ForEach-Object { @{ emailAddress = @{ address = $_ } } })
        }
    }
    try {
        Send-MgUserMail -UserId 'InfraAlerts@forthepeople.com' -BodyParameter $params -ErrorAction Stop
        Write-Output "Email sent successfully."
    } catch {
        Write-Error "Failed to send email. Error: $_"
    }
}

# Import the Active Directory module (requires RSAT or the AD module installed)
Import-Module ActiveDirectory

# Define the thresholddate – 60 days ago
$inactiveDays = 60
$thresholdDate = (Get-Date).AddDays(-$inactiveDays)

# Retrieve computer objects where the OperatingSystem property suggests they are servers.
# Note: This filter may need adjustment if your environment uses a different naming convention.
$servers = Get-ADComputer -Filter 'OperatingSystem -like "*Server*"' -Properties OperatingSystem, PasswordLastSet

# Filter servers that have a PasswordLastSet value either missing or older than the threshold date.
$inactiveServers = $servers | Where-Object {
    ($_.PasswordLastSet -eq $null) -or ($_.PasswordLastSet -lt $thresholdDate)
}
#Send an email depending on whether inactive servers variable had any data
if ($inactiveServers -eq $null) {
    $formattedBody =  [string]::Format($emailBodyNull)
    Send-Email -bodyContent $formattedBody
}
else {
    $formatedBody = $inactiveServers | Select-Object Name, OperatingSystem, PasswordLastSet | Format-Table -AutoSize
    Send-Email -bodyContent $formattedBody
}