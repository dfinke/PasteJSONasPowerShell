function Invoke-PasteJSONAsPowerShell {
    
    Clear-Host
    $Error.Clear()    
    try {     

        $text = [System.Windows.Forms.Clipboard]::GetText() | ConvertFrom-Json        
        $psISE.CurrentFile.Editor.InsertText((Invoke-CodeGen $text))
    } catch {
        
        Write-Error $Error[0].Exception
    }    
}