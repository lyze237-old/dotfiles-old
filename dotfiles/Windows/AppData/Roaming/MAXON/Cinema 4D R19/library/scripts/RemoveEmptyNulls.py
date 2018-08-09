import c4d
from c4d import gui






class ObjectIterator :
    def __init__(self, baseObject):
        self.baseObject = baseObject
        self.currentObject = baseObject
        self.objectStack = []
        self.depth = 0
        self.nextDepth = 0
    
    def __iter__(self):
        return self
    
    def next(self):
        if self.currentObject == None :
            raise StopIteration
    
        obj = self.currentObject
        self.depth = self.nextDepth
    
        child = self.currentObject.GetDown()
        if child :
            self.nextDepth = self.depth + 1
            self.objectStack.append(self.currentObject.GetNext())
            self.currentObject = child
        else :
            self.currentObject = self.currentObject.GetNext()
            while( self.currentObject == None and len(self.objectStack) > 0 ) :
                self.currentObject = self.objectStack.pop()
                self.nextDepth = self.nextDepth - 1
        return obj








def removeEmpty(obj):
    if not obj:
        return
        
    if not obj.GetDown():
        if obj.GetType()== c4d.Onull:
            if not obj.GetFirstTag():
                obj.Remove()
                print "Removing " + obj.GetName()
                return True
            
    return False
                
                
def main():

    found = True
    while found:
        found = False
        objects = ObjectIterator(doc.GetFirstObject())
        for obj in objects:
            if removeEmpty(obj) == True:
                found = True

    c4d.EventAdd()
if __name__=='__main__':
    main()