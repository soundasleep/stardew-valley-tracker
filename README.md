# stardew-valley-tracker

A simple Ruby script to track Stardew Valley progress and output the data into a CSV file, ready
for your favourite geeky graphing solution.

## Installation

1. Clone or copy this script into your save game folder e.g. `%APPDATA%\StardewValley\Saves\Farmname_12345`
2. In a console, `ruby track.rb`

### Cloning into a non-empty directory

In your savegame directory:

```
git init
git remote add https://github.com/soundasleep/stardew-valley-tracker origin
git pull origin main
```

## Output

```csv
timestamp,achievements,songsHeard,eventsSeen,cookingRecipes,craftingRecipes,yearForSaveGame,seasonForSaveGame,dayOfMonthForSaveGame,money,totalMoneyEarned,...
2021-08-24 20:33:21 +1200,3,44,16,10,47,1,1,5,93,73757,4824513,33419168,8,6,5,5,5,0,135,135,135,270,36,0,3,3,0,0,91,0,1.5.4,33,713,810,0,62,278,363,146,41,...
...
```

