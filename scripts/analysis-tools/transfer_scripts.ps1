# Script Transfer Helper for Kali Linux
# Run this from Windows PowerShell

Write-Host "=============================================="
Write-Host "🚀 SCRIPT TRANSFER TO KALI LINUX"
Write-Host "=============================================="

$kali_ip = "192.168.56.142"  # Your Kali IP
$scripts = @(
    "keylogger_attack.sh",
    "malware_attack.sh", 
    "dos_script.sh",
    "recon_script.sh",
    "exploit_script.sh"
)

Write-Host "Target Kali IP: $kali_ip"
Write-Host "Scripts to transfer: $($scripts -join ', ')"
Write-Host ""

# Method 1: HTTP Server (Recommended)
Write-Host "📡 METHOD 1: HTTP Server Transfer"
Write-Host "1. On this Windows machine, run:"
Write-Host "   python -m http.server 8000"
Write-Host ""
Write-Host "2. On your Kali machine, run these commands:"
Write-Host ""

foreach ($script in $scripts) {
    $windows_ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "*VirtualBox*" | Select-Object -First 1).IPAddress
    if (-not $windows_ip) {
        $windows_ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -match "192.168.56"}).IPAddress
    }
    if (-not $windows_ip) {
        $windows_ip = "192.168.56.1"  # Fallback
    }
    
    Write-Host "   wget http://$windows_ip`:8000/$script"
}

Write-Host ""
Write-Host "3. Make scripts executable on Kali:"
Write-Host "   chmod +x *.sh"
Write-Host ""

# Method 2: Manual Copy-Paste
Write-Host "📋 METHOD 2: Manual Copy-Paste"
Write-Host "If HTTP doesn't work, copy-paste each script content:"
Write-Host ""

foreach ($script in $scripts) {
    if (Test-Path $script) {
        Write-Host "--- Content of $script ---"
        Write-Host "On Kali, create file: nano $script"
        Write-Host "Then paste this content:"
        Write-Host ""
        Write-Host "--- START OF $script ---"
        Get-Content $script | Select-Object -First 10
        Write-Host "... (truncated for display, use full content) ..."
        Write-Host "--- END OF $script ---"
        Write-Host ""
    }
}

# Method 3: Create transfer commands
Write-Host "📤 METHOD 3: Create Individual Transfer Commands"
Write-Host ""

$current_dir = Get-Location
Write-Host "Current directory: $current_dir"
Write-Host ""

Write-Host "Available scripts:"
Get-ChildItem *.sh | ForEach-Object {
    Write-Host "✓ $($_.Name) ($(($_.Length/1KB).ToString('F1')) KB)"
}

Write-Host ""
Write-Host "=============================================="
Write-Host "Choose your preferred method and execute!"
Write-Host "=============================================="
