#NoEnv
#NoTrayIcon
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
ComObjError(false)
wb := ComObjCreate("InternetExplorer.Application")
wb.visible := false

HalfScreen := A_ScreenWidth / 2
ThirdScreen := A_ScreenWidth / 3
ThirdScreenWidth := (ThirdScreen * 2)-ThirdScreen
ThumbUp := A_ScreenWidth - 160
Replay := A_ScreenWidth - 135
Play := A_ScreenWidth - 110
FF := A_ScreenWidth - 85
ThumbDown := A_ScreenWidth - 60
Stations := A_ScreenWidth - 35

StationGuiOpen := 0

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
Off :=  NumPut( cbAPPBARDATA, APPBARDATA, "Ptr" )
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
  SoundGet, sound
  SoundSet, 0
  GuiControl,, ArtistSong, Loading Stations . . .
  GoSub, GetStationList
  SoundSet, %sound%
  GuiControl,, ArtistSong, Loading Music . . .
  GuiControl,, Current, pandora.png
  GuiControl,, Thumbsup, thumbsup.png
  GuiControl,, Thumbsdown, thumbsdown.png
  GuiControl,, Replay, replay.png
  GuiControl,, PlayPause, pause.png
  GuiControl,, FF, ff.png
  GuiControl,, Stations, stations.png
  wb.navigate("http://pandora.com")
  GoSub, GetSongInfo
  SetTimer, WatchTime, 1000
return

GetStationList:
  global stationList
  wbStation := ComObjCreate("InternetExplorer.Application")
  wbStation.visible := false
  wbStation.navigate("https://www.pandora.com/stations")
  While wbStation.readyState!=4 || wbStation.document.readyState!="complete"
    Sleep 250
  a2z := ""
  While (a2z = "") {
    Sleep 250
    a2z := wbStation.document.querySelectorAll(".SingleToggleButton__button").item(1)
  }
  a2z.click()
  Sleep 2000
  stations := wbStation.document.querySelectorAll(".MyStationsListItem__trackName")
  stationList := []
  loop, % stations.Length
  {
    station := stations[A_Index-1].textContent
    url := StrSplit(stations[A_Index-1].getAttribute("data-reactid"), ".") 
    url := url[9]
    StringTrimLeft, url, url, 3
    stationList.Push({ name : station, url : url }) 
    pause := wbStation.document.querySelector("[data-qa='pause_button']")
    if (pause != "") 
      pause.click()
  }
   
  wbStation.quit
  tabOne := []
  tabTwo := []
  tabThree := []
  tabFour := []
  tabFive := []
  Loop, % stationList.maxIndex()
  {
    station := stationList[A_Index]
    sub := SubStr(station.name, 1, 1)
    if (sub = "0" || sub = "1" || sub = 2 || sub = "3" || sub = "4" || sub = "5" || sub = "6" || sub = "7" || sub = "8" || sub = "9" || sub = "a" || sub = "b" || sub = "c" || sub = "d")
      tabOne.push(station)
    if (sub = "e" || sub = "f" || sub = "g" || sub = "h" || sub = "i")
      tabTwo.push(station)
    if (sub = "j" || sub = "k" || sub = "l" || sub = "m" || sub = "n")
      tabThree.push(station)
    if (sub = "o" || sub = "p" || sub = "q" || sub = "r" || sub = "s")
      tabFour.push(station)
    if (sub = "e" || sub = "t" || sub = "u" || sub = "v" || sub = "w" || sub = "x" || sub = "y" || sub = "z")
      tabFive.push(station)
  }   
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
  global stationName
  global stationUrl
  
  StationGuiOpen := !StationGuiOpen
  
  if (StationGuiOpen)
  {
    GoSub, CloseStations
    return
  }
  
  MenuLoc := A_ScreenWidth - 400
  Gui, Stations:-Caption +AlwaysOnTop
  Gui, Stations:Add, Tab3, x0 y0 w400 h350 , 0 - D|E - I|J - N|O - S|T - Z
  Gui, Stations:Tab, 1
  Loop, % tabOne.maxIndex()
  {
    if (A_Index <= 15) {
      y := A_Index * 20 + 10
      x := 10
    } else if (A_Index > 15 && A_Index < 30) {
      y := (A_Index - 15) * 20 + 10
      x := 200
    } else {
      y := (A_Index - 30) * 20 + 10
      x := 400
    }
    stationName := tabOne[A_Index].name
    stationUrl := tabOne[A_Index].url
    Gui, Stations:Add, Text,x%x% y%y% h20 w190 gGoToStation v%stationUrl%, % stationName
  }
  Gui, Stations:Tab, 2
  Loop, % tabOne.maxIndex()
  {
    if (A_Index <= 15) {
      y := A_Index * 20 + 10
      x := 10
    } else if (A_Index > 15 && A_Index < 30) {
      y := (A_Index - 15) * 20 + 10
      x := 200
    } else {
      y := (A_Index - 30) * 20 + 10
      x := 400
    }
    stationName := tabTwo[A_Index].name
    Gui, Stations:Add, Text,x%x% y%y% h20 w190 gGoToStation, % stationName
  }
  Gui, Stations:Tab, 3
  Loop, % tabOne.maxIndex()
  {
    if (A_Index <= 15) {
      y := A_Index * 20 + 10
      x := 10
    } else if (A_Index > 15 && A_Index < 30) {
      y := (A_Index - 15) * 20 + 10
      x := 200
    } else {
      y := (A_Index - 30) * 20 + 10
      x := 400
    }
    stationName := tabThree[A_Index].name
    Gui, Stations:Add, Text,x%x% y%y% h20 w190, % stationName
  }
  Gui, Stations:Tab, 4
  Loop, % tabOne.maxIndex()
  {
    if (A_Index <= 15) {
      y := A_Index * 20 + 10
      x := 10
    } else if (A_Index > 15 && A_Index < 30) {
      y := (A_Index - 15) * 20 + 10
      x := 200
    } else {
      y := (A_Index - 30) * 20 + 10
      x := 400
    }
    stationName := tabFour[A_Index].name
    Gui, Stations:Add, Text,x%x% y%y% h20 w190, % stationName
  }
  Gui, Stations:Tab, 5
  Loop, % tabOne.maxIndex()
  {
    if (A_Index <= 15) {
      y := A_Index * 20 + 10
      x := 10
    } else if (A_Index > 15 && A_Index < 30) {
      y := (A_Index - 15) * 20 + 10
      x := 200
    } else {
      y := (A_Index - 30) * 20 + 10
      x := 400
    }
    stationName := tabFive[A_Index].name
    Gui, Stations:Add, Text,x%x% y%y% h20 w190, % stationName
  }
  
  Gui, Stations:Show, x%MenuLoc% y37 w400 h350, Stations

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

#up::
Thumbsup:
  wb.document.querySelector("[data-qa='thumbs_up_button']").click()
  thumbsup := ""
  thumbsup := wb.document.querySelector(".ThumbUpButton--active")
  if (thumbsup != "")
    GuiControl,, Thumbsup, thumbsupblue.png
  else
    GuiControl,, Thumbsup, thumbsup.png
return

#down::
Thumbsdown:
  wb.document.querySelector("[data-qa='thumbs_down_button']").click()
  Sleep, 500
  GoSub, GetSongInfo
return

Replay:
  wb.document.querySelector("[data-qa='replay_button']").click()
return

#space::
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

#right::
FF:
  wb.document.querySelector("[data-qa='skip_button']").click()
return 

CloseStations:
  Gui, Stations:Destroy
return

GoToStation:
  MouseGetPos,,,,ClassNN
  ControlGetText, info, %ClassNN%
  Gui, Stations:Destroy
  GuiControl,, ArtistSong, Changing Stations . . .
  GuiControl,, Current, 
  GuiControl,, Thumbsup,
  GuiControl,, Thumbsdown,
  GuiControl,, Replay,
  GuiControl,, PlayPause,
  GuiControl,, FF,
  GuiControl,, Stations,
  url := GetStationUrl(info)
  url := "https://www.pandora.com/station/play/" url
  wb.navigate(url)
  GoSub, GetSongInfo
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

GetStationUrl(name)
{
  val := ""
  Loop, % stationList.maxIndex()
  {
    if (stationList[A_Index].name = name)
    {
      val := stationList[A_Index].url
      break
    }
  }  
  return val
}