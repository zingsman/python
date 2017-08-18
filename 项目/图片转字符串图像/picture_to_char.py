#use python 2.7
#!/usr/bin/python
from PIL import Image
import argparse

# command argument

parser = argparse.ArgumentParser()

parser.add_argument("file",help = "input your picture")
parser.add_argument("-o","--output", help = "if you want,input you result file") 
parser.add_argument("--width",type = int, default = 80)
parser.add_argument("--height", type = int, default = 80)

args = parser.parse_args()

IMG = args.file
WIDTH = args.width
HEIGHT = args.height
OUTPUT = args.output

ascii_char = list("$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,\"^`'. ")

# 256 clocr to 70 charstrings
def get_char(r,g,b,alph = 256):
    if alph == 0:
        return ' '
    length = len(ascii_char)
    gray = int(0.2126 * r + 0.7152 * g + 0.0722 * b)  #why?

    unit = (256.0 + 1)/length
    return ascii_char[int(gray/unit)]
if __name__ == '__main__':

    im = Image.open(IMG)
    im = im.resize((WIDTH,HEIGHT),Image.NEAREST)
    txt = ""
    for i in range(HEIGHT):
        for j in range(WIDTH):
            txt += get_char(*im.getpixel((j,i)))
        txt += '\n'
    print txt
    if OUTPUT:
        with open(OUTPUT,'w') as f:
            f.write(txt)
    else:
        with open("output.txt",'w') as f:
            f.write(txt)
