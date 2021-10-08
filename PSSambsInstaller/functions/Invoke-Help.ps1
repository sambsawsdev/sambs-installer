function Invoke-Help {
    Process {
        try {
            $logger.debug('Starting.')
            throw "Todo: Method Not Implemented."
            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}
