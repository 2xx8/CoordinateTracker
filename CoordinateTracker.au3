#RequireAdmin ; 添加在脚本首行强制管理员权限[6](@ref)
#include <GUIConstantsEx.au3> ; 引入GUI事件常量定义
#include <WindowsConstants.au3> ; 引入Windows API常量

#Region 主程序初始化
; 设置高DPI感知以确保界面在高分辨率显示器上正常显示
;DllCall("user32.dll", "bool", "SetProcessDpiAwarenessContext", "int", 2)
DllCall("user32.dll", "bool", "SetProcessDPIAware") ; 更稳定的API[8](@ref)

; 启用GUI事件模式
Opt("GUIOnEventMode", 1)

; 全局变量定义
Global $g_bRunning = True
Global $g_hGUI, $g_lblPosition, $g_sldAlpha, $g_chkTopmost

; 创建主窗口
$g_hGUI = GUICreate("pos", 200, 80, -1, -1, $WS_OVERLAPPEDWINDOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")


; 创建坐标显示标签
$g_lblPosition = GUICtrlCreateLabel("X: 0 | Y: 0", 40, 10, 100, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

; 创建控制面板
_CreateControlPanel()
#EndRegion

#Region 控件创建函数
Func _CreateControlPanel()
    ; 透明度调节滑块 - 使用明确的ID引用
    $g_sldAlpha = GUICtrlCreateSlider(10, 40, 100, 25)
    GUICtrlSetLimit($g_sldAlpha, 100, 30) ; 30%到100%透明度
    GUICtrlSetData($g_sldAlpha, 100) ; 初始值
    GUICtrlSetOnEvent($g_sldAlpha, "_UpdateTransparency")
	GUICtrlSetTip(-1, "透明度") ; 添加悬停提示[6](@ref)

    ; 置顶复选框
    $g_chkTopmost = GUICtrlCreateCheckbox("置顶", 120, 40, 40, 25)
    GUICtrlSetOnEvent($g_chkTopmost, "_ToggleTopmost")
	
	; 刷新窗口确保控件状态正常
    GUISetState($GUI_SHOW, $g_hGUI)
EndFunc
#EndRegion

#Region 核心逻辑函数
; 更新鼠标位置显示
Func _UpdatePosition()
    While $g_bRunning
        Local $aPos = MouseGetPos()
        GUICtrlSetData($g_lblPosition, "X: " & $aPos[0] & " | Y: " & $aPos[1])
        Sleep(50) ; 50ms刷新间隔
    WEnd
EndFunc

; 更新窗口透明度
Func _UpdateTransparency()
    Local $iAlpha = GUICtrlRead($g_sldAlpha)
    ConsoleWrite("透明度滑块值: " & $iAlpha & @CRLF) ; 调试输出
    WinSetTrans($g_hGUI, "", $iAlpha * 2.55) ; 转换为0-255范围
EndFunc

; 切换窗口置顶状态
Func _ToggleTopmost()
    Local $bState = (GUICtrlRead($g_chkTopmost) = $GUI_CHECKED)
    WinSetOnTop($g_hGUI, "", $bState)
EndFunc

; 程序退出处理
Func _Exit()
    $g_bRunning = False
    Sleep(100) ; 确保Adlib线程有时间退出
    GUIDelete($g_hGUI)
EndFunc
#EndRegion

#Region 启动程序
; 注册定时更新鼠标位置的函数
AdlibRegister("_UpdatePosition", 50)

; 显示窗口并进入消息循环
GUISetState(@SW_SHOW)

; 主消息循环
While $g_bRunning
    Sleep(10)
    GUIGetMsg()
WEnd

; 清理资源
AdlibUnRegister("_UpdatePosition")
#EndRegion    