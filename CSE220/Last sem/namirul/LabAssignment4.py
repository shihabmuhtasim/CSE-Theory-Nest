class ArrayStack:
    def __init__(self, exp):
        self.arr = [0]*len(exp)
        self.index = 0

    def push(self, element):
        self.arr[self.index] = element
        self.index = self.index + 1


    def pop(self):
        if(self.index == 0):
            return -1
        else:
            value = self.arr[self.index - 1]
            self.arr[self.index - 1] = 0
            self.index = self.index - 1
            return value

    def peek(self):
        return self.arr[self.index-1]

def checkExpression(exp):
    newStack = ArrayStack(exp)
    recordStack = ArrayStack(exp)
    correct = True
    openCount1 = 0
    openCount2 = 0
    openCount3 = 0
    for i in range(0, len(exp), 1):
        if(exp[i] == '(' or exp[i] == '[' or exp[i] == '{'):
            newStack.push(exp[i])
            recordStack.push(i)
            if(exp[i] == '('):
                openCount1 += 1
            elif(exp[i] == '{'):
                openCount2 += 1
            elif(exp[i] == '['):
                openCount3 += 1
            
        elif(exp[i] == ')' or exp[i] == ']' or exp[i] == '}'):

            result = newStack.pop()
            if((result == -1) or (openCount1 == 0 and exp[i] == ')') or (openCount2 == 0 and exp[i] == '}') or (openCount3 == 0 and exp[i] == ']') ):
                print("This expression is NOT correct.")
                correct = False
                if(openCount1 == 0 and exp[i] == ')'):
                    print(f'Error at character # {i + 1}. "{exp[i]}"- not opened.')
                elif(openCount2 == 0 and exp[i] == '}'):
                    print(f'Error at character # {i + 1}. "{exp[i]}"- not opened.')
                elif(openCount3 == 0 and exp[i] == ']'):
                    print(f'Error at character # {i + 1}. "{exp[i]}"- not opened.')
                break

            elif((exp[i] == ')' and result != '(') or (exp[i] == '}' and result != '{') or (exp[i] == ']' and result != '[')):
                print("This expression is NOT correct.")
                correct = False
                print(f'Error at character # {recordStack.pop() + 1}. {result}- not closed.')
                break
            recordStack.pop()

    if(correct == True):
        print("This expression is correct.")

exp = '1+2]*[3*3+{4-5(6(7/8/9)+10)-11+(12*8)]+14'
checkExpression(exp)

class Node:
    def __init__(self, data, nextNode):
        self.data = data
        self.next = nextNode

class LinkedListStack:
    def __init__(self, exp):
        self.head = None

    def push(self, element):
        newNode = Node(element, None)
        newNode.next = self.head
        self.head = newNode

    def pop(self):
        if(self.head == None):
            return -1
        else:
            value = self.head.data
            newHead = self.head.next
            self.head.data = None
            self.head.next = None
            self.head = newHead
            return value

    def peek(self):
        return self.head

def checkExpressionList(exp):
    newStack = LinkedListStack(exp)
    correct = True
    openCount1 = 0
    openCount2 = 0
    openCount3 = 0
    indexStack = LinkedListStack(exp)

    for i in range(0, len(exp), 1):
        if(exp[i] == '(' or exp[i] == '[' or exp[i] == '{'):
            newStack.push(exp[i])
            indexStack.push(i)
            if(exp[i] == '('):
                openCount1 += 1
            elif(exp[i] == '{'):
                openCount2 += 1
            elif(exp[i] == '['):
                openCount3 += 1


        elif(exp[i] == ')' or exp[i] == ']' or exp[i] == '}'):
            result = newStack.pop()

            if((result == -1) or (openCount1 == 0 and exp[i] == ')') or (openCount2 == 0 and exp[i] == '}') or (openCount3 == 0 and exp[i] == ']') ):
                print("This expression is NOT correct.")
                correct = False
                if(openCount1 == 0 and exp[i] == ')'):
                    print(f'Error at character # {i + 1}. "{exp[i]}"- not opened.')
                elif(openCount2 == 0 and exp[i] == '}'):
                    print(f'Error at character # {i + 1}. "{exp[i]}"- not opened.')
                elif(openCount3 == 0 and exp[i] == ']'):
                    print(f'Error at character # {i + 1}. "{exp[i]}"- not opened.')
                break

            elif((exp[i] == ')' and result != '(') or (exp[i] == '}' and result != '{') or (exp[i] == ']' and result != '[') or (result == -1)):
                print("This expression is NOT correct.")
                correct = False
                print(f'Error at character # {indexStack.pop() + 1}. {result}- not closed.')
                break
            indexStack.pop()

    if(correct == True):
        print("This expression is correct.")

exp = '1+2*[3*3+{4-5(6(7/8/9)+10)-11+(12*8)]+14'
checkExpressionList(exp)
