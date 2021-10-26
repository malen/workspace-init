//function Get-FileEncoding($filePath) {  
//    $sr = New-Object System.IO.StreamReader($filePath, (New-Object System.Text.UTF8Encoding $false), $true)
//    [char[]] $buffer = new-object char[] 5
//    $sr.Read($buffer, 0, 5) | Out-Null
//    $encoding = [System.Text.Encoding] $sr.CurrentEncoding
//    $sr.Close()
//    return $encoding
//}

function Get-FileEncoding($filePath)
{
    [byte[]] $byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $filePath

    if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf )
        { $encoding = 'UTF8' }  
    elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff)
        { $encoding = 'BigEndianUnicode' }
    elseif ($byte[0] -eq 0xff -and $byte[1] -eq 0xfe)
         { $encoding = 'Unicode' }
    elseif ($byte[0] -eq 0 -and $byte[1] -eq 0 -and $byte[2] -eq 0xfe -and $byte[3] -eq 0xff)
        { $encoding = 'UTF32' }
    elseif ($byte[0] -eq 0x2b -and $byte[1] -eq 0x2f -and $byte[2] -eq 0x76)
        { $encoding = 'UTF7'}
    else
        { $encoding = 'ASCII' }
    return $encoding
}

Get-ChildItem -Recurse '*.vb' | % {
	$result =  Get-FileEncoding $_
	if ('System.Text.UTF8Encoding' -eq $result) {


		Write-Host $result
		} else {
		Write-Host $result
		}
}