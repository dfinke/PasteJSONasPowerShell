function New-PSCustomObject {
        param($tokens)

        $newList = $tokens| ForEach { "`t`t{0} = `${0}" -f $_ }

@"
`t[PSCustomObject]@{
$($newList -join "`r`n")
`t}


"@
    }
