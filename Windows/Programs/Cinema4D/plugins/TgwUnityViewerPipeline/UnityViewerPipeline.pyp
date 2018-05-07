import c4d
import os
import subprocess
import zipfile
import xml.etree.ElementTree

PLUGIN_ID = 1039374 #fetched from http://www.plugincafe.com/forum/developer.asp

UNITY_DIRECTORY = "C:\Program Files\Unity\Editor\Unity.exe"
UNITY_LAUNCH_USER_METHOD = "TgwUnityBuildTools.Editor.TgwUnityBuild.CreatePcViewerStorageSystemBuild"

TGW_UNITY_BUILD_TOOLS_BUILDER_SCRIPT = "D:/Sources/Other/TgwUnityBuildToolsBuilder.bat"
TGW_UNITY_BUILD_TOOLS_BUILDER_UNITYPACKAGE_DIRECTORY = "D:/Sources/Other/tsi_hololens/TgwUnityBuildTools/Exports"
TGW_UNITY_BUILD_TOOLS_UNITYPACKAGE = "TgwUnityBuildTools_Core"
TGW_UNITY_BUILD_TOOLS_UNITYPACKAGE_ADDON = "TgwUnityBuildTools_TgwUnityViewer"

UNIT_SCALE = 100

class UnityViewerPipeline(c4d.plugins.CommandData):

    def __init__(self):
        self.importFile = None
        self.exportDirectory = None
        self.demo3dFile = None

    def Register(self):
        print "Registering Unity Viewer Pipeline v 1.0"
        return c4d.plugins.RegisterCommandPlugin(
            PLUGIN_ID, 
            "TGW/UnityViewerPipeline",
            c4d.PLUGINFLAG_COMMAND_HOTKEY,
            None,
            "Imports a dae file from demo 3d, fixes it, exports it as fbx, starts unity and imports fbx",
            self
        )
        
    def Execute(self, doc):
        self.doc = c4d.documents.GetActiveDocument()
        
        
        print "Select Files n Directories"
    
        if not self.FindDirectories():
            return False
            
        
        
        print "Prepare Demo 3D File"
        if not self.PrepareDemo3dFile():
            return False
        
        print "Importing File"
        self.ImportFile(self.importFile)
        
        print "Fixing Materials"
        self.FixMaterials()
        
        print "Fixing Empty Nulls"
        self.FixEmptyNulls()
        
        
        print "Create cams from demo3d"
        cameras = self.CreateDemo3dCams()
        print "All cameras: " + str(cameras)
        
        
        
        print "Building Unity Build Tools"
        launchParameter = ["cmd", "/C", TGW_UNITY_BUILD_TOOLS_BUILDER_SCRIPT]
        print "Launching build tools with: " + str(launchParameter)
        p = subprocess.Popen(launchParameter, shell=True, stdout=subprocess.PIPE)
        stdout, stderr = p.communicate()
        
        for file in os.listdir(TGW_UNITY_BUILD_TOOLS_BUILDER_UNITYPACKAGE_DIRECTORY):
            if TGW_UNITY_BUILD_TOOLS_UNITYPACKAGE in file:
                unitypackage = os.path.join(TGW_UNITY_BUILD_TOOLS_BUILDER_UNITYPACKAGE_DIRECTORY, file)
        
        print unitypackage
        
        if not unitypackage:
            c4d.gui.MessageDialog("Couldn't find unitypackage build tools... did the build succeed?")
            return False
            
            
        for file in os.listdir(TGW_UNITY_BUILD_TOOLS_BUILDER_UNITYPACKAGE_DIRECTORY):
            if TGW_UNITY_BUILD_TOOLS_UNITYPACKAGE_ADDON in file:
                unitypackageAddon = os.path.join(TGW_UNITY_BUILD_TOOLS_BUILDER_UNITYPACKAGE_DIRECTORY, file)
        
        print unitypackageAddon
        
        if not unitypackageAddon:
            c4d.gui.MessageDialog("Couldn't find unitypackage build tools addon... did the build succeed?")
            return False
        
        
        
        print "Creating unity project"
        unityLaunchParameter = [UNITY_DIRECTORY, "-quit", "-batchmode", "-createProject", self.exportDirectory, "-logFile", self.exportDirectory + "create.log", "-importPackage", unitypackage]
        print "Starting unity: " + str(unityLaunchParameter)
        p = subprocess.Popen(unityLaunchParameter, shell=True, stdout=subprocess.PIPE)
        stdout, stderr = p.communicate()
        
        
        print "Importing second unitypackage"
        unityLaunchParameter = [UNITY_DIRECTORY, "-quit", "-batchmode", "-projectPath", self.exportDirectory, "-logFile", self.exportDirectory + "create2.log", "-importPackage", unitypackageAddon]
        print "Starting unity: " + str(unityLaunchParameter)
        p = subprocess.Popen(unityLaunchParameter, shell=True, stdout=subprocess.PIPE)
        stdout, stderr = p.communicate()
        
        
        print "Exporting"
        
        if not os.path.exists(self.exportDirectory + "Assets/Resources"):
            os.makedirs(self.exportDirectory + "Assets/Resources")
        exportPath = self.ExportStorageSystem(self.exportDirectory + "Assets/Resources")
        
        print "Import Model into Unity"
        unityLaunchParameter = [UNITY_DIRECTORY, "-quit", "-batchmode", "-logFile", self.exportDirectory + "import.log", "-projectPath", self.exportDirectory]
        print "Starting unity: " + str(unityLaunchParameter)
        p = subprocess.Popen(unityLaunchParameter, shell=True, stdout=subprocess.PIPE)
        stdout, stderr = p.communicate()
        
        
        
        arguments = []
        additionalParameter = []
        if cameras:
            print "Found cameras, creating argument list"
            camNames = ':'.join(x.name for x in cameras)
            camPositions = ':'.join(str(x.position) for x in cameras).replace("'", "")
            camLookats = ':'.join(str(x.lookat) for x in cameras).replace("'", "")
            
            defaultCam = ""
            for cam in cameras:
                if cam.default:
                    defaultCam = cam.name
                    break
            
            arguments = ["-arguments", "InvertCameraPoints=True;BuildNumber=1;DefaultCamera=" + defaultCam + ";CameraNames=(" + camNames + ");CameraPositions=(" + camPositions + ");CameraLookAts=(" + camLookats + ");ModelPath=" + (os.path.splitext(os.path.basename(self.importFile))[0] + ".fbx") ]
            additionalParameter = ["-quit"]
            print "arguments: " + str(arguments) + " / additionalparameter " + str(additionalParameter)
        
        print "Launching unity so user can choose settings"
        unityLaunchParameter = [UNITY_DIRECTORY, "-logFile", self.exportDirectory + "userinput.log", "-projectPath", self.exportDirectory, "-executeMethod", UNITY_LAUNCH_USER_METHOD] + additionalParameter + arguments
        print "Starting unity: " + str(unityLaunchParameter)
        print "Waiting till process ends ..."
        p = subprocess.Popen(unityLaunchParameter, shell=True, stdout=subprocess.PIPE)
        stdout, stderr = p.communicate()
        
        print "Done!"
        
        return True
    
    
    
    def CreateDemo3dCams(self):
        with open(self.demo3dFile, "r") as file:
            tempInput = ""
            foundTag = False
            newXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><e3d:Demo3DProject xmlns:e3d=\"uri://emulate3d.com\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
            c = file.read(1)
            while c:
                tempInput += c
                if len(tempInput) > len("<e3d:DefaultCamera>"):
                    tempInput = tempInput[1:]
                
                if foundTag:
                    newXml += c
                
                if tempInput == "<e3d:DefaultCamera>":
                    newXml += tempInput
                    print "Found " + newXml
                    foundTag = True
                    
                if "</e3d:Cameras>" in tempInput:
                    break
                 
                c = file.read(1)
                
        newXml += "</e3d:Demo3DProject>"
        print "Camera Project XML: " + newXml
        
        root = xml.etree.ElementTree.fromstring(newXml)
            
        defaultView = root.find('e3d:DefaultCamera', {"e3d": "uri://emulate3d.com"}).text
        print "Default View: " + defaultView
        
        camerasList = list()
        
        for cam in root.findall(".//e3d:Cameras/e", {"e3d": "uri://emulate3d.com", "xsi": "http://www.w3.org/2001/XMLSchema-instance"}):
            cameraObject = CameraObject(cam.find("key").text)
            
            if cameraObject.name == defaultView:
                cameraObject.default = True
            
            val = cam.find("val")
            camPosition = val.find("Position").text.split("|")
            for i in xrange(0, len(camPosition)):
                print "Cam position of " + cameraObject.name + ": " + str(i)
                print camPosition[i]
                if camPosition[i] == "":
                    camPosition[i] = 0
            
            cameraObject.position = camPosition
            
            camTarget = val.find("Target")
            if camTarget is None:
                camTarget = [0, 0, 0]
            else:
                camTarget = camTarget.text.split("|")
                for i in xrange(0, len(camTarget)):
                    if camTarget[i] == "":
                        camTarget[i] = 0
        
            cameraObject.lookat = camTarget
        
            print "Creating cam: " + str(cameraObject)
            
            camerasList.append(cameraObject)
            
            #c4dCam = c4d.BaseObject(c4d.Ocamera)
            #c4dCam.SetName(cameraObject.name)
            #c4dCam.SetRelPos(c4d.Vector(float(camPosition[0]), float(camPosition[1]), float(camPosition[2])) * UNIT_SCALE)
            #self.doc.InsertObject(c4dCam)
            
            #c4dTarget = c4d.BaseObject(c4d.Onull)
            #c4dTarget.SetName(cameraObject.name + "_Target")
            #c4dTarget.SetRelPos(c4d.Vector(float(camTarget[0]), float(camTarget[1]), float(camTarget[2])) * UNIT_SCALE)
            #self.doc.InsertObject(c4dTarget)
            
            #c4dTargetTag = c4dCam.MakeTag(c4d.Ttargetexpression)
            #c4dTargetTag[c4d.TARGETEXPRESSIONTAG_LINK] = c4dTarget
            
        c4d.EventAdd()
        
        return camerasList

        
    
    
    def PrepareDemo3dFile(self):
        self.demo3dFile = os.path.splitext(self.importFile)[0] + ".demo3d"
        print "Demo 3d file: " + self.demo3dFile
        
        if not os.path.isfile(self.demo3dFile):
            c4d.gui.MessageDialog("Couldn't find demo3d file...")
            return False
    
        print "Extracting demo3d file"
    
        with zipfile.ZipFile(self.demo3dFile, "r") as zip_ref:
            os.makedirs(self.exportDirectory + "Zip")
            zip_ref.extractall(self.exportDirectory + "Zip")
    
        for file in os.listdir(self.exportDirectory + "Zip"):
            if file.endswith(".demo3d"):
                self.demo3dFile = self.exportDirectory + "Zip/" + file
    
        print "New demo3d file: "+ self.demo3dFile
        
        return True
        
        
        
        
        
        
    
    def ExportStorageSystem(self, dir): 
        if not dir.endswith("/"):
            dir += "/"
        
        path = dir + os.path.splitext(os.path.basename(self.importFile))[0] + ".fbx"
        print "Exporting to " + path
        c4d.documents.SaveDocument(self.doc, path, c4d.SAVEDOCUMENTFLAGS_DONTADDTORECENTLIST, 1026370)
        return path
    
    
    def FindDirectories(self):
        self.importFile = c4d.storage.LoadDialog(type=c4d.FILESELECTTYPE_SCENES, title="Choose storage system to process")
        self.exportDirectory = c4d.storage.LoadDialog(type=c4d.FILESELECTTYPE_ANYTHING, title="Select the unity project directory (new folder!)", flags=c4d.FILESELECT_DIRECTORY)
        
        if self.importFile is None or self.exportDirectory is None:
            c4d.gui.MessageDialog("User cancelled pipeline...")
            return False
            
        if len(os.listdir(self.exportDirectory)) > 0:
            c4d.gui.MessageDialog('Export Directory is not empty!')
            return False
        

        if not self.exportDirectory.endswith("/"):
            self.exportDirectory = self.exportDirectory + "/"
        
        print "Import File: " + self.importFile + " / Export File: " + self.exportDirectory
        
        
        return True
    
    
    
    
    def ImportFile(self, file):
        if file is None:
            return False

        # Find the FBX importer plugin
        plug = c4d.plugins.FindPlugin(1026369, c4d.PLUGINTYPE_SCENELOADER)
        if plug is None:
            return False

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
        c4d.documents.MergeDocument(self.doc, file, c4d.SCENEFILTER_OBJECTS | c4d.SCENEFILTER_MATERIALS, None)
        
        c4d.EventAdd()
    
    
    
    
    def FixMaterials(self):
        for mat in self.doc.GetMaterials():
            mat[c4d.MATERIAL_USE_TRANSPARENCY] = False
        mat.Update(True, False)

        
        
        
    def FixEmptyNulls(self):
        found = True
        while found:
            try:
                found = False
                for baseObj in self.doc.GetObjects():
                    objects = ObjectIterator(baseObj)
                    for obj in objects:
                        if self.RemoveEmpty(obj):
                            found = True
            except ReferenceError:
                print "Couldn't process next element ... restarting"

                
                
                
    def RemoveEmpty(self, obj):
        if not obj:
            return
        
        if not obj.GetDown():
            if obj.GetType() == c4d.Opolygon:
                if obj.GetPolygonCount() <= 1:
                    print "Removed " + obj.GetName() + " (1 polygon)"
                    obj.Remove()
                    return True
            elif obj.GetType() == c4d.Olight:
                print "Removed " + obj.GetName() + " (Light)"
                obj.Remove()
                return True
            elif obj.GetType() == c4d.Onull:
                if not obj.GetFirstTag():
                    obj.Remove()
                    print "Removed " + obj.GetName()  + " (empty null)"
                    return True
        return False

                   



                   
if __name__=='__main__':
    UnityViewerPipeline().Register()    

    
    
    
    
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
        if child:
            self.nextDepth = self.depth + 1
            self.objectStack.append(self.currentObject.GetNext())
            self.currentObject = child
        else:
            self.currentObject = self.currentObject.GetNext()
            while( self.currentObject == None and len(self.objectStack) > 0 ) :
                self.currentObject = self.objectStack.pop()
                self.nextDepth = self.nextDepth - 1
        return obj
        
        
class CameraObject:        
    def __init__(self, name, position=[0, 0, 0], lookat=[0, 0, 0], default = False):
        self.name = name
        self.position = position
        self.lookat = lookat
        self.default = default
        
    def __repr__(self):
        return "CameraObject {name=" + self.name + "; position=" + str(self.position) + "; lookat=" + str(self.lookat) + "; default=" + str(self.default) + "}"