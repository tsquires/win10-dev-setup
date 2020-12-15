function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

Write-Host "Step 1: Installing choco and boxstarter"
if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host "Installing Chocolatey first..."
    Write-Host "------------------------------------" 
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Installed Chocolatey" -ForegroundColor Green
}
if (Check-Command -cmdname 'Install-BoxstarterPackage') {
    Write-Host "Boxstarter is already installed, skip installation."
}
else {
    Write-Host "Installing Boxstarter..."
    Write-Host "------------------------------------" 
    . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
    Write-Host "Installed Boxstarter" -ForegroundColor Green
}
Write-Host "Finished Step 1"

Write-Host "Step 2: Set up windows options"
Powercfg /Change monitor-timeout-ac 60
Powercfg /Change standby-timeout-ac 0

# Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

choco install IIS-ManagementService -y -source windowsfeatures

Write-Host "Finished Step 2"

Write-Host "Step 3: Installing tools"

$Apps = @(
    #Browsers
    "microsoft-edge",
    "googlechrome",
    "firefox",
    #TODO: chrome beta?
    
    #Communications
    "slack",
    "microsoft-teams.install",
    "zoom",
    
    #Editing
    "notepadplusplus.install",
    
    # Media players and production
    "vlc",
    #"kdenlive", # Supports standalone 
    "obs-studio",
    
    # Network & Debugging
    "fiddler",
    "insomnia-rest-api-client",
    "sysinternals",

    #Scriptings
    "powershell-core",
    
    #Utils
    #screenshot utility?
    #"filezilla",
    #"greenshot"
    "7zip.install"

    #"lightshot.install",
)

foreach ($app in $Apps) {
    cinst $app -y
} 
Write-Host "Finished Step 3: Installing tools" -Foreground green

Write-Host "Step 4a: Installing dev tools"
$devTools = @(
    #Chrome extensions
    editthiscookie-chrome,
    #Editors
    "vscode",
    #visual studio
    #Version control
    "git",
    "sourcetree",
    #.Net
    "dotnetcore-sdk",
    "dotnetfx",
    #NodeJS
    "nvm",
    #"nodejs-lts",
    #No way to specify node versions, do this manually?
    #Database
    "ssms",
    # hosting on cloud
    "azure-cli",
    # TODO: fonts for terminal/vscode/etc.
    "microsoft-windows-terminal"
)
foreach ($devTool in $devTools) {
    cinst $devTool -y
}

Write-Host "Step 4b: Installing VS Code extensions"
$vsCodeExtensions = @(
    #"jebbs.plantuml",
    #"evilz.vscode-reveal",
    #"streetsidesoftware.code-spell-checker",
    #"ms-azuretools.vscode-docker"
)
$vsCodeExtensions | ForEach-Object { code --install-extension $_}
Write-Host "Finished Step 4b: Installed VS Code extensions" -Foreground green
Write-Host "Finished Step 4a: Installed dev tools" -Foreground green

Write-Host "Step 5: git config"
git config --global user.email "tim@example.com"
git config --global user.name "John Doe"
Write-Host "Step 5: Finished git config"

#TODO: dotfiles?
#.gitconfig
#.windows terminal config
#.vscode config
