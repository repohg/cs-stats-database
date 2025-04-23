$ProspectTeams = @(
    'TheAssociates',
    'TeamFlash',
    'BrisketBombers',
    'FriendlyFires',
    'Triggermen',
    'TheWildCards',
    'Wyrms',
    'BlueSentinels',
    'TacticalToads',
    'Rain',
    'SpectralSentries',
    'RowdyRaccoons'
)

$response = Invoke-RestMethod -Uri "$Uri/?list-type=2&prefix='s16/M01'" -Method Get
$response.ListBucketResult
$response.ListBucketResult.Contents
  $response = Invoke-RestMethod -Uri "$Uri/?list-type=2&prefix=s16/M01" -Method Get
  $response.ListBucketResult.Contents
  $response.ListBucketResult.Contents.key
  $response.ListBucketResult.Contents.key | clip
  $matchRegex = 's\d\d-M\d\d-(?<teamA>\w+)-vs-(?<teamB>\w+)-'
  $scrimRegex = '_team_(?<playerA>.*?)_vs_team_(?<playerB>.*?)\.'
  $demos = $response.ListBucketResult.Contents.key

  $demos | % {
     if ($_ -match $matchRegex) {
      if ($Matches.teamA -in $ProspectTeams -or $matches.teamB -in $ProspectTeams) {$_}
     }
     elseif ($_ -match $scrimRegex) {
      if ($Matches.playerA -in $prospectPlayers -or $matches.playerB -in $prospectPlayers) {$_}
     }
     }