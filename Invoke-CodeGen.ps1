function Invoke-CodeGen ($target) {    

    Invoke-GenerateTree $target Root ($tree=[ordered]@{})

$tree.GetEnumerator()  | %{
@"
function New-$($_.Key) {
$(New-ParamStmt $_.value)
$(New-PSCustomObject $_.value)
}


"@
}
 
}