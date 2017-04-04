#NoEnv
#NoTrayIcon
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

global trans
global iconLoc
global loadedWidget

IniRead, trans, bar.ini, settings, trans
IniRead, iniWidgetsleft, bar.ini, widgetsleft
widgetListleft := StrSplit(iniWidgetsleft, "`n")

HalfScreen := A_ScreenWidth / 2
ThirdScreen := A_ScreenWidth / 3
ThirdScreenWidth := (ThirdScreen * 2)-ThirdScreen

;;; Widget variables
#Include %A_ScriptDir%\Widgets\pandora\pandora_vars.ahk

;;;  Context Menu
Menu, RClick, Add, Set Transparency, SetTranVal
Menu, RClick, Add
Menu, RClick, Add, Rebuild, Reload
Menu, RClick, Add, Edit, EditScript
Menu, RClick, Add, Exit, QuitScript
Menu, RClick, Add
;;; Widget menu addins will be shown here

;;; Installed Widgets
Loop, % widgetListleft.MaxIndex()
{
  IniRead, widget, bar.ini, widgetsleft, %A_Index%
  IniRead, widgetLabel, bar.ini, widgetLabelsleft, %A_Index%
  Menu, Widgets, Add, % widget, % widgetLabel
  Menu, Widgets, Icon, % widget, %A_ScriptDir%\Widgets\%widget%\%widget%.png
}
Menu, Widgets, Add
Menu, Widgets, Add, Add Widget, AddWidget

;;; Base Gui
Gui, New
Gui -Caption +ToolWindow +AlwaysOnTop +Border +LastFound
hAB := WinExist()
barw := A_ScreenWidth-2
Gui, Color, White
Gui, Font, s8
Gui, Add, Picture, x0 y10 w15 h20 gWidgetMenu, arrow.png
Gui, Add, Picture, x20 y5 w32 h32 vCurrent, 

;;; Widget Gui
#Include %A_ScriptDir%\Widgets\pandora\pandora_gui.ahk

Gui, Show, x0 y0 w%barw%
;Gui, Show, x0 y1000 w%barw%  Put on bottom

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
;Off :=  NumPut(   2, Off+0, "Ptr" )  Put on bottom
GoSub, RegisterAppBar

;;; Set Transparency
GoSub, SetTrans

OnExit, QuitScript
Return

Reload:
  reload
return

EditScript:
  Run, C:\Program Files\AutoHotkey\SciTE\SciTE.exe %A_ScriptFullPath%
return

RegisterAppBar:
  DllCall("Shell32.dll\SHAppBarMessage", UInt,(ABM_NEW:=0x0)     , UInt,&APPBARDATA )
  DllCall("Shell32.dll\SHAppBarMessage", UInt,(ABM_QUERYPOS:=0x2), UInt,&APPBARDATA )
  DllCall("Shell32.dll\SHAppBarMessage", UInt,(ABM_SETPOS:=0x3)  , UInt,&APPBARDATA )
Return

Youtube:
  GuiControl,, Current, youtube.png
  wb.navigate("http://youtube.com")
return

PrimeMusic:
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

WidgetMenu:
  Menu, Widgets, Show, 0, 25
return

ABM_Callback( wParam, LParam, Msg, HWnd ) {
; Not much messages received. When Taskbar settings are
; changed the wParam becomes 1, else it is always 2
}

SetTranVal:
  InputBox, trans, , Set transparency from 150-255,, 245, 135
  if (trans < 100)
    trans = 100
  if (trans > 255)
    trans = 255
  GoSub, SetTrans
return

SetTrans:
    WinSet, Transparent, %trans%, ahk_id %hAB%
return

QuitScript:
  if (loadedWidget != "")
  {
    close := "Quit" loadedWidget
    GoSub, %close%
  }
  GoSub, RemoveAppbar
  ExitApp
Return

AddWidget:
return


#Include %A_ScriptDir%\Widgets\pandora\pandora_labels.ahk