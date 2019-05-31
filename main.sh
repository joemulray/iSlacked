#!/bin/bash

EMOJICONFIG="emoji.config"

initapplescript(){
osascript <<EOD
tell application "System Preferences"
    activate
    reveal anchor "keyboardTab" of pane "com.apple.preference.keyboard"
end tell
EOD
}

### Parameter 1: emoji
### Parameter 2: hash
write_keyboard_config(){
emoji=$1
hash=$2
echo $emoji
echo $hash

osascript <<EOD
tell application "System Events" to tell process "System Preferences" to tell window "Keyboard"
	click radio button "Text" of tab group 1
	click UI Element 1 of group 1 of tab group 1
	set the clipboard to "$emoji"
	keystroke "$hash	"
	keystroke "v" using command down
	keystroke return
	delay .2
end tell 

EOD
}

main(){
#prep System Preferences
initapplescript

#read each line add each line to the keyboard preference
while read -r line; do
	emoji=`cut -d "=" -f1 <<< $line`
	hash=`cut -d "=" -f2 <<< $line`
	write_keyboard_config ${emoji} ${hash}
done < "$EMOJICONFIG"

}


main "@"

