class Node:
    def __init__(self, data, next_loc, prev_loc):
        self.data = data
        self.next = next_loc
        self.prev = prev_loc 

class DoublyList:
    def __init__(self, a):
        self.head = Node(None, None, None)
        tail = self.head

        self.head.next = self.head
        self.head.prev = self.head
        if(len(a) == 0):
            print("Array cannot be empty")
        else:
            for i in range(0, len(a), 1):
                n = Node(a[i], None, None)
                n.next = self.head
                n.prev = tail
                self.head.prev = n
                tail.next = n
                tail = n

    def showList(self):
        n = self.head.next
        if(n == None):
            print("Empty List")
        else:
            while(n != self.head):
                if(n.next == self.head):
                    print(n.data, end='-|')
                else:
                    print(n.data, end='->')

                n = n.next

    def insert1(self, newElement):
        n = self.head.next
        while(n != self.head):
            if(n.data == newElement):
                print("Key already exists")
                break
            elif(n.next == self.head):
                newNode = Node(newElement, None, None)
                newNode.next = self.head
                newNode.prev = n
                self.head.prev = newNode
                n.next = newNode
                break

            n = n.next

    def insert2(self, newElement, index):
        n = self.head.next
        
        if(n == None):
            print("The List is empty.")

        elif(index < 0 or index > len(arr)):
            print("Invalid Index")
        else:
            i = 0
            found = True
            while(n != self.head):
                if(n.data == newElement):
                    print("Key already exists")
                    break                    

                if( (found == False) and (i == index) ):
                    newNode = Node(newElement, None, None)
                    newNode.next = n
                    newNode.prev = n.prev
                    n.prev.next = newNode
                    n.prev = newNode
                    break

                if( (found == True) and (n.next == self.head) ):
                    found = False
                    n = self.head
                    i = -1

                n = n.next
                i = i + 1
                
    def remove(self, index):
        n = self.head.next

        if(n == None):
            print("The List is empty.")

        elif(index < 0 or index > len(arr)):
            print("Invalid index")

        else:
            i = 0
            while(n != self.head):
                if(i == index):
                    n.prev.next = n.next
                    n.next.prev = n.prev
                    n.next = None
                    n.prev = None
                    n.data = None
                    n = None
                    break

                n = n.next
                i = i + 1

    def removeKey(self, deleteKey):
        n = self.head.next

        if(n == None):
            print("The List is empty.")
        else:
            while(n != self.head):
                if(n.data == deleteKey):
                    n.prev.next = n.next
                    n.next.prev = n.prev
                    temp = n.data
                    n.next = None
                    n.prev = None
                    n.data = None
                    n = None
                    return temp
                
                n = n.next


arr = [10, 20, 30, 40, 50, 60, 70, 80]
newList = DoublyList(arr)
newList.showList()
print()

newList.insert1(256)
newList.showList()
print()

newList.insert2(120, 4)
newList.showList()
print()

newList.remove(7)
newList.showList()
print()

print(newList.removeKey(80))
newList.showList()