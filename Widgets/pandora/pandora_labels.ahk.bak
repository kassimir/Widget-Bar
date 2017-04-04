ShowIE:
  wbPandora.visible := !wbPandora.visible
  Menu, RClick, Rename, % !wbPandora.visible ? "Hide Pandora" : "Show Pandora", % wbPandora.visible ? "Hide Pandora" : "Show Pandora"
return

Pandora:
  ;; Set Globals
    if (loadedWidget != "")
  {
    close := "Quit" loadedWidget
    GoSub, %close%
  }
  loadedWidget = pandora
  iconLoc = %A_ScriptDir%\Widgets\pandora\images
  
  ;; Set up Menu items
  Menu, RClick, Add, Show IE, ShowIE

  GuiControl,, CurrentLeft, %A_ScriptDir%\Widgets\pandora\pandora.png

  wbPandora := ComObjCreate("InternetExplorer.Application")
  wbPandora.visible := false
  SoundGet, sound
  SoundSet, 0
  GuiControl,, ArtistSong, Loading Stations . . .
  GoSub, GetStationList
  SoundSet, %sound%
  wbPandora.navigate("http://pandora.com")
  GoSub, GetSongInfo
  GuiControl,, ArtistSong, Loading Music . . .
  GuiControl,, Thumbsup, %iconLoc%\thumbsup.png
  GuiControl,, Thumbsdown, %iconLoc%\thumbsdown.png
  GuiControl,, Replay, %iconLoc%\replay.png
  GuiControl,, PlayPause, %iconLoc%\pause.png
  GuiControl,, FF, %iconLoc%\ff.png
  GuiControl,, Stations, %iconLoc%\stations.png
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
    stationUrl := tabTwo[A_Index].url
    Gui, Stations:Add, Text,x%x% y%y% h20 w190 gGoToStation v%stationUrl%, % stationName
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
    Gui, Stations:Add, Text,x%x% y%y% h20 w190 gGoToStation v%stationUrl%, % stationName
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
    stationUrl := tabFour[A_Index].url
    Gui, Stations:Add, Text,x%x% y%y% h20 w190 gGoToStation v%stationUrl%, % stationName
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
    Gui, Stations:Add, Text,x%x% y%y% h20 w190 gGoToStation v%stationUrl%, % stationName
  }
  Gui, Stations:Show, x0 y40 w400 h350, Stations
  Gui, Stations:+LastFound
  WinSet, Transparent, %trans%
return

GetSongInfo:
  While wbPandora.readyState!=4 || wbPandora.document.readyState!="complete"
    sleep 100
  Sleep 1000
  artist := wbPandora.document.querySelector(".nowPlayingTopInfo__current__artistName").textContent
  title := ""
  while (title = "") {
    title := wbPandora.document.querySelectorAll(".Marquee__wrapper__content")[0].textContent
    if (!title) 
      title := wbPandora.document.querySelectorAll(".Marquee__wrapper__content__child")[0].textContent
  }
  album := wbPandora.document.querySelector(".nowPlayingTopInfo__current__albumName").textContent
  remaining := "0:00"
  while (remaining = "0:00") {
    sleep 250
    remaining := wbPandora.document.querySelector("[data-qa='remaining_time']").textContent
  }
  elapsed := wbPandora.document.querySelector("[data-qa='elapsed_time']").textContent
  station := wbPandora.document.querySelector(".StationListItem__title").textContent
  thumbsup := ""
  thumbsup := wbPandora.document.querySelector(".ThumbUpButton--active")
  if (thumbsup != "")
    GuiControl,, Thumbsup, %iconLoc%\thumbsupblue.png
  else
    GuiControl,, Thumbsup, %iconLoc%\thumbsup.png
  GuiControl,, StationInfo, % station
  GuiControl,, AlbumInfo, % album
  GuiControl,, SongTime, % elapsed " / " remaining
  GuiControl,, ArtistSong, % artist " - " title
return

#up::
Thumbsup:
  wbPandora.document.querySelector("[data-qa='thumbs_up_button']").click()
  thumbsup := ""
  thumbsup := wbPandora.document.querySelector(".ThumbUpButton--active")
  if (thumbsup != "")
    GuiControl,, Thumbsup, %iconLoc%\thumbsupblue.png
  else
    GuiControl,, Thumbsup, %iconLoc%\thumbsup.png
return

Thumbsdown:
  wbPandora.document.querySelector("[data-qa='thumbs_down_button']").click()
  Sleep, 500
  GoSub, GetSongInfo
return

Replay:
  wbPandora.document.querySelector("[data-qa='replay_button']").click()
return

#space::
PlayPause:
  Sleep 500
  pp := ""
  pp := wbPandora.document.querySelector("[data-qa='play_button']")
  if (pp != "") {
    GuiControl,, playPause, %iconLoc%\pause.png
    pp.click()
  } else {
    GuiControl,, playPause, %iconLoc%\play.png
    wbPandora.document.querySelector("[data-qa='pause_button']").click()
  }
return

#Right::
FF:
  wbPandora.document.querySelector("[data-qa='skip_button']").click()
return 

CloseStations:
  Gui, Stations:Destroy
return

GoToStation:
  GuiControl,, ArtistSong, Changing Music . . .

  MouseGetPos,,,,ClassNN
  ControlGetText, info, %ClassNN%
  Gui, Stations:Destroy

  url := GetStationUrl(info)
  url := "https://www.pandora.com/station/play/" url
  wbPandora.navigate(url)
  While wbPandora.readyState!=4 || wbPandora.document.readyState!="complete"
    Sleep, 250
  GoSub, GetSongInfo
return

WatchTime:
  StillListeningButton := ""
  PlayButton := ""
  elapsed := wbPandora.document.querySelector("[data-qa='elapsed_time']").textContent
  GuiControl,, SongTime, % elapsed " / " remaining
  GuiControlGet, ArtistSong,,, Text 
  if (elapsed = remaining || elapsed = "0:00" || elapsed = "0:01" || elapsed = "0:02" || ArtistSong = "Loading Music . . .")
    GoSub, GetSongInfo
  StillListeningButton := wbPandora.document.querySelector("[data-qa='keep_listening_button']")
  if (StillListeningButton != "")
    StillListeningButton.click()
  PlayButton = wbPandora.document.querySelector("[data-qa='play_button']")
  if (PlayButton != "")
    PlayButton.click()
return

QuitPandora:
  wbPandora.quit
  Menu, RClick, UseErrorLevel
  Menu, RClick, Delete, % !wbPandora.visible ? "Hide IE" : "Show IE"
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