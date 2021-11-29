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

#####################################################################################################
Write-Host " -------------------------------------------"
Write-Host -BackgroundColor Red "Oppgave 7"

# ...

function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk $kortStokkMagnus) | $(kortstokkTilStreng -kortstokk $kortStokkMagnus)"    
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk $kortStokkMeg  ) | $(kortstokkTilStreng -kortstokk $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if (((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) -and ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack)) {
    skrivUtResultat -vinner "draw" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

#####################################################################################################
Write-Host " -------------------------------------------"
Write-Host -BackgroundColor Red "Oppgave 8"

while ((sumPoengKortstokk -kortstokk $meg) -lt 17) {
    $meg += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Count]

if ((sumPoengKortstokk -kortstokk $meg) -gt $blackjack) {
    skrivUtResultat  -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
}



#####################################################################################################
Write-Host " -------------------------------------------"
Write-Host -BackgroundColor Red "Oppgave 9"

while ((sumPoengKortstokk -kortstokk $magnus) -le (sumPoengKortstokk -kortstokk $meg)) {
    $magnus += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Count]
}

### Magnus taper spillet dersom poengsummen er høyere enn 21
if ((sumPoengKortstokk -kortstokk $magnus) -gt $blackjack) {
  skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}