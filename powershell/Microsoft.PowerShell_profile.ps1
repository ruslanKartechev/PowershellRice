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
$LOCATION_PS_STAFF = "C:\GitRepos\win_shell_staff\powershell"

#Aliases
Set-Alias -Name 'python3' -Value 'python'
Set-Alias -Name 'python3' -Value 'py'
Set-Alias -Name 'python' -Value 'py'

#Colors
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Cyan"
Clear-Host

# Setings Titles
$host.ui.RawUI.WindowTitle = "Turtle Shell"


#A cool welcome message
function welcome(){
    $ascii_art = @"
    _________________________
   < Welcome Home, Hunter  >
    -------------------------
   @@@                 @@@
  @{"}                 {"}@
 @(.(.)\__         __/(.).)@
@@@) (                 ) (@@@
  ( . )               ( . )
   \  |                \  (    /
    ) }                 ', `-_/_
    //                     '~ \
   /|\                         \
"@
    Write-Host $ascii_art -ForegroundColor Magenta
}

# Custom prompt before every input
function prompt {
    $time = Get-Date -Format "HH:mm"
    Write-Host "[$time]" -NoNewline -ForegroundColor White
    Write-Host " | " -NoNewline -ForegroundColor Yellow
    Write-Host "User: '$env:USERNAME'" -NoNewline -ForegroundColor Gray
    Write-Host " | " -NoNewline -ForegroundColor Yellow
    Write-Host "$(Get-Location)" -NoNewline -ForegroundColor Cyan
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
        "ps_staff" {Set-Location $LOCATION_PS_STAFF}
        "." {
                return 1 
            }
        ".." {
            cd..
            }
        default  
        { 
            $path = Join-Path $pwd $name
            Write-Host "No key for location: '$name'`ncd into '$path'" -ForegroundColor White
            cd $path
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
    $args = @{CommandLine = "`"$alacrittyPath`"  --working-directory `"$loc`""}
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


function copy_ps(){
    $path = (Get-Command -Name powershell.exe).Path
    $stringLength  = ($path.Length)
    if ($stringLength  -eq 0){
        Write-Host "Failed to find path for powershell.exe... Sorry about that."
        return $stringLength
    }
    $loc = Get-Location
    $args = @{CommandLine = "`"$path`"  --working-directory `"$loc`""}
    $result = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments $args
    return $result

}

function reload_ps(){
    $result = copy_ps("")
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
    Write-Host "Attempting to stop all processes for user: $UserName" -ForegroundColor Cyan
    $currentSessionId = (Get-Process -IncludeUserName | Where-Object {$_.UserName -eq "$env:USERDOMAIN\$UserName" -or $_.UserName -eq "$UserName"}).SessionId | Select-Object -First 1
    if (-not $currentSessionId) {
        Write-Error "Could not determine the session ID for user $UserName. Ensure the script is run in an elevated console to use -IncludeUserName or update to PowerShell v4+."
        return
    }
    $userProcesses = Get-Process -IncludeUserName | Where-Object { 
        $_.SessionId -eq $currentSessionId -and 
        $_.ProcessName -ne "explorer" -and # Exclude explorer.exe to prevent immediate shell termination
        !($_.UserName -match "NT AUTHORITY\\SYSTEM|NT AUTHORITY\\LOCAL SERVICE|NT AUTHORITY\\NETWORK SERVICE") # Exclude core system processes
    }
    if ($userProcesses) {
        $userProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Host "All processes for user $UserName in session $currentSessionId have been terminated." -ForegroundColor Green
    }
}


function debug_update_profile(){
    $installPath = Join-Path $pwd "installme.ps1"
    . $installPath
    copy_powershell_profile("")
    reload_alac("")
}

function openme(){
    explorer $pwd
}



# Only add the type if it hasn't been added in this session
if (-not ([System.Management.Automation.PSTypeName]'WinAp').Type) {
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WinAp {
        [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr hWnd);
        [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, IntPtr ProcessId);
        [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")] public static extern bool AttachThreadInput(uint idAttach, uint idAttachTo, bool fAttach);
    }
"@
}

function Invoke-WindowFocus {
    param([IntPtr]$hWnd)
    if ($hWnd -eq [IntPtr]::Zero) 
    { 
        return $false 
    }
    $foregroundHWnd = [WinAp]::GetForegroundWindow()
    $currentThreadId = [WinAp]::GetWindowThreadProcessId($foregroundHWnd, [IntPtr]::Zero)
    $targetThreadId = [WinAp]::GetWindowThreadProcessId($hWnd, [IntPtr]::Zero)
    [WinAp]::AttachThreadInput($currentThreadId, $targetThreadId, $true)
    if ([WinAp]::IsIconic($hWnd)) {
        [WinAp]::ShowWindowAsync($hWnd, 9) # Restore
    }
    [WinAp]::ShowWindowAsync($hWnd, 5) # Show
    $result = [WinAp]::SetForegroundWindow($hWnd)
    [WinAp]::AttachThreadInput($currentThreadId, $targetThreadId, $false)
    return $result
}

function chrome(){
    $chrome = Get-Process chrome -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
    if ($chrome) {
        Invoke-WindowFocus $chrome.MainWindowHandle
    }
    else {
        Write-Host "Chrome is closed. Launching new instance..." -ForegroundColor Yellow
        Start-Process "chrome.exe"
    }
}


welcome
