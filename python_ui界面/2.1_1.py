from __future__ import print_function
from tkinter import *
root = Tk()
root.geometry("400x400")
lable=Label(root,text='TEST',height=3,fg='white',bg='black')
lable.pack(side=TOP,fill=X)
def calltext(event):
    addtext=text.get(1.0,END).strip()
    print('addtext={}'.format(addtext))
    lable=Label(root,text=addtext,pady=10)
    lable.pack()
    text.delete(1.0,END)

text=Text(root,height=3,bg='white',fg='black')
text.focus_set()
text.pack(side=BOTTOM,fill=X)
text.bind("<Return>",calltext)

root.mainloop()