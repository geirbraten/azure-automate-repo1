[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Url = "http://nav-deckofcards.herokuapp.com/shuffles"
    # i. Ta i mot prarameter
)

$ErrorActionPreference = 'Stop'

# ii. Mer avasert feilhåndtering
try {
    $res = Invoke-WebRequest $Url
}
catch {
    Write-Warning "Kunne ikke hente kortstokk fra url $($url): $($_.Exception.Message)"
    exit 1
}

$cards = $res.Content

if (!(Test-Json $cards -Erroraction 'SilentlyContinue')) {
    Write-Warning "Kan ikke kovertere data fra JSON"
    Write-Debug $cards
    exit 1
}

$cards = $cards | ConvertFrom-Json -Depth 10

$cardsArray = @()
foreach ($card in $cards) {
   # $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
    $cardsArray += "($card.suit[0] + $card.value)"
}

Write-Host "Kortstokk: $cardsArray"