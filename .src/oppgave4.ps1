[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Et navn", Mandatory = $true)]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"

)

$ErrorActionPreference = 'Stop'

#$Url = "http://nav-deckofcards.herokuapp.com/shuffle"
$response= Invoke-WebRequest -Uri $UrlKortstokk

$cards = $response.content | ConvertFrom-Json
#$cards.GetType()
#$cards[0].suit

$kortstokk = @()

foreach ($card in $cards) {
   # $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
    $kortstokk += ($card.suit[0] + $card.value)

}

Write-Host "Kortstokk: $kortstokk"