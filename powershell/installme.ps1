function welcome(){
    $ascii_art = @"
    _________________________
              ,
     __  _.-"` `'-.
    /11\'._ __0_(
    |11|  |'--.__\
    |  L.(   ^_\^
    \ .-' |   _ |
    | |   )\___/
    |  \-'`:._]
    \__/;      '-.
"@
    Write-Host $ascii_art -ForegroundColor Magenta
    Write-Host "Please, wait a bit, installing packages and config files" -ForegroundColor Magenta
}

  $tools = @(
        "yazi", 
        "lf", 
        "fzf", 
        "btop", 
        "fd", 
        "ripgrep",
        "eza",
        "alacritty")


function check_python(){
    Write-Host "*** Checking Python 3 and Pip... ***" -ForegroundColor Cyan
    if (Get-Command python -ErrorAction SilentlyContinue) {
        $version = python --version
        Write-Host "Python is already installed ($version)." -ForegroundColor Green
    }
    else {
        Write-Host "Python not found. Installing via Scoop..." -ForegroundColor Yellow
        scoop install python
    }
    if (Get-Command pip -ErrorAction SilentlyContinue) {
        Write-Host "pip already installed" -ForegroundColor Green
    }
    else {
        Write-Host "pip not found in PATH. Attempting to bootstrap..." -ForegroundColor Yellow
        python -m ensurepip --upgrade
        python -m pip install --upgrade pip
    }
}

function install_packages(){
    $scoopTool = "scoop"
  
    Write-Host "`n"
    Write-Host "*** Installing my CLI tools... ***" -ForegroundColor Cyan
    Write-Host "Will try to install the following packages:"
    $idx = 0
    foreach($package in $tools)
    {
        Write-Host "`t($idx) $package" -ForegroundColor White
        $idx++
    }
    if (Get-Command $scoopTool -ErrorAction SilentlyContinue)
    {
        Write-Host "-=- Already have scoop! -=-" -ForegroundColor Green
    }
    else
    {
        Write-Host "Installing 'Scoop' package manager..." -ForegroundColor Gray
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        irm get.scoop.sh | iex
        scoop bucket add extras
        scoop update
    }

    foreach ($package in $tools) {
        if (Get-Command $package -ErrorAction SilentlyContinue) 
        {
            Write-Host "-=- $package is already installed -=-" -ForegroundColor Green
        }
        else 
        {
            Write-Host "$package not found. Attempting to install $package..." -ForegroundColor Yellow
            scoop install $package
        }
    }
    
    Write-Host "Tools installation completed!" -ForegroundColor Cyan
}

function copy_powershell_profile(){
    Write-Host "`n"
    Write-Host "*** Copying custom profile... ***" -ForegroundColor Cyan

    $myProfile = Join-Path $pwd "Microsoft.PowerShell_profile.ps1"
    $targetPath = $PROFILE
    $TargetDir = Split-Path $targetPath

    # 2. Make target dir if doesn't exist
    if (!(Test-Path $TargetDir)) {
        Write-Host "-> Creating profile directory at:`n$TargetDir" -ForegroundColor White
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }
    # 3. Backup existing profile (if it exists)
    if (Test-Path $targetPath) {
        $BackupPath = $targetPath + ".bak"
        Write-Host "-> Created your profile's backup`n$BackupPath" -ForegroundColor White
        Copy-Item -Path $targetPath -Destination $BackupPath -Force
    }
    # 4. Copying the custom profile into actual $PROFILE path
    if (Test-Path $myProfile) {
        Copy-Item -Path $myProfile -Destination $targetPath -Force
        Write-Host "-> Successfuly installed new powershell Profile.`n->Reload your shell to see changes" -ForegroundColor Green
    } else {
        Write-Host "FAILED to find source profile at:`n'$myProfile'" -ForegroundColor Red
    }
}


function copy_yazi_configs_files(){
    Write-Host "`n"
    Write-Host "*** Copying custom yazi config files... ***" -ForegroundColor Cyan

    $ParentPath = Split-Path -Path $pwd -Parent
    
    $myConfigMain = Join-Path $ParentPath "\yazi\yazi.toml"
    $myConfigTheme = Join-Path $ParentPath "\yazi\theme.toml"
    $myConfigKeymaps = Join-Path $ParentPath "\yazi\keymaps.toml"

    if(!(Test-Path -Path $myConfigMain)){
        Write-Host "-- Failed to find source yazy.toml config in this repo..." -ForegroundColor Red
        return 1
    }
    if(!(Test-Path -Path $myConfigTheme)){
        Write-Host "-- Failed to find source theme.toml config in this repo..." -ForegroundColor Red
        return 1
    }
    if(!(Test-Path -Path $myConfigKeymaps)){
        Write-Host "-- Failed to find source keymaps.toml config in this repo..." -ForegroundColor Red
        return 1
    }

    $path = $env:APPDATA + "\yazi\config"
    if(!(Test-Path -Path $path)){
        New-Item -ItemType Directory -Path $path
    }
    $main = $path + "\yazi.toml"
    $theme = $path + "\theme.toml"
    $keymaps = $path + "\keymaps.toml"
    if(!(Test-Path -Path $main)){
        New-Item -ItemType File -Path $main
        Write-Host "+ Created a new yazi config file:`n'$main'" -ForegroundColor Green
    }
    else{
        Write-Host "+ Yazi Main config exists"
    }
    
    if(!(Test-Path -Path $keymaps)){
        New-Item -ItemType File -Path $keymaps
        Write-Host "+ Created a new yazi config file:`n'$keymaps'" -ForegroundColor Green
    }
    else{
        Write-Host "+ Yazi Keymaps config exists"
    }
    
    if(!(Test-Path -Path $theme)){
        New-Item -ItemType File -Path $theme
        Write-Host "+ Created a new yazi config file:`n'$theme'" -ForegroundColor Green
    }
    else{
        Write-Host "+ Yazi Theme config eixsts"
    }
    Copy-Item -Path $myConfigMain -Destination $main -Force
    Copy-Item -Path $myConfigTheme -Destination $theme -Force
    Copy-Item -Path $myConfigKeymaps -Destination $keymaps -Force
}

function copy_alacrity_configs(){
    $ParentPath = Split-Path -Path $pwd -Parent
    $alacrityPath = Join-Path $env:APPDATA "\alacritty\alacritty.toml"
      if(!(Test-Path -Path $alacrityPath)){
        New-Item -ItemType File -Path $alacrityPath -Force
        Write-Host "+ Created a NEW alacritty config:`n'$alacrityPath'" -ForegroundColor Green
    }
    else{
        Write-Host "+ Alacritty config already exists"
    }
    $myConfig = Join-Path $ParentPath "\alacritty\alacritty.toml"
    Copy-Item -Path $myConfig -Destination $alacrityPath -Force
    Write-Host "+ Copied alacritty configs" -ForegroundColor Green
}


function copy_ls(){

}


welcome
copy_powershell_profile
install_packages
check_python
copy_alacrity_configs
copy_yazi_configs_files
copy_ls
