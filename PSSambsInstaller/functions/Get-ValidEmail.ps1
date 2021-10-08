function Get-ValidEmail {
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$email
    )

    Process {
        try {
            $logger.debug("Starting. [$email]")
            # Set a default value of 'None' for email
            if ([string]::IsNullOrWhiteSpace($email)) {
                $email = 'None'
            }

            [bool]$validEmail = $null
            # Ask user for email until valid
            do {
                $newEmailResponse = Read-Host "Email address [$email]"
                # If user just presses enter then use the existing value
                if (-not [string]::IsNullOrWhiteSpace($newEmailResponse)) {
                    $email = $newEmailResponse
                }

                # Check if the email is valid
                try {
                    $null = [MailAddress]::new($email)
                    $validEmail = $true
                } catch {
                    $logger.warn("'$email' is not a valid email.")
                    $validEmail = $false
                }

            } until ($validEmail)

            $logger.debug("Completed. [$email]")
            return $email
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}