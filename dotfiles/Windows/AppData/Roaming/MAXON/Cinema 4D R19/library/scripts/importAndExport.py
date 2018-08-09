import c4d
from c4d import gui
from c4d import plugins
#Welcome to the world of Python

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


def importStorageSystem(selectedFile):
    doc = c4d.documents.GetActiveDocument()
    
    if selectedFile is None:
        return

    # Find the FBX importer plugin
    plug = plugins.FindPlugin(1026369, c4d.PLUGINTYPE_SCENELOADER)
    if plug is None:
        return

    # Access the settings
    op = {}
    if plug.Message(c4d.MSG_RETRIEVEPRIVATEDATA, op):
        print op

    fbximport = op["imexporter"]
    if fbximport is None:
        return

    # Define the settings
    fbximport[c4d.FBXIMPORT_CAMERAS] = False

    # Import without dialogs
    c4d.documents.MergeDocument(doc, selectedFile, c4d.SCENEFILTER_OBJECTS | c4d.SCENEFILTER_MATERIALS, None)

    c4d.EventAdd()

def fixMaterials():
    doc = c4d.documents.GetActiveDocument()
    for mat in doc.GetMaterials():
        mat[c4d.MATERIAL_USE_TRANSPARENCY] = False
        mat.Update(True, False)

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

def fixEmptyNulls():
    found = True
    while found:
        found = False
        objects = ObjectIterator(doc.GetFirstObject())
        for obj in objects:
            if removeEmpty(obj) == True:
                found = True

def exportStorageSystem(path):
    doc = c4d.documents.GetActiveDocument()
    c4d.documents.SaveDocument(doc,path,c4d.SAVEDOCUMENTFLAGS_DONTADDTORECENTLIST,1026370)

def main():
    doc = c4d.documents.GetActiveDocument()
    
    importFile = c4d.storage.LoadDialog(type=c4d.FILESELECTTYPE_ANYTHING, title="Choose storage system to import")
    exportFile = c4d.storage.SaveDialog(type=c4d.FILESELECTTYPE_ANYTHING, title="Choose FBX export file", force_suffix = "fbx")
    
    if importFile is None or exportFile is None:
        gui.MessageDialog("Cancled...")
        return
        
    importStorageSystem(importFile)
    
    fixMaterials()
    fixEmptyNulls()
        
    exportStorageSystem(exportFile)
    
    gui.MessageDialog("Finished!")

if __name__=='__main__':
    main()