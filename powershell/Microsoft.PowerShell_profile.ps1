#Defined Locations to jump to
$LOCATION_DESKTOP = "C:\users\$env:USERNAME\OneDrive\Desktop"
$LOCATION_DOCUMENTS = "C:\users\$env:USERNAME\OneDrive\Documents"
$LOCATION_DOWNLOADS = "C:\users\$env:USERNAME\Downloads"
$LOCATION_APP_DATA = "C:\users\$env:USERNAME\AppData"
$LOCATION_APP_DATA_LOCAL = "C:\users\$env:USERNAME\AppData\local"
$LOCATION_APP_DATA_ROAMING = "C:\users\$env:USERNAME\AppData\roaming"


$LOCATION_UNITY_PROJECTS = "C:\MyUnityWork\Projects"
$LOCATION_GIT_REPOS = "C:\GitRepos"
$LOCATION_C_PROJECTS = "C:\GitRepos\c_projects\"
$LOCATION_RENDERER = "C:\GitRepos\c_projects\renderer"


#Colors
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Cyan"
Clear-Host

# Setings Titles
$host.ui.RawUI.WindowTitle = "[Custom] Powershell Window"

# Custom prompt before every input
function prompt {
    $time = Get-Date -Format "HH:mm"
    Write-Host "[$time] " -NoNewline -ForegroundColor Gray
    Write-Host "User:" -NoNewline -ForegroundColor Green
    Write-Host " '$env:USERNAME' " -NoNewline -ForegroundColor Green
    Write-Host " $(Get-Location)" -NoNewline -ForegroundColor Cyan
    return "`n>"
}


# Custom Functions



function goto_or_make($name){
    if(!(Test-Path -Path $name)){
        New-Item -ItemType Directory -Path $name
    }
    Set-Location $name
}


function goto ($name) {
    switch ($name) {
        "desktop"   { Set-Location($LOCATION_DESKTOP)}
        "downloads" { Set-Location($LOCATION_DOWNLOADS) }
        "docs"  { Set-Location($LOCATION_DOCUMENTS) }
        "appdata" {Set-Location $LOCATION_APP_DATA}
        "appdata_roaming" {Set-Location $LOCATION_APP_DATA_ROAMING}
        "appdata_local" {Set-Location $LOCATION_APP_DATA_LOCAL}
        
        "unitywork"  { goto_or_make($LOCATION_UNITY_PROJECTS) }
        "cwork"  { goto_or_make($LOCATION_C_PROJECTS) }
        "c_rend" {goto_or_make($LOCATION_RENDERER)}
        "repos" {goto_or_make($LOCATION_GIT_REPOS)}
        "." {
                return 1 
            }
        ".." {
            cd..
            }
        default  
        { 
            Write-Host "Unknown location: $name" -ForegroundColor Red 
            goto $name
        }
    }
}


function copy_alac(){
    $alacrittyPath = (Get-Command -Name alacritty.exe).Path
    $stringLength  = ($alacrittyPath.Length)
    if ($stringLength  -eq 0){
        Write-Host "Failed to find path for alacrity.exe... Sorry about that."
        return $stringLength
    }
    $loc = Get-Location
    $args = @{
        CommandLine = "`"$alacrittyPath`"  --working-directory `"$loc`""
    }
    $result = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments $args
    return $result
}


function reload_alac(){
     $result = copy_alac("")
    if($result.ReturnValue -eq 0)
    {
        Start-Sleep -Milliseconds 20
        $procObj = Get-Process -Id $result.ProcessId -ErrorAction SilentlyContinue
        if ($procObj) {
            $wshell = New-Object -ComObject WScript.Shell
            $wshell.AppActivate($result.ProcessId)
        }
        else{
            Write-Host "Failed to get process of the new app instance. Can't focus."
        }
        exit
    }
    else
    {
        Write-Host "Failed to create a new app process..."
    }
}



function refreshme(){
    . $PROFILE
    Clear-Host
    Write-Host "Soft reloaded the profile from '$PROFILE'"    
}





function killeveryone ($name) {
    Write-Host "Killing Every proces. Last Words: $name"
    
}

