import tkinter as tk
class Root(tk.Tk):
    def __init__(self):
        super().__init__()
        self.label = tk.Label(self,text="Hello Word!",padx=100,pady=100)
        self.label.pack()
if __name__ == "__main__":
    root=Root()
    root.mainloop()