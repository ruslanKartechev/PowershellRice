## PowerShell & CLI Customization [Yes, Windows]
> My personal configs and helper scripts for day-to-day work on windows <

This repository contains my PowerShell profile, yazi configs, other tools' configs, and automated scripts for setting up a fresh Windows environment..<br>
I normally use Alacritty(https://alacritty.org/) on top of windows powershell, so there is alacritty-related staff as well..<br>


## 🛠️ Features
**Microsoft.PowerShell_profile.ps1**: Optimized with helper functions, custom prompts, and performance tweaks..<br>
**File Managers**: Full configuration files for [Yazi](https://github.com/sxyazi/yazi) and [LF](https://github.com/gokcehan/lf)..<br>
**Scripts**: One-click installation helpers for my favorite CLI tools (Scoop, Yazi, etc.).
**Some Powershell \ Alacrity**: A little bit of customization for better terminal experience.<br>

## 📂 Repository Structure
`/powershell` --->  Powershell config and powershell scripts. Auto installation is also there.<br>
`/rscripts` --->  Various PS scripts.<br>
`/yazi` --->  Configuration files for the Yazi file manager..<br>
`/lf` --->  Configuration files for the LF file manager..<br>

## 🚀 Show to copy?
##### 1. Clone the repository
```powershell
git clone [https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git](https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git)
```
##### 2. Run the installme.ps1 script. It will automaticall install scoop, CLI tools, python and copy the powershell profile and all other config files. 
```powershell
cd YOUR_REPO_NAME\powershell
.\installme.ps1
```