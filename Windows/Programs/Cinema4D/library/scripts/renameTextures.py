import c4d
from c4d import gui
#Welcome to the world of Python


def main():
    doc = c4d.documents.GetActiveDocument()
    cnt = 0
    for mat in doc.GetMaterials():
        mat.SetName("mat" + str(cnt))
        mat.Update(True, False)
        cnt = cnt + 1

if __name__=='__main__':
    main()
