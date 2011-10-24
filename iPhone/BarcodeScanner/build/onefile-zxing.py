#!/usr/bin/env python

import os
import re
import sys

PROGRAM   = os.path.basename(sys.argv[0])
OFILEBASE = "zxing-all-in-one"

#-------------------------------------------------------------------------------
def main():
    args = sys.argv[1:]
    if len(args) != 2:
        error("expecting arguments src-dir out-dir")

    srcDir = args[0]
    outDir = args[1]

    oCppFileName = os.path.join(outDir, OFILEBASE + ".cpp")
    oHFileName   = os.path.join(outDir, OFILEBASE + ".h")

    print "processing %s to produce %s and %s" % (srcDir, oCppFileName, oHFileName)

    gatherFiles(srcDir)
    uniqueize(["logDigits", "LUMINANCE_BITS", "LUMINANCE_SHIFT", "LUMINANCE_BUCKETS"])

    systemIncludes = getSystemIncludes()

    oFile = open(oCppFileName, "w")

    oFile.write('\n#include "%s.h"\n\n' % OFILEBASE)

    for sFile in SourceFile.getSources():
        oFile.write("// file: %s\n\n" % sFile.getFileName())
        oFile.write(sFile.getSource())
        oFile.write("\n\n")

    oFile.close()

    includes = SourceFile.getIncludes()
    includes = getIncludeOrder(includes)

    oFile = open(oHFileName, "w")

    for include in systemIncludes:
        oFile.write("#include <%s>\n" % include)

    oFile.write("\n")

    for sFile in includes:
        oFile.write("// file: %s\n\n" % sFile.getFileName())
        oFile.write(sFile.getSource())
        oFile.write("\n\n")

    oFile.close()


#    print ".h files:"
#    for sFile in SourceFile.getIncludes():
#        print "   %s" % sFile.getFileName()

#    print ".cpp files:"
#    for sFile in SourceFile.getSources():
#        print "   %s" % sFile.getFileName()

#-------------------------------------------------------------------------------
def getSystemIncludes():
    systemIncludes = {}

    for sFile in SourceFile.getIncludes():
        for include in sFile.getSystemIncludes():
            systemIncludes[include] = True

    for sFile in SourceFile.getSources():
        for include in sFile.getSystemIncludes():
            systemIncludes[include] = True

    return systemIncludes.keys()

#-------------------------------------------------------------------------------
def gatherFiles(srcDir):

    allFilesOs = os.walk(srcDir)

    for (dirPath, dirNames, fileNames) in allFilesOs:
        for fileName in fileNames:
            fileName = os.path.join(dirPath, fileName)
            if   fileName[-2:] == ".h":
                SourceFile.addInclude(fileName, dirPath)
            elif fileName[-4:] == ".cpp":
                SourceFile.addSource(fileName, dirPath)
            else:
                error("unknown file type for: %s" % fileName)

#-------------------------------------------------------------------------------
def uniqueize(strings):

    files = SourceFile.getSources()
    files.extend(SourceFile.getIncludes())

    patterns = {}
    for string in strings:
        patterns[string] = re.compile(r"(\W*)(" + string + ")(\W*)")

    counter = 0
    for file in files:
        counter = counter + 1

        for string in strings:
            pattern = patterns[string]
            replace = r'\1\2_%d\3' % (counter)

            file.source = pattern.sub(replace, file.source)

#-------------------------------------------------------------------------------
class SourceFile:
    sources     = []
    includes    = []
    includesMap = {}

    @staticmethod
    def getInclude(fileName):
        return SourceFile.includesMap.get(fileName, None)

    @staticmethod
    def getSources():
        return SourceFile.sources[:]

    @staticmethod
    def getIncludes():
        return SourceFile.includes[:]

    @staticmethod
    def addSource(fileName, dirName):
        sourceFile = SourceFile(fileName, dirName)
        SourceFile.sources.append(sourceFile)

    @staticmethod
    def addInclude(fileName, dirName):
        sourceFile = SourceFile(fileName, dirName)
        SourceFile.includes.append(sourceFile)
        SourceFile.includesMap[fileName] = sourceFile

    def __init__(self, fileName, dirName):
        self.fileName  = fileName
        self.dirName   = dirName
        self.pIncludes = []
        self.sIncludes = []
        self.source    = ""

        self._process()

    def getFileName(self):
        return self.fileName

    def getSource(self):
        return self.source

    def getProjectIncludes(self):
        return self.pIncludes[:]
        pass

    def getSystemIncludes(self):
        return self.sIncludes[:]

    def _process(self):
        iFile = file(self.getFileName())
        lines = iFile.readlines()
        iFile.close()

        lines = [line.rstrip() for line in lines]

        patternInclude1 = re.compile(r'\s*#include\s*<(\s*.*?\s*)>\s*')
        patternInclude2 = re.compile(r'\s*#include\s*"(\s*.*?\s*)"\s*')
        patternDefine1  = re.compile(r'\s*#define\s*__.*_H__\s*')

        for lineNo in range(len(lines)):
            line = lines[lineNo]

            match = patternDefine1.match(line)
            if match:
                lines[lineNo] = "// " + lines[lineNo]

            match = patternInclude1.match(line)
            if match:
                fileName = match.group(1)
                if fileName.startswith("zxing/"):
                    self._addProjectInclude(fileName)
                else:
                    self._addSystemInclude(fileName)
                lines[lineNo] = "// " + lines[lineNo]
                continue

            match = patternInclude2.match(line)
            if match:
                fileName = match.group(1)
                fileName = os.path.join(self.dirName, fileName)
                self._addProjectInclude(fileName)
                lines[lineNo] = "// " + lines[lineNo]
                continue

        self.source = "\n".join(lines)

    def _addProjectInclude(self, include):
        self.pIncludes.append(include)

    def _addSystemInclude(self, include):
        self.sIncludes.append(include)

#-------------------------------------------------------------------------------
def getIncludeOrder(foundIncludes):
    foundIncludes = [include.getFileName() for include in foundIncludes]

    orderedIncludes =  """
       zxing/Exception.h
       zxing/common/IllegalArgumentException.h
       zxing/common/Counted.h
       zxing/common/BitArray.h
       zxing/common/BitMatrix.h
       zxing/common/Array.h
       zxing/common/Str.h
       zxing/common/BitSource.h
       zxing/common/DecoderResult.h
       zxing/common/PerspectiveTransform.h
       zxing/ResultPoint.h
       zxing/common/DetectorResult.h
       zxing/common/Point.h
       zxing/common/EdgeDetector.h
       zxing/LuminanceSource.h
       zxing/Binarizer.h
       zxing/common/GlobalHistogramBinarizer.h
       zxing/common/GreyscaleLuminanceSource.h
       zxing/common/GreyscaleRotatedLuminanceSource.h
       zxing/common/GridSampler.h
       zxing/common/HybridBinarizer.h
       zxing/common/reedsolomon/GF256.h
       zxing/common/reedsolomon/GF256Poly.h
       zxing/common/reedsolomon/ReedSolomonDecoder.h
       zxing/common/reedsolomon/ReedSolomonException.h
       zxing/BarcodeFormat.h
       zxing/BinaryBitmap.h
       zxing/ResultPointCallback.h
       zxing/DecodeHints.h
       zxing/Result.h
       zxing/Reader.h
       zxing/MultiFormatReader.h
       zxing/ReaderException.h
       zxing/datamatrix/decoder/Decoder.h
       zxing/datamatrix/DataMatrixReader.h
       zxing/datamatrix/Version.h
       zxing/datamatrix/decoder/BitMatrixParser.h
       zxing/datamatrix/decoder/DataBlock.h
       zxing/datamatrix/decoder/DecodedBitStreamParser.h
       zxing/datamatrix/detector/CornerPoint.h
       zxing/datamatrix/detector/MonochromeRectangleDetector.h
       zxing/datamatrix/detector/Detector.h
       zxing/oned/OneDReader.h
       zxing/oned/Code128Reader.h
       zxing/oned/Code39Reader.h
       zxing/oned/UPCEANReader.h
       zxing/oned/EAN13Reader.h
       zxing/oned/EAN8Reader.h
       zxing/oned/ITFReader.h
       zxing/oned/MultiFormatOneDReader.h
       zxing/oned/MultiFormatUPCEANReader.h
       zxing/oned/OneDResultPoint.h
       zxing/oned/UPCAReader.h
       zxing/oned/UPCEReader.h
       zxing/qrcode/ErrorCorrectionLevel.h
       zxing/qrcode/FormatInformation.h
       zxing/qrcode/decoder/Decoder.h
       zxing/qrcode/QRCodeReader.h
       zxing/qrcode/Version.h
       zxing/qrcode/decoder/BitMatrixParser.h
       zxing/qrcode/decoder/DataBlock.h
       zxing/qrcode/decoder/DataMask.h
       zxing/qrcode/decoder/Mode.h
       zxing/qrcode/decoder/DecodedBitStreamParser.h
       zxing/qrcode/detector/AlignmentPattern.h
       zxing/qrcode/detector/AlignmentPatternFinder.h
       zxing/qrcode/detector/Detector.h
       zxing/qrcode/detector/FinderPattern.h
       zxing/qrcode/detector/FinderPatternInfo.h
       zxing/qrcode/detector/FinderPatternFinder.h
       zxing/qrcode/detector/QREdgeDetector.h
    """.split()

    foundError = False

    for include in foundIncludes:
        if include not in orderedIncludes:
            foundError = True
            log("error: found include not listed in ordered includes: %s" % include)

    includes = []
    for include in orderedIncludes:
        if include in foundIncludes:
            includes.append(SourceFile.getInclude(include))
        else:
            foundError = True
            log("error: ordered include not found: %s" % include)

    if foundError:
        error("exiting")

    return includes

#-------------------------------------------------------------------------------
def log(message):
    print "%s: %s" % (PROGRAM, message)

#-------------------------------------------------------------------------------
def error(message):
    log("error: %s" % (message))
    sys.exit(-1)

#-------------------------------------------------------------------------------
main()