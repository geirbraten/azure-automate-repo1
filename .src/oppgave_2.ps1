param (
    [Parameter(HelpMessage = "Et navn", Mandatory = $true)]
    [string]
    $Navn
)

# Hva er forskjell mellom '' og "" som begge er streng?
#  There’s only one difference between single and double quotes in PowerShell: Inside double quotes,
# PowerShell looks for the $ character. 
# If it finds it, it assumes that any following characters, up to the next white space, are a variable name. 
# It replaces the variable reference with the variable’s contents.
Write-Host "... $Navn!"
Write-Host '... $navn!'