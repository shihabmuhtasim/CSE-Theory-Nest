class Node:
    def __init__(self, data, loc):
        self.data = data
        self.next = loc

class MyList:
    def __init__(self, arr):
        if(len(arr) == 0):
            print("Array cannot be empty")
        else:
            self.head = None
            tail = None
            for i in arr:
                n1 = Node(i, None)
                
                if(self.head == None):
                    self.head = n1
                    tail = n1

                else:
                    tail.next = n1
                    tail = n1

    def showList(self):
        n = self.head
        while(n != None):
            if(n.next is not None):
                print(n.data, end="->")
            else:
                print(n.data, end='-|')
            n = n.next

    def isEmpty(self):
        if (self.head == None):
            return True
        else:
            return False

    def clear(self):
        if(self.head == None):
            print("List is already empty")
        else:
            n = self.head
            while(n != None):
                temp = n.next
                n.next = None
                n.elem = None
                n = None
                n = temp

            self.head = None 

    def insert1(self, newElement):
        n = self.head
        newNode = Node(newElement, None)
        while(n != None):
            if(n.data == newElement):
                print("Key already exists")
                break
            if(n.next == None):
                n.next = newNode
                break
            n = n.next

    def insert2(self, newElement, index):
        n = self.head
        newNode = Node(newElement, None)
        if(self.head == None):
            print("List cannot be empty")
        else:
            if (index != 0):
                i = 0
                while(i < index):
                    if(n == None):
                        print("Index Out of Range")
                        break
                    if(n.data == newNode.data):
                        print("Key already exists")
                        break
                    if(i == (index - 1)):
                        newNode.next = n.next
                        n.next = newNode
                        break
                    i = i + 1
                    n = n.next
            else:
                newNode.next = n
                self.head = newNode

    def remove(self, deleteKey):
        if(self.head == None):
            print("List is already empty")
        else:
            n = self.head
            if(self.head.data == deleteKey):
                value = self.head
                self.head = self.head.next
                return value.data
            else:
                while(n != None):
                    if(n.next.data == deleteKey):
                        value = n.next
                        if(n.next.next != None):
                            n.next = n.next.next
                        else:
                            n.next = None
                        return value.data
                    n = n.next

    def findEven(self):
        n = self.head
        count = 0
        while(n != None):
            if( n.data % 2 == 0):
                if(count == 0):
                    print(n.data, end='')
                    count = 1
                else:
                    print('->', end='')
                    print(n.data, end='')
            n = n.next

    def isInList(self, element):
        n = self.head
        while(n != None):
            if(n.data == element):
                return True
            n = n.next

        return False

    def reverseList(self):
        newHead = None
        n = self.head
        
        while(n != None):
            nextNode = n.next
            n.next = newHead
            newHead = n
            n = nextNode
        
        self.head = newHead

    # def sortList(self):
    #     n = self.head
    #     while(n.next != None):
    #         nextNode = n.next
    #         if(nextNode.data < n.data):
    #             temp = n.data
    #             n.data = nextNode.data
    #             nextNode.data = temp
    #             n = self.head
    #         else:
    #             n = n.next

    def sortList(self):
        n = self.head
        newHead = None
        while(n.next != None):
            nextNode = n.next
            if(nextNode.data < n.data):
                if(n != self.head):
                    newHead.next = nextNode
                else:
                    self.head = nextNode
                temp = nextNode.next
                n.next = temp
                nextNode.next = n
                n = self.head
            else:
                newHead = n
                n = n.next

    def sumOfList(self):
        n = self.head
        sum = 0
        while(n != None):
            sum += n.data
            n = n.next

        return sum

    def rotate(self, dir, k):
        
        if (dir == 'left'):
            for i in range(k):
                n = self.head
                start = self.head.next
                while(n != None):
                    if(n.next == None):
                        n.next = self.head
                        self.head.next = None
                        break
                    n = n.next
                self.head = start

        elif (dir == 'right'):
            for i in range(k):
                n = self.head
                newHead = None
                while(n != None):
                    if(n.next == None):
                        n.next = self.head
                        self.head = n
                        newHead.next = None
                        break
                    else:
                        newHead = n
                        n = n.next

arr = [20, 64, 11, 50, 41, 37]
newList = MyList(arr)
newList.showList()
print()

print(newList.isEmpty())

arr = [20, 64, 11, 50, 41, 37]
newList = MyList(arr)

newList.clear()
newList.showList()

arr = [20, 64, 11, 50, 41, 37]
newList = MyList(arr)

newList.insert1(25)
newList.showList()
print()

newList.insert2(256, 3)
newList.showList()
print()

newList.remove(37)
newList.showList()
print()

newList.findEven()
print()
print(newList.isInList(37))

newList.reverseList()
newList.showList()
print()

newList.sortList()
newList.showList()
print()

print(newList.sumOfList())
newList.rotate('right', 3)
newList.showList()