import tkinter as tk
class Todo(tk.Tk):
    def __init__(self,tasks=None):
        super().__init__()
        if not tasks:
            self.tasks = []
        else:
            self.tasks = tasks
        self.title("To-Do App v1")
        self.geometry("300x400")
        todol = tk.Label(self,text="--- Add Items Here ---",bg="lightgrey",fg="black",pady=10)
        self.tasks.append(todol) #将多个tk对象存到列表中
        for task in self.tasks:
            task.pack(side=tk.TOP,fill=tk.X)
        #下面是创建底部的输入文本框
        self.task_create = tk.Text(self,height=3,bg='white',fg='black')
        self.task_create.pack(side=tk.BOTTOM,fill=tk.X)
        self.task_create.focus_set() #设置窗口打开，光标默认在文本输入框内。
        self.bind("<Return>",self.add_task) #键盘按回车事件发生，就调用后面的函数。
        self.colour_schemes=[{"bg":"lightgrey","fg":"black"},{"bg":"grey","fg":"white"}]
    def add_task(self,event=None):
        task_text = self.task_create.get(1.0,tk.END).strip() # 得到输入框的文本信息,strip()去掉空格
        print(task_text)
        if len(task_text) > 0:
            new_task =tk.Label(self,text=task_text,pady=10)
            _,task_style_choice = divmod(len(self.tasks),2)
            my_scheme_choice = self.colour_schemes[task_style_choice]
            new_task.configure(bg=my_scheme_choice["bg"])
            new_task.configure(fg=my_scheme_choice["fg"])
            new_task.pack(side=tk.TOP,fill=tk.X)
            self.tasks.append(new_task)
        self.task_create.delete(1.0,tk.END)

if __name__ == "__main__":
    todo = Todo()
    todo.mainloop()