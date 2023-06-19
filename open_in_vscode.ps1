param (
    [switch]$Install,
    [switch]$Uninstall
)

$resourcePath = "$env:LOCALAPPDATA\VisualStudioContextIcon"
$command = "`"$env:LocalAppData\Programs\Microsoft VS Code\Code.exe`" `"%V`""
$regPath = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\OpenInVSCode"
$cmdRegPath = "$regPath\command"

if ($Uninstall) {
    # Uninstall
    if (Test-Path -Path $regPath) {
        Remove-Item -Recurse -Force -Path $regPath
        Write-Output "Cleared registry: $regPath"
    }

    if (Test-Path -Path $cmdRegPath) {
        Remove-Item -Recurse -Force -Path $cmdRegPath
        Write-Output "Cleared registry: $cmdRegPath"
    }

    if (Test-Path -Path $resourcePath) {
        Remove-Item -Recurse -Force -Path $resourcePath
        Write-Output "Cleared icon content folder: $resourcePath"
    }

    Write-Output "Uninstalled 'OpenInVSCode' successfully."
}
elseif ($Install) {
    # Install
    # Clear registry
    if (Test-Path -Path $regPath) {
        Remove-Item -Recurse -Force -Path $regPath
        Write-Output "Cleared registry: $regPath"
    }

    if (Test-Path -Path $cmdRegPath) {
        Remove-Item -Recurse -Force -Path $cmdRegPath
        Write-Output "Cleared registry: $cmdRegPath"
    }

    # Clear resource path
    if (Test-Path -Path $resourcePath) {
        Remove-Item -Recurse -Force -Path $resourcePath
        Write-Output "Cleared icon content folder: $resourcePath"
    }

    # Create the resource path directory
    [void](New-Item -Path $resourcePath -ItemType Directory)
    Write-Output "Created resource path directory: $resourcePath"

    # Copy icons to the resource path
    [void](Copy-Item -Path "$PSScriptRoot\*.ico" -Destination $resourcePath)
    Write-Output "Copied icons to: $resourcePath"

    # Create/Open registry key for "OpenInVSCode"
    [void](New-Item -Force -Path $regPath)
    [void](New-Item -Force -Path $cmdRegPath)

    # Set registry values for "OpenInVSCode"
    [void](New-ItemProperty -Path $regPath -Name "(default)" -PropertyType String -Value "Open in Visual Studio Code")
    [void](New-ItemProperty -Path $regPath -Name "Icon" -PropertyType String -Value "$resourcePath\vscode.ico")
    [void](New-ItemProperty -Path $cmdRegPath -Name "(default)" -PropertyType String -Value $command)

    Write-Output "Installed 'OpenInVSCode' successfully."
}
