# Question 1
def shiftLeft(source, k):
    i = 0
    size = len(source)
    while(i < k):
        j = 0
        while(j < size-1):
            source[j] = source[j+1]
            j = j + 1
        source[size-1] = 0
        size = size - 1
        i = i + 1

source = [10,20,30,40,50,60]
shiftLeft(source, 3)
print(source)

# Question 2
def rotateLeft(source, k):
    j = 0
    while(j < k):
        i = 0
        temp = source[0]
        while(i < len(source)-1):
            source[i] = source[i+1]
            i = i + 1
        source[len(source) - 1] = temp

        j = j + 1

source=[10,20,30,40,50,60]
rotateLeft(source,3)
print(source)

# Question 3
def remove(source, size, idx):
    i = idx
    while(i < size):
        source[i] = source[i+1]
        i = i + 1
    source[size - 1] = 0

source=[10,20,30,40,50,0,0]
remove(source,5,2)
print(source)

# Question 4
def removeAll(source, size, element):
    i = 0
    while(i < size):
        if(source[i] == element):
            while(source[i] == element):
                j = i
                while(j < size):
                    source[j] = source[j + 1]
                    j = j + 1
        i = i + 1

source=[10,2,30,2,50,2,2,0,0]
removeAll(source,7,2)
print(source)

# Question 5
def checkBalance(arr):
    l = 0
    r = len(arr) - 1
    lw = arr[0]
    rw = arr[r]
    balanced = "false"
    while(l<r-1):
        if(lw<=rw):
            l = l + 1
            lw += arr[l]
        else:
            r = r - 1
            rw += arr[r]

    if (lw == rw):
        balanced = "true"

    return balanced

inp = [1, 1, 1, 2, 1]
print(checkBalance(inp))

# Question 6
def arraySeries(n):
    arr = [0]*(n*n)
    i = n-1
    value = 1
    k = 0
    while(i >= 0):
        j = 0
        while(j < n):
            # print(i, j, k)
            if(j >= i):
                arr[k] = value
                value = value - 1
            j = j + 1
            k = k + 1
        value = n - i + 1
        i = i - 1
    return arr
    
print(arraySeries(3))

# Question 7
def numLargestBunch(arr):
    num = 0
    count = 0
    max_count = 0
    i = 0
    while(i < len(arr)):
        if(arr[i] == num):
            count = count + 1
        else:
            num = arr[i]
            count = 1
        if(count>max_count):
            max_count = count

        i = i + 1

    return max_count

inp = [1, 2, 2, 3, 4, 4, 4]
print(numLargestBunch(inp))

# Question 8
def repetitionCount(arr):
    max_num = -999999999999999999
    out = False
    i = 0
    while(i < len(arr)):
        if(arr[i] > max_num):
            max_num = arr[i]
        i = i + 1

    arr2 = [0]*(max_num+1)
    
    j = 0
    while(j < len(arr)):
        arr2[arr[j]] += 1
        j = j + 1

    k = 0
    while(k < len(arr2) - 1):
        l = k + 1
        while(l < len(arr2)):
            if( (arr2[l] == arr2[k]) and (arr2[l] > 1) ):
                out = True
            l = l + 1
        k = k + 1

    return out

print(repetitionCount([4,5,6,6,4,3,6,4]))

# Circular Arrays

# Question 1
def checkPalindrome(circ_arr, start, size):
    st = start
    end = start + size - 1 
    lim = 0
    out = True
    if(size%2 == 0):
        lim = size/2
    else:
        lim = (size + 1)/2

    i = 0
    while(i < lim):
        if(circ_arr[st % len(circ_arr)] != circ_arr[end % len(circ_arr)]):
            out = False
            break
        st = st + 1 
        end = end - 1
        i = i + 1    
    
    return out

print(checkPalindrome([20,10,0,0,0,10,20,30], 5, 5))

# Question 2
def intersect(circ_arr_1, start_1, size_1, circ_arr_2, start_2, size_2):
    st1 = start_1
    st2 = start_2
    end1 = start_1 + size_1 - 1
    end2 = start_2 + size_2 - 1
    lin_arr = [0]*size_1
    counter = 0

    i = 0
    while(i < size_1):
        j = 0
        while(j < size_2):
            if( (circ_arr_1[st1 % len(circ_arr_1)] == circ_arr_2[st2 % len(circ_arr_2)]) ):
                lin_arr[counter] = circ_arr_1[st1 % len(circ_arr_1)]
                counter += 1
            j = j + 1
            st2 = st2 + 1
        st1 = st1 + 1
        st2 = start_2
        i = i + 1

    arr = [0]*counter
    i = 0
    while(i < counter):
        arr[i] = lin_arr[i]
        i = i + 1

    return arr    

print(intersect([40,50,0,0,0,10,20,30], 5, 5, [10,20,5,0,0,0,0,0,5,40,15,25], 8, 7))

# Question 3
import random

def musicalChair(names):
    start = 3
    size = 7
    while(size > 1):
        num = random.randint(0, 1)
        if (num == 1):
            idx = (start + size//2) % len(names)
            i = size//2
            while(i<size-1):
                names[idx % len(names)] = names[(idx + 1) % len(names)]
                idx = idx + 1
                i = i + 1      
            names[idx % len(names)] = 0    
            size = size - 1
            
            j = 0
            idx2 = start
            print("Still remaining: ", end="")
            while(j < size):
                if(j != size - 1):
                    print( names[idx2 % len(names)], end=", " )
                else:
                    print( names[idx2 % len(names)] )
                idx2 = idx2 + 1
                j = j + 1
        else:
            k = start + size - 1 
            l = 0
            temp = names[k % len(names)]
            while(l < size-1):
                names[k % len(names)] = names[(k-1) % len(names)]  
                k = k - 1
                l = l + 1
            names[k % len(names)] = temp
    print(f"Winner: {names[start]}")

musicalChair(['A', 'B', 'C', 'D', 'E', 'F', 'G'])