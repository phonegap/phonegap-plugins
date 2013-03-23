#!/usr/bin/env python

#-------------------------------------------------------------------------------
# PhoneGap is available under *either* the terms of the modified BSD license *or* the
# MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
#
# Copyright (c) 2011, IBM Corporation
#-------------------------------------------------------------------------------

import os
import re
import sys
import json

PROGRAM = os.path.basename(sys.argv[0])

#-------------------------------------------------------------------------------
def main():

    iDirName  = "desktop-app/images"
    oFileName = "desktop-app/image-data.json.js"

    entries = os.listdir(iDirName)
    if len(entries) == 0:
        error("no image files found!")

    images = {}
    for entry in entries:
        (baseName, ext) = os.path.splitext(entry)
        if ext in [".txt", ".jpg", ".gif", ".png"]:
            if not baseName in images:
                images[baseName] = {"text":"", "image":""}

            if ext != ".txt":
                images[baseName]["image"] = entry
                pattern = re.compile(r"(.*?)-.*")
                match = pattern.match(baseName)
                if match:
                    images[baseName]["format"] = match.group(1).upper()
                else:
                    error("file name not formatted to include type: %s" % entry)
            else:
                iFile = open(os.path.join(iDirName, entry))
                contents = iFile.read().strip()
                iFile.close()
                images[baseName]["text"] = contents


    newImages = []
    for name, data in images.iteritems():
        if data["image"] == "":
            error("no image for %s" % name)
        if data["text"] == "":
            error("no text for %s" % name)

        newImages.append(data)

    images = newImages
    images.sort(lambda x,y: cmp(x["image"],y["image"]))

    contents = "ImageData = %s\n" % json.dumps(images, indent=4)

    oFile = open(oFileName, "w")
    oFile.write(contents)
    oFile.close()

    log("generated file: %s" % oFileName)

#-------------------------------------------------------------------------------
def log(message):
    print "%s: %s" % (PROGRAM, message)

#-------------------------------------------------------------------------------
def error(message):
    log("error: %s" % (message))
    sys.exit(-1)

#-------------------------------------------------------------------------------
main()