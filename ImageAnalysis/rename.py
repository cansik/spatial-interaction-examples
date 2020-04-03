import glob
import re
import os

singleNumber = re.compile('frames/capture-\d.jpg')
doubleNumber = re.compile('frames/capture-\d\d.jpg')
tripleNumber = re.compile('frames/capture-\d\d\d.jpg')

images = glob.glob("frames/*.jpg")

for img in images:
	name = img

	if(singleNumber.match(img)):
		name = img.replace("-", "-000")

	if(doubleNumber.match(img)):
		name = img.replace("-", "-00")

	if(tripleNumber.match(img)):
		name = img.replace("-", "-0")

	os.rename(img, name)