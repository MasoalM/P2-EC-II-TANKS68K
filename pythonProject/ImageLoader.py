from skimage.io import imread

theImage = imread('../IMAGES/tankIntro.jpg')
numRows, numCols, _ = theImage.shape
outData = []

for r in range(numRows):
    for c in range(numCols):
        theRed, theGreen, theBlue = theImage[r, c]
        outData += [0, theBlue, theGreen, theRed]

with open('SALIDA.bin', 'wb') as outFile:
    outFile.write(bytearray(outData))