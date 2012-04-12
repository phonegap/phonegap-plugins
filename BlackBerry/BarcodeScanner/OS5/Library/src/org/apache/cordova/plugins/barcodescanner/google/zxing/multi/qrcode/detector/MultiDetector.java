/*
 * Copyright 2009 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.cordova.plugins.barcodescanner.google.zxing.multi.qrcode.detector;


import java.util.Hashtable;
import java.util.Vector;

import org.apache.cordova.plugins.barcodescanner.google.zxing.NotFoundException;
import org.apache.cordova.plugins.barcodescanner.google.zxing.ReaderException;
import org.apache.cordova.plugins.barcodescanner.google.zxing.common.BitMatrix;
import org.apache.cordova.plugins.barcodescanner.google.zxing.common.DetectorResult;
import org.apache.cordova.plugins.barcodescanner.google.zxing.qrcode.detector.Detector;
import org.apache.cordova.plugins.barcodescanner.google.zxing.qrcode.detector.FinderPatternInfo;

/**
 * <p>Encapsulates logic that can detect one or more QR Codes in an image, even if the QR Code
 * is rotated or skewed, or partially obscured.</p>
 *
 * @author Sean Owen
 * @author Hannes Erven
 */
public final class MultiDetector extends Detector {

  private static final DetectorResult[] EMPTY_DETECTOR_RESULTS = new DetectorResult[0];

  public MultiDetector(BitMatrix image) {
    super(image);
  }

  public DetectorResult[] detectMulti(Hashtable hints) throws NotFoundException {
    BitMatrix image = getImage();
    MultiFinderPatternFinder finder = new MultiFinderPatternFinder(image);
    FinderPatternInfo[] info = finder.findMulti(hints);

    if (info == null || info.length == 0) {
      throw NotFoundException.getNotFoundInstance();
    }

    Vector result = new Vector();
    for (int i = 0; i < info.length; i++) {
      try {
        result.addElement(processFinderPatternInfo(info[i]));
      } catch (ReaderException e) {
        // ignore
      }
    }
    if (result.isEmpty()) {
      return EMPTY_DETECTOR_RESULTS;
    } else {
      DetectorResult[] resultArray = new DetectorResult[result.size()];
      for (int i = 0; i < result.size(); i++) {
        resultArray[i] = (DetectorResult) result.elementAt(i);
      }
      return resultArray;
    }
  }

}
