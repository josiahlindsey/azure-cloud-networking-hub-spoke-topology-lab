# test-connectivity.ps1
# Script to test connectivity across Hub and Spoke topology
# Usage: .\test-connectivity.ps1

# Define VMs and their IP addresses
# Modify these values to match your environment
$VMs = @{
    "Hub-VM"    = "10.0.1.4"
    "Spoke1-VM" = "10.1.1.4"
    "Spoke2-VM" = "10.2.1.4"
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Hub and Spoke Connectivity Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failCount = 0

foreach ($vm in $VMs.GetEnumerator()) {
    Write-Host "Testing connectivity to $($vm.Key) ($($vm.Value))..." -ForegroundColor Yellow
    
    $pingResult = Test-Connection -ComputerName $vm.Value -Count 4 -Quiet
    
    if ($pingResult) {
        Write-Host "  [SUCCESS] $($vm.Key) is reachable" -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "  [FAILED] $($vm.Key) is NOT reachable" -ForegroundColor Red
        $failCount++
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Test Complete" -ForegroundColor Cyan
Write-Host "  Successful: $successCount | Failed: $failCount" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
