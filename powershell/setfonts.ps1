$Path_Symbols = "alacritty\SymbolsNerdFontMono-Regular.ttf"
$Path_Arimo = "alacritty\ArimoNerdFont-Regular.ttf"


function Install-RepoFont {
    Write-Host "*** Installing custom fonts into windows registry***"
    $fontFileName1 = Split-Path -Path $Path_Symbols -Leaf
    $fontFileName2 = Split-Path -Path $Path_Arimo -Leaf

    InstallFont $fontFileName1 $Path_Symbols
    InstallFont $fontFileName2 $Path_Arimo
}

#($fontName, $fontSourcePath){
function InstallFont
{
    param(
        [string]$fontName,
        [string]$fontSourcePath
    )

    $parentDir = Split-Path $pwd
    $srcFontPath = Join-Path $parentDir $myFontPath
    $destination = Join-Path "$env:windir\Fonts" $fontName
    $fontFileName = Split-Path -Path $fontSourcePath -Leaf
    Write-Host "...Installing $fontName..." -ForegroundColor Cyan
    if (!(Test-Path $destination)) {
        Copy-Item -Path $srcFontPath -Destination $destination -Force
    }
    $RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    New-ItemProperty -Path $RegistryPath -Name $fontName -Value $FontFileName -PropertyType String -Force | Out-Null
    Write-Host "Font installed and registered!" -ForegroundColor Green
    Write-Host "Note: You may need to restart PowerShell to see it in the Font menu." -ForegroundColor Yellow

}

function Get-InstalledFonts() 
{
    Write-Host "Auditing Registered Windows Fonts..." -ForegroundColor Cyan
    $RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    $FontFolder = "$env:windir\Fonts"
    $RawFonts = Get-ItemProperty -Path $RegistryPath
    $temp = $RawFonts.PSObject.Properties 
    foreach ($property in $RawFonts.PSObject.Properties) {
        # Skip the internal PowerShell metadata properties
        if ($property.Name -match "PSPath|PSParentPath|PSChildName|PSDrive|PSProvider") {
            continue
        }
        $familyName = $property.GetDetailsOf()
        Write-Host "$($property.Name) -> $($property.Value) -> $($property.)"

    }
    # Write-Host $temp
    return $FontList
}

Get-InstalledFonts
# Install-RepoFont
