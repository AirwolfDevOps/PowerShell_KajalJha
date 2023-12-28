# Specify the path to your web server log file
$logFilePath = "C:\PowerShell_Scripts\Logs\apache_access.logs"

# Read the content of the log file
$logContent = Get-Content -Path $logFilePath

# Specify the time period for analysis (adjust as needed)
$startTime = Get-Date "12/Dec/2023 00:00:00"
$endTime = Get-Date "12/Dec/2023 23:59:59"

# Initialize variables
$totalRequests = 0
$accessedUrls = @{}
$responseCodes = @{}


# Process each log entry
foreach ($logEntry in $logContent) {
    if ($logEntry -match '^(\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$') {
        $logDate = [DateTime]::ParseExact($Matches[2], "dd/MMM/yyyy:HH:mm:ss zzz", [System.Globalization.CultureInfo]::InvariantCulture)
        $url = $Matches[3]
        $statusCode = [int]$Matches[4]

        # Check if the log entry is within the specified time period
        if ($logDate -ge $startTime -and $logDate -le $endTime) {
            # Compute total requests
            $totalRequests++

            # Track accessed URLs
            if ($accessedUrls.ContainsKey($url)) {
                $accessedUrls[$url]++
            } else {
                $accessedUrls[$url] = 1
            }

            # Track response codes
            if ($responseCodes.ContainsKey($statusCode)) {
                $responseCodes[$statusCode]++
            } else {
                $responseCodes[$statusCode] = 1
            }
        }
    }
}

# Display results
Write-Host "Total Requests: $totalRequests"
Write-Host "Most Frequently Accessed URLs:" $accessedUrls | Sort-Object Value -Descending | ForEach-Object { Write-Host "$($_.Key): $($_.Value) requests" }
Write-Host "Response Codes:"
$responseCodes.GetEnumerator() | Sort-Object Name | ForEach-Object { Write-Host "$($_.Key): $($_.Value) requests" }
