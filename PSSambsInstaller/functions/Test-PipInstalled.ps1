function Test-PipInstalled {
    Process {
        try {
            $logger.debug('Starting.')

            # Pip is on the path
            if (Get-Command pip -CommandType Application -ErrorAction SilentlyContinue) {
                $logger.debug("Completed. $true")
                return $true
            }

            $logger.debug("Completed. $false")
            return $false
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}