on run argv
	
	set argvCount to count of argv
	
	if argvCount = 0 then return "command is empty."
	
	set appname to item 1 of argv
	if argvCount ≥ 2 then
		set command to item 2 of argv
	else
		set command to ""
	end if
	
	if appname = "itunes" then -- iTunes 相关操作
		
		tell application "iTunes"
			if (player state is playing) and (exists current track) then
				set this_title to (get name of current track)
				set this_artist to (get artist of current track)
				if command = "lyric" then -- 获取歌词
					reveal current track
					do shell script "osascript $KITS/FetchLyric/FetchLyric.applescript"
					set this_title to (get name of current track)
					set this_artist to (get artist of current track)
					return "The lyric of '" & this_title & " by " & this_artist & "' will be fetched."
				else if command = "rate" then -- 评级
					if argvCount < 3 then return "missing arguments."
					set rate to item 3 of argv
					if (rate < 0) and (rate > 5) then return "arguments error."
					set rating of current track to rate * 20
					return "The rating of '" & this_title & " by " & this_artist & "' is " & rate & " now."
				end if
			end if
		end tell
		
	end if
	
end run