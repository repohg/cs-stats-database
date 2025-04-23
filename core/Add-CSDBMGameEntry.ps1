<#
.SYNOPSIS
    Add an entry to the GAMES table
.DESCRIPTION
    Accpets parameters to insert into the GAMES table for a particular demo
.EXAMPLE
    Add-CSDBMGameEntry -GameId <gameid> -TeamA <teamname> -TeamB <teamname> -Map <de_mapname> -Winner <teamname>
#>

function Add-CSDBMGameEntry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        #Unique id to represent the game
        [String]$GameId,

        [Parameter(Mandatory)]
        [String]$TeamA,

        [Parameter(Mandatory)]
        [String]$TeamB,

        [Parameter(Mandatory)]
        [String]$Map,

        [Parameter]
        [String]$Winner,

        [Parameter]
        [DateTime]$Date,

        [Parameter]
        [Int32]$Season,

        [Parameter]
        [String]$MatchType,

        [Parameter]
        [String]$CSCMatch,

        [Parameter]
        [Int16]$IsCorrupted,

        [Parameter]
        [String]$SourceUrl,

        [Parameter]
        [String]$SourceFilename,

        [Parameter]
        [String]$DemoHash,

        [Parameter]
        [String]$Notes
    )

    Write-Debug "START Add-CSDBMGameEntry"

    #construct the query columns and values
    $columnNames = [System.Collections.Generic.List[String]]@('game_id','team_a','team_b','map')
    $columnValues = [System.Collections.Generic.List[String]]@("'$GameId'", "'$TeamA'","'$TeamB'","'$Map'")

    if ($Winner)         { $columnNames.Add('winner')         ; $columnValues.Add("'$Winner'")                                }
    if ($Date)           { $columnNames.Add('date')           ; $columnValues.Add("'$(Get-Date $Date -Format 'yyyy-MM-dd')'") }
    if ($Season)         { $columnNames.Add('season')         ; $columnValues.Add($Season)                                    }
    if ($MatchType)      { $columnNames.Add('match_type')     ; $columnValues.Add("'$MatchType'")                             }
    if ($CSCMatch)       { $columnNames.Add('csc_id')         ; $columnValues.Add("'$CSCMatch'")                              }
    if ($IsCorrupted)    { $columnNames.Add('is_corrupted')   ; $columnValues.Add($IsCorrupted)                               }
    if ($SourceUrl)      { $columnNames.Add('source_url')     ; $columnValues.Add("'$SourceUrl'")                             }
    if ($SourceFilename) { $columnNames.Add('source_filename'); $columnValues.Add("'$SourceFilename'")                        }
    if ($DemoHash)       { $columnNames.Add('demo_hash')      ; $columnValues.Add("'$DemoHash'")                              }
    if ($Notes)          { $columnNames.Add('notes')          ; $columnValues.Add("'$Notes'")                                 }

    Invoke-CSDBMQuery "INSERT INTO GAMES ($($columnNames -join ',')) VALUES ($($columnValues -join ','));"

    Write-Debug "END Add-CSDBMGameEntry"
}