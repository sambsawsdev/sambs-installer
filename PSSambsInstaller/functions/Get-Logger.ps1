enum LoggingLevel {
    Off = 0
    Debug = 1
    Info = 2
    Warn = 3
    Error = 4
}

class Logger {
    [LoggingLevel]$loggingLevel
    
    Logger([LoggingLevel]$loggingLevel) {
        $this.loggingLevel = $loggingLevel
    }
    
    [void] hidden log([LoggingLevel]$level, [string]$message, [string]$caller) {
        try {
            # Logging is switched off or at lower level
            if ( ($this.loggingLevel -ile 0) -or ($this.loggingLevel -gt $level) ) {
                return
            }

            # Format the message
            [string]$formattedMessage = "$(Get-Date -UFormat '%Y/%m/%d %T' ) [$caller] -$($level.ToString().ToUpper())-: $message"
            # Output the message
            Write-Host $formattedMessage -ForegroundColor $this.getColour($level)
        } catch {
            throw "Logger.log Failed: $_"
        }
    }

    [string] hidden getColour([LoggingLevel]$level) {
        switch ($level) {
            'Debug' { return 'Green' }
            'Warn' { return 'Yellow' }
            'Error' { return 'Red' }
        }

        return 'White'
    }

    #region Logging methods
    [void] debug([string]$message) {
        $this.log('Debug', $message, (Get-PSCallStack)[1].Command)
    }
    [void] info([string]$message) {
        $this.log('Info', $message, (Get-PSCallStack)[1].Command)
    }
    [void] warn([string]$message) {
        $this.log('Warn', $message, (Get-PSCallStack)[1].Command)
    }
    [void] error([string]$message) {
        $this.log('Error', $message, (Get-PSCallStack)[1].Command)
    }
    #endregion Logging methods
}

function Get-Logger {
    [OutputType([Logger])]
    Param (
        [Parameter(Mandatory=$false, Position=0)]
        [LoggingLevel]$loggingLevel = 'Info'
    )
    
    Process {
        try {
            # Create the logger
            [Logger]$logger = [Logger]::new($loggingLevel)
            
            $logger.debug("Created new logger.")
            return $logger
        } catch {
            throw "Get-Logger Failed: $_"
        }
    }
}