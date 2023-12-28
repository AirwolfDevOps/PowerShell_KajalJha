function Calculate-ResponseTime {
    param (
        [string]$logFilePath
    )

    $logFile = Get-Content -Path $logFilePath

    # Initialize variables to store data
    $responseTimes = @()

    foreach ($logEntry in $logFile) {
        # Define the regex pattern to match the log entry
        $regexPattern = '(^\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$'

        if ($logEntry -match $regexPattern) {
            # Extract information from the matched log entry
            $responseCode = $matches[4]

            # Calculate response time for successful requests (status code 200)
            if ($responseCode -eq '200') {
                $responseTime = $matches[5]  
                Write-Host "Response Time: $responseTime"
                $responseTimes += $responseTime
            }
        }
    }

    # Calculate average response time
    $averageResponseTime = if ($responseTimes.Count -gt 0) { ($responseTimes | Measure-Object -Average).Average } else { 0 }
    Write-Host "Average Respone Time: $averageResponseTime"
}

Calculate-ResponseTime -logFilePath "C:\PowerShell_Scripts\Logs\apache_access.logs"