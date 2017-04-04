ComObjError(false)

wbReddit := ComObjCreate("InternetExplorer.Application")
wbReddit.visible := false
wbReddit.navigate("http://www.reddit.com")

InitialRedditCheck := 0
SetTimer, WatchRedditMessages, 2000