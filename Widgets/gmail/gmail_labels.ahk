WatchGmail:
  if (InitialGmailCheck = 0)
    SetTimer, WatchGmail, 500
  if (InitialGmailCheck < 21)
    InitialGmailCheck++
  GInbox := ""
  GInbox := wbGmail.document.querySelectorAll(".zE")

  if (GInbox != "" && GInbox.length != 0) {
    GuiControl,, Gmail, %A_ScriptDir%\Widgets\gmail\gmailnew.png
    num := GInbox.length
    GuiControl, Move, NumberOfGmails, w12 h12
    GuiControl,, NumberOfGmails, % num
  } else {
    GuiControl,, Gmail, %A_ScriptDir%\Widgets\gmail\gmail.png
    GuiControl, Move, NumberOfGmails, w0 h0
    GuiControl,, NumberOfGmails,
  }
  if (InitialFBCheck = 20)
    SetTimer, WatchGmail, 60000
  if (InitialGmailCheck = 21)
    wbGmail.navigate("http://www.gmail.com")
Return

CheckGmail:
  GuiControl,, Gmail, %A_ScriptDir%\Widgets\gmail\gmail.png
  GuiControl, Move, NumberOfGmails, w0 h0
  GuiControl,, NumberOfGmails,
  Run, C:\Users\chris.stanley\AppData\Local\Vivaldi\Application\vivaldi.exe https://www.gmail.com
Return

QuitGmail:
  wbGmail.quit()
Return