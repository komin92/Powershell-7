Function Parse-NetUser {
    foreach ($item in $input) {
        if ($item -eq ""){
            continue
        }
        if ($item -match 'User accounts for') {
            continue
        }
        elseif ($item -match '----') {
            continue
        }
        elseif ($item -match 'The command completed') {
            continue
        }
        $contentArray = @()
        foreach ($line in $item) {
            while ($line.Contains("  ")){
                $line = $line -replace '  ',' '
            }
            $contentArray += $line.Split(' ')
        }
 
        foreach($content in $contentArray) {
            $content = $content -replace '"',''
            if ($content.Length -ne 0) {
                Write-Output $content
            }
        }
    }
}


Function Parse-NetGroupMembers {
    foreach ($item in $input) {
        if ($item -eq ""){
            continue
        }
        elseif ($item -match 'Alias name') {
            continue
        }
        elseif ($item -match 'Comment') {
            continue
        } 
        elseif ($item -match 'Group name') {
            continue
        }
        elseif ($item -match 'Members') {
            continue
        }
        elseif ($item -match '----') {
            continue
        }
        elseif ($item -match 'The command completed') {
            continue
        }
        $contentArray = @()
        foreach ($line in $item) {
            while ($line.Contains("  ")){
                $line = $line -replace '  ',' '
            }
            $contentArray += $line.Split(' ')
        }
 
        foreach($content in $contentArray) {
            $content = $content -replace '"',''
            if ($content.Length -ne 0) {
                Write-Output $content
            }
        }
    }
}


Function Parse-NetGroup {
    foreach ($item in $input) {
        if ($item -eq ""){
            continue
        }
        elseif ($item -match 'Aliases') {
            continue
        }
        elseif ($item -match 'Group Accounts for') {
            continue
        }
        elseif ($item -match '----') {
            continue
        }
        elseif ($item -match 'The command completed') {
            continue
        }
        $group = $item.Trim('*')
        Write-Output $group
    }
}