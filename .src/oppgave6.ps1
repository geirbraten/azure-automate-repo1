[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'

$response = Invoke-WebRequest -Uri $UrlKortstokk

$cards = $response.Content | ConvertFrom-Json

$sum = 0
foreach ($card in $cards) {
   $sum += switch ($card.value)
 {
     'J' { 10 }
     'Q' { 10 }
     'K' { 10 }
     'A' { 11 }
     Default {$card.value}
 }
   }

   
function kortstokkPrint {
    param (
        [Parameter()]
        [Object[]]
        $cards
    )
    #SKRIVER UT KORTSTOKK
    $kortstokk = @()
    foreach ($card in $cards) {
    $kortstokk += ($card.suit[0] + $card.value)
}
    return $kortstokk
}


Write-Host "Kortstokk: $(kortstokkPrint($cards))"
Write-Host "antall kort i kortstokken før man trekker:" $cards.length
Write-Host "Poengsum: $sum"

$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]
Write-Host "antall kort i kortstokken etter jeg har trukket 2 kort:" $cards.length

$magnus = $cards[0..1]
$cards = $cards[2..$cards.length]

Write-Host "antall kort i kortstokken etter Magnus har trukket 2 kort:" $cards.length

Write-Host "meg : $(kortstokkPrint($meg))"
Write-Host "magnus : $(kortstokkPrint($magnus))"
Write-Host "$Kortstokk : $(kortstokkPrint($cards))"