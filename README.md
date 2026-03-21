# PowerShell & CLI Customization [Yes, Windows]
> My personal configs and helper scripts for day-to-day work on windows <

This repository contains my PowerShell profile, yazi configs, other tools' configs, and automated scripts for setting up a fresh Windows environment.
I normally use Alacritty(https://alacritty.org/) on top of windows powershell, so there is alacritty-related staff as well.


## 🛠️ Features
**Microsoft.PowerShell_profile.ps1**: Optimized with helper functions, custom prompts, and performance tweaks.
**File Managers**: Full configuration files for [Yazi](https://github.com/sxyazi/yazi) and [LF](https://github.com/gokcehan/lf).
**Scripts**: One-click installation helpers for my favorite CLI tools (Scoop, Yazi, etc.).
**Some Ricing**: Optimized for **Alacritty** with custom color-switching logic.

## 📂 Repository Structure
`/powershell` --->  Powershell config and powershell scripts. Auto installation is also there.
`/rscripts` --->  Various PS scripts.
`/yazi` --->  Configuration files for the Yazi file manager.
`/lf` --->  Configuration files for the LF file manager.

## 🚀 Show to copy?
# 1. Clone the repository
```powershell
git clone [https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git](https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git)
```
# 2. Run the installme.ps1 script. It will automaticall install scoop, CLI tools, python and copy the powershell profile and all other config files. 
```powershell
cd YOUR_REPO_NAME\powershell
.\installme.ps1
```