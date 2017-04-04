ComObjError(false)

wbfb := ComObjCreate("InternetExplorer.Application")
wbfb.visible := false
wbfb.navigate("http://www.facebook.com")

InitialFBCheck := 0
SetTimer, WatchFBMessages, 2000