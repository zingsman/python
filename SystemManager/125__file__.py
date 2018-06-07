#/bin/python
import os
print("my home directory:", os.getcwd())
print("my filename:", __file__)
print("my full directory:", os.path.abspath(__file__))
print(__file__)
print(os.path.dirname(__file__))
print(os.path.abspath(os.path.join(os.path.abspath(__file__),os.path.pardir)))
