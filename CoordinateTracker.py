# 程序打包
# pyinstaller --onefile --windowed --exclude-module numpy --hidden-import tkinter CoordinateTracker.py

import pyautogui
import tkinter as tk
from tkinter import ttk


class CoordinateTracker:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("pos")
        
        # 核心组件
        self.label = tk.Label(self.root, text="X: 0 | Y: 0", font=('Arial', 10))
        self.label.pack(padx=1, pady=5)
        
        # 新增功能面板
        self.create_control_panel()
        
        # 窗口属性初始化
        self.running = True
        self.root.protocol("WM_DELETE_WINDOW", self.on_close)
        self.root.attributes('-alpha', 1.0)  # 默认不透明[1,4](@ref)
        self.root.geometry("200x70")
        self.root.resizable(False, False)

    def create_control_panel(self):
        """创建控制面板"""
        control_frame = ttk.Frame(self.root)
        control_frame.pack(pady=5)
        
        # 透明度调节滑块[2,3](@ref)
        self.alpha_scale = ttk.Scale(
            control_frame,
            from_=0.3, to=1.0,
            orient="horizontal",
            command=self.update_transparency
        )
        self.alpha_scale.set(1.0)
        self.alpha_scale.pack(side=tk.LEFT, padx=1)
        
        # 置顶功能复选框[6,7](@ref)
        self.topmost_var = tk.BooleanVar()
        self.topmost_check = ttk.Checkbutton(
            control_frame,
            text="置顶",
            variable=self.topmost_var,
            command=self.toggle_topmost
        )
        self.topmost_check.pack(side=tk.LEFT)

    def update_transparency(self, value):
        """实时更新窗口透明度"""
        self.root.attributes('-alpha', float(value))  # [1,4](@ref)

    def toggle_topmost(self):
        """切换置顶状态"""
        self.root.attributes('-topmost', self.topmost_var.get())  # [6,7](@ref)

    # 原有坐标更新和关闭方法保持不变...
    # (此处保留原有update_coordinates、on_close、start_monitoring方法)

    def update_coordinates(self):
        if not self.running: 
            return
        x, y = pyautogui.position()
        self.label.config(text=f"X: {x} | Y: {y}")
        self.root.after(50, self.update_coordinates)  # 主线程定时任务

    def on_close(self):
        self.running = False  # 停止更新
        self.root.destroy()   # 销毁窗口

    def start_monitoring(self):
        self.update_coordinates()  # 启动首次更新
        self.root.mainloop()
        
            
if __name__ == "__main__":
    app = CoordinateTracker()
    app.start_monitoring()