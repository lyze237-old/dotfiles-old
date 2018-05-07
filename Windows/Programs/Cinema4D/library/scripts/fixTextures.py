import c4d
from c4d import gui
#Welcome to the world of Python


def main():
    doc = c4d.documents.GetActiveDocument()
    for mat in doc.GetMaterials():
        mat[c4d.MATERIAL_USE_TRANSPARENCY] = False
        mat.Update(True, False)

if __name__=='__main__':
    main()
