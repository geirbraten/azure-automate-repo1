$Url = "http://nav-deckofcards.herokuapp.com/shuffle"
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


$kortstokk = @()

foreach ($card in $cards) {
   # $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
    $kortstokk += ($card.suit[0] + $card.value)

}

Write-Host "Kortstokk: $kortstokk"