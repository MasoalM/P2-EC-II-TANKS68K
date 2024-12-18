from skimage.io import imread

theImage = imread('../IMAGES/PLAYER/PLAYER_Y_W.jpg')
numRows, numCols, _ = theImage.shape
outData = []

for r in range(numRows):
    for c in range(numCols):
        theRed, theGreen, theBlue = theImage[r, c]
        outData += [0, theBlue, theGreen, theRed]

with open('OUTPUT/PLAYER_OUTPUT/PLAYER_Y_W.bin', 'wb') as outFile:
    outFile.write(bytearray(outData))