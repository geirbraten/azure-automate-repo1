[CmdletBinding()]
param (
    #Parameter er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    # når parameter ikke er gitt brukes default verdi
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

#$ErrorActionPreference = 'Stop'
#Feilhåndtering - stop programmet hvis det duker opp noen feil
# Se https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.actionpreference
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

#$response = Invoke-WebRequest -Uri $UrlKortstokk
$webRequest = Invoke-WebRequest -Uri $UrlKortstokk

$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson
function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]
        $kortstokk
    )
    $streng = ''
    foreach ($kort in $kortstokk) {
        $streng = $streng + $($kort.suit[0]) + $($kort.value) + ','
    }
    return $streng
}

Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"
function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += switch ($kort.value) {
            { $_ -cin @('J', 'Q' , 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
    }
    return $poengKortstokk
}

Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

Write-Output "meg:  $(kortstokkTilStreng -kortstokk $meg) "
Write-Output "magnus:  $(kortstokkTilStreng -kortstokk $magnus) "
Write-Output "kortstokk:  $(kortstokkTilStreng -kortstokk $kortstokk) "