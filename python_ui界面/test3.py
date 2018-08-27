from __future__ import print_function
from tkinter import *

def calltext(event):
    addtext=text.get(1.0,END).strip()
    print('addtext={}'.format(addtext))
    lable=Label(root,text=addtext,pady=10)
    lable.pack()
    text.delete(1.0,END)

root = Tk()
root.geometry("400x400")

canvas=Canvas(root)
frames1=Frame(canvas)
frames2=Frame(root)
scrollbar=Scrollbar(frames1,orient="vertical",command=canvas.yview)

canvas.configure(yscrollcommand=scrollbar.set)
canvas.pack(side=TOP, fill=BOTH, expand=1)
scrollbar.pack(side=RIGHT,fill=Y)
canvas1=canvas.create_window((0,0),window=frames1,anchor="n")

lable=Label(frames1,text='TEST',height=3,fg='white',bg='black',pady=10)
lable.pack(side=TOP,fill=X)

text=Text(frames2,height=3,bg='white',fg='black')
text.focus_set()
text.pack(side=BOTTOM,fill=X)
frames1.pack(side=TOP,fill=X) #远代码在for循环中设置的TOP
frames2.pack(side=BOTTOM,fill=X)
text.bind("<Return>",calltext)

root.mainloop()