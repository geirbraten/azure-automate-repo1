param (
    [Parameter(HelpMessage = "Et navn", Mandatory = $true)]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"

)

$ErrorActionPreference = 'Stop'

#$Url = "http://nav-deckofcards.herokuapp.com/shuffle"
$response = Invoke-WebRequest -Uri $UrlKortstokk

$cards = $response.content | ConvertFrom-Json
#


$sum = 0


$kortstokk = @()

foreach ($card in $cards) {
   # $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
    $kortstokk += ($card.suit[0] + $card.value)

}


function kortstokkPrint {
    param (
        $cards
    )
    
$kortstokk = @()

}
Write-Host "Kortstokk: $kortstokk"
Write-Host "Poengsum: " $sum