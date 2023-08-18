# WIK
This is a game that allows multiple players to make bets and dish out punishments each round based on the result of their bet.

## Features
- Node server for managing players and connections via Socket.io
- Flutter client for iOS/Android for players to interact with the game
- HTML/CSS/JS scoreboard client that also functions as game master
- Customizable number of rounds
- Punishment voting after each round of results
- Toggle for half time
- Stores game results and player records in a DB for easy reference
- Customizable wagers for bets/punishments

## Complete
NOTHING

## WIP
- Socket connections
- Player and Server foundation
- RiverPod integration for socket events
- Turn logic
- State management

## TODO
- Customizable wagers
- Game master client
- DB connection
- Half time

## settings.json config
```
"[dart]": {
// Automatically format code on save and during typing of certain characters
// (like `;` and `}`).
"editor.formatOnSave": true,
"editor.formatOnType": true,

// Draw a guide line at 80 characters, where Dart's formatting will wrap code.
"editor.rulers": [80],

// Allows pressing <TAB> to complete snippets such as `for` even when the
// completion list is not visible.
"editor.tabCompletion": "onlySnippets",

// By default, VS Code will populate code completion with words found in the
// current file when a language service does not provide its own completions.
// This results in code completion suggesting words when editing comments and
// strings. This setting will prevent that.
"editor.wordBasedSuggestions": false,
},
```

```
"[typescript]": {
    "editor.formatOnSave": true,
},
```

```
"dart.debugExternalPackageLibraries": true,
"dart.debugSdkLibraries": true,
```
