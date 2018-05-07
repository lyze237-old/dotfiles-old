# Private Dotfiles, Settings and Scripts for my Windows Machines

### Type

* Programs - Files from various Programs (E.g. Settings and co).
* Scripts - Shell scripts.
* Setup - Scripts which get called in init.bat to initialize the repo on the client.
* Tools - Various additional programs/tools I might need.

------

### Program Information

#### Cinema 4D

* plugins: Self written or found on websites.
    * UnityViewerPipeline: converts a model file into a unity assetbundle.
    * [KTools](http://www.kurzemnieks.com/goodies/): Cleans empty selection tags or materials from objects.
* library/layout:
    * default: C4D layout I always use.
* library/scripts:
    * FixTextures: Removes transparency from all textures.
    * RemoveEmptyNulls: Deletes all null objects which are empty.
    * ImportAndExport: Imports a model, calls fixTextures and RemoveEmptyNulls then exports the model as fbx file.
    * SplitObjectsPerMaterial: Splits a object based on materials.