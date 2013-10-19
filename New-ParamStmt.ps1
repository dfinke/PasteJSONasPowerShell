function New-ParamStmt {
        param($tokens)
        
        $newList = $tokens| ForEach {"`t`t`${0}" -f $_}
@"
`tparam(
$($newList -join ",`r`n")
`t)


"@
    }
