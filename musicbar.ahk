#NoEnv
#NoTrayIcon
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
ComObjError(false)
;wb := ComObjCreate("InternetExplorer.Application")
;wb.visible := false

HalfScreen := A_ScreenWidth / 2
ThirdScreen := A_ScreenWidth / 3
ThirdScreenWidth := (ThirdScreen * 2)-ThirdScreen
ThumbUp := A_ScreenWidth - 160
Replay := A_ScreenWidth - 135
Play := A_ScreenWidth - 110
FF := A_ScreenWidth - 85
ThumbDown := A_ScreenWidth - 60
Stations := A_ScreenWidth - 35


Menu, RClick, Add, Rebuild, Reload
Menu, RClick, Add, Show IE, ShowIE
Menu, RClick, Add, Exit, QuitScript

Menu, Options, Add, Pandora, Pandora
Menu, Options, Icon, Pandora, pandora.png 
Menu, Options, Add, YouTube, YouTube
Menu, Options, Icon, YouTube, youtube.png
Menu, Options, Add, Amazon, Amazon
Menu, Options, Icon, Amazon, amazon.png

Gui, Margin, 2,2
Gui -Caption +ToolWindow +AlwaysOnTop +Border +LastFound
hAB := WinExist()
barw := A_ScreenWidth - 2
Gui, Color, White
Gui, Font, s8
Gui, Add, Picture, x0 y10 w15 h20 gOptionMenu, arrow.png
Gui, Add, Picture, x20 y5 w32 h32 vCurrent, 
Gui, Add, Text, vSongInfo x72 y0 h25 w550,
Gui, Add, Text, vSongTime x72 y27 h12 w550,
Gui, Font, s18
Gui, Add, Text, Center vArtistSong x%ThirdScreen% y5 w%ThirdScreenWidth%,
Gui, Add, Picture, x%Thumbup% y15 h10 w10 vThumbsup gThumbsup,
Gui, Add, Picture, x%Thumbdown% y17 h10 w10 vThumbsdown gThumbsdown,
Gui, Add, Picture, x%Replay% y16 h10 w10 vReplay gReplay,
Gui, Add, Picture, x%Play% y16 h10 w10 vPlayPause gPlayPause,
Gui, Add, Picture, x%FF% y16 h10 w10 vFF gFF,
Gui, Add, Picture, x%Stations% y16 h10 w10 vStations gChangeStations,
Gui, Show, x0 y0 w%barw%



WinGetPos, GX,GY,GW,GH, ahk_id %hAB%

ABM := DllCall( "RegisterWindowMessage", Str,"AppBarMsg" )
OnMessage( ABM, "ABM_Callback" )
OnMessage( (WM_MOUSEMOVE := 0x200) , "CheckMousePos" )

; APPBARDATA : http://msdn2.microsoft.com/en-us/library/ms538008.aspx
VarSetCapacity( APPBARDATA , (cbAPPBARDATA := A_PtrSize == 8 ? 48 : 36), 0 )
Off :=  NumPut(  cbAPPBARDATA, APPBARDATA, "Ptr" )
Off :=  NumPut( hAB, Off+0, "Ptr" )
Off :=  NumPut( ABM, Off+0, "UInt" )
Off :=  NumPut(   1, Off+0, "UInt" ) 
Off :=  NumPut(  GX, Off+0, "Int" ) 
Off :=  NumPut(  GY, Off+0, "Int" ) 
Off :=  NumPut(  GW, Off+0, "Int" ) 
Off :=  NumPut(  GH, Off+0, "Int" )
Off :=  NumPut(   1, Off+0, "Ptr" )
GoSub, RegisterAppBar


OnExit, QuitScript
Return

Reload:
reload
return

ShowIE:
wb.visible := !wb.visible
Menu, RClick, Rename, % !wb.visible ? "Hide IE" : "Show IE", % wb.visible ? "Hide IE" : "Show IE"
return

RegisterAppBar:
  DllCall("Shell32.dll\SHAppBarMessage", UInt,(ABM_NEW:=0x0)     , UInt,&APPBARDATA )
  DllCall("Shell32.dll\SHAppBarMessage", UInt,(ABM_QUERYPOS:=0x2), UInt,&APPBARDATA )
  DllCall("Shell32.dll\SHAppBarMessage", UInt,(ABM_SETPOS:=0x3)  , UInt,&APPBARDATA )
Return

Pandora:
GuiControl,, Current, pandora.png
GuiControl,, Thumbsup, thumbsup.png
GuiControl,, Thumbsdown, thumbsdown.png
GuiControl,, Replay, replay.png
GuiControl,, PlayPause, pause.png
GuiControl,, FF, ff.png
GuiControl,, Stations, stations.png
GuiControl,, ArtistSong, Loading . . .
GoSub, GetStationList
wb.navigate("http://pandora.com")
GoSub, GetSongInfo
SetTimer, WatchTime, 1000
return

GetStationList:
  wbStation := ComObjCreate("InternetExplorer.Application")
  wbStation.visible := true
  wbStation.navigate("https://www.pandora.com/stations")
  While wbStation.readyState!=4 || wbStation.document.readyState!="complete"
    Sleep 250
  a2z := ""
  While (a2z = "") {
    Sleep 250
    a2z := wbStation.document.querySelectorAll(".SingleToggleButton__button").item(1)
    pause := wbStation.document.querySelector("[data-qa='pause_button']")
  }
  pause.click()
  a2z.click()
  Sleep 2000
  stations := wbStation.document.querySelectorAll(".MyStationsListItem__trackName")
  stationList := []
  loop, % stations.Length
    stationList.Push(stations[A_Index-1].textContent)
  wbStation.quit
  
return

Youtube:
  GuiControl,, Current, youtube.png
  wb.navigate("http://youtube.com")
return

Amazon:
  GuiControl,, Current, amazon.png
  wb.navigate("http://https://music.amazon.com")
return

RemoveAppBar:
  DllCall("Shell32.dll\SHAppBarMessage", UInt,(ABM_REMOVE := 0x1), UInt,&APPBARDATA )
Return


GuiContextMenu:
  Index := SubStr(A_GuiControl,2,3) 
  ToolTip
  Menu, RClick, Show
Return

OptionMenu:
  Menu, Options, Show, 0, 25
return

ABM_Callback( wParam, LParam, Msg, HWnd ) {
; Not much messages received. When Taskbar settings are
; changed the wParam becomes 1, else it is always 2
}

ChangeStations:
MenuLoc := A_ScreenWidth - 150
Loop, % stationList.maxIndex()
  Gui, Stations:Add, Button, w150, % stationList[A_Index]
Gui, Stations:Show, x%MenuLoc% y37
return

GetSongInfo:
While wb.readyState!=4 || wb.document.readyState!="complete"
  sleep 100
Sleep 1000
artist := wb.document.querySelector(".nowPlayingTopInfo__current__artistName").textContent
title := ""
while (title = "") {
  title := wb.document.querySelectorAll(".Marquee__wrapper__content")[0].textContent
  if (!title) 
    title := wb.document.querySelectorAll(".Marquee__wrapper__content__child")[0].textContent
}
album := wb.document.querySelector(".nowPlayingTopInfo__current__albumName").textContent
remaining := "0:00"
while (remaining = "0:00") {
  sleep 250
  remaining := wb.document.querySelector("[data-qa='remaining_time']").textContent
}
elapsed := wb.document.querySelector("[data-qa='elapsed_time']").textContent
station := wb.document.querySelector(".StationListItem__title").textContent
thumbsup := ""
thumbsup := wb.document.querySelector(".ThumbUpButton--active")
if (thumbsup != "")
  GuiControl,, Thumbsup, thumbsupblue.png
else
  GuiControl,, Thumbsup, thumbsup.png
GuiControl,, SongInfo, % station "`n" album
GuiControl,, SongTime, % elapsed " / " remaining
GuiControl,, ArtistSong, % artist " - " title
return

Thumbsup:
wb.document.querySelector("[data-qa='thumbs_up_button']").click()
thumbsup := ""
thumbsup := wb.document.querySelector(".ThumbUpButton--active")
if (thumbsup != "")
  GuiControl,, Thumbsup, thumbsupblue.png
else
  GuiControl,, Thumbsup, thumbsup.png
return

Thumbsdown:
wb.document.querySelector("[data-qa='thumbs_down_button']").click()
Sleep, 500
GoSub, GetSongInfo
return

Replay:
wb.document.querySelector("[data-qa='replay_button']").click()
return

PlayPause:
Sleep 500
pp := ""
pp := wb.document.querySelector("[data-qa='play_button']")
if (pp != "") {
  GuiControl,, playPause, pause.png
  pp.click()
} else {
  GuiControl,, playPause, play.png
  wb.document.querySelector("[data-qa='pause_button']").click()
}
return

FF:
wb.document.querySelector("[data-qa='skip_button']").click()
return 

WatchTime:
elapsed := wb.document.querySelector("[data-qa='elapsed_time']").textContent
GuiControl,, SongTime, % elapsed " / " remaining
if (elapsed = remaining || elapsed = "0:00" || elapsed = "0:01" || elapsed = "0:02")
  GoSub, GetSongInfo
return

QuitScript:
  wb.quit
  GoSub, RemoveAppbar
  ExitApp
Return