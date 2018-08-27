a=[3,6,9,5,22,17,27,26,20,7,1,10,25,51,14,17,0,11]
print(a)
print(len(a))
for i in range(len(a)):
    for j in range(i):
        if a[i] > a[j]:
            a[j],a[i] = a[i],a[j]

print(a)