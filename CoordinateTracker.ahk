#NoEnv
#SingleInstance Force
#Persistent
SetBatchLines, -1
CoordMode, Mouse, Screen

; GUI窗口初始化[3,11](@ref)
Gui, +AlwaysOnTop -Resize +ToolWindow
Gui, Font, s10, Arial
Gui, Add, Text, vCoordText w200 Center, X: 0 | Y: 0

; 控制面板[1,6](@ref)
Gui, Add, Slider, vAlphaSlider gUpdateAlpha Range30-100 x10 w120, 100
Gui, Add, Checkbox, vTopCheck gToggleTopmost x+5, 置顶

; 窗口属性设置
Gui, Show, w200 h70 NoActivate, 坐标追踪器
WinSet, Transparent, 255, 坐标追踪器  ; 初始不透明

; 窗口拖动支持
OnMessage(0x201, "WM_LBUTTONDOWN")

WM_LBUTTONDOWN() {
    PostMessage, 0xA1, 2
}

; 定时器初始化
SetTimer, UpdateCoordinates, 50
Return

UpdateCoordinates:
    MouseGetPos, x, y
    GuiControl,, CoordText, X: %x% | Y: %y%
Return

UpdateAlpha:
    GuiControlGet, alphaVal,, AlphaSlider
    transparency := 255 * (alphaVal/100)
    WinSet, Transparent, %transparency%, 坐标追踪器
Return

ToggleTopmost:
    GuiControlGet, isTop,, TopCheck
    WinSet, AlwaysOnTop, % (isTop ? "On" : "Off"), 坐标追踪器
Return

GuiClose:
    ExitApp
Return
