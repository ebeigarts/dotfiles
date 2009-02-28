on run argv
  tell application "System Events" to tell process "Terminal" to keystroke "t" using command down -- open a new tab
  tell application "Terminal" to do script "cd " & item 1 of argv in front window -- change directory
  tell application "Terminal" to do script "clear" in front window -- change directory
end run
