ComObjError(false)

wbGmail := ComObjCreate("InternetExplorer.Application")
wbGmail.visible := false
wbGmail.navigate("http://www.gmail.com")

InitialGmailCheck := 0
SetTimer, WatchGmail, 2000