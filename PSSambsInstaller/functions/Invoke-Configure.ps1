function Invoke-Configure {
    Process {
        try {
            $logger.debug('Started.')
            throw "Todo: Method Not Implemented."
            $logger.debug('Completed.')
        } catch {
            $logger.error("Failed: $_")
            throw "$_"
        }
    }
}