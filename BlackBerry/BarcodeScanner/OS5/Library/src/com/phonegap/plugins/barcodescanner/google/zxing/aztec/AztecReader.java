/*
 * Copyright 2010 ZXing authors
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

package com.phonegap.plugins.barcodescanner.google.zxing.aztec;

import com.phonegap.plugins.barcodescanner.google.zxing.BarcodeFormat;
import com.phonegap.plugins.barcodescanner.google.zxing.BinaryBitmap;
import com.phonegap.plugins.barcodescanner.google.zxing.ChecksumException;
import com.phonegap.plugins.barcodescanner.google.zxing.DecodeHintType;
import com.phonegap.plugins.barcodescanner.google.zxing.FormatException;
import com.phonegap.plugins.barcodescanner.google.zxing.NotFoundException;
import com.phonegap.plugins.barcodescanner.google.zxing.Reader;
import com.phonegap.plugins.barcodescanner.google.zxing.Result;
import com.phonegap.plugins.barcodescanner.google.zxing.ResultMetadataType;
import com.phonegap.plugins.barcodescanner.google.zxing.ResultPoint;
import com.phonegap.plugins.barcodescanner.google.zxing.ResultPointCallback;
import com.phonegap.plugins.barcodescanner.google.zxing.aztec.decoder.Decoder;
import com.phonegap.plugins.barcodescanner.google.zxing.aztec.detector.Detector;
import com.phonegap.plugins.barcodescanner.google.zxing.common.DecoderResult;

import java.util.Hashtable;

/**
 * This implementation can detect and decode Aztec codes in an image.
 *
 * @author David Olivier
 */
public final class AztecReader implements Reader {

  /**
   * Locates and decodes a Data Matrix code in an image.
   *
   * @return a String representing the content encoded by the Data Matrix code
   * @throws NotFoundException if a Data Matrix code cannot be found
   * @throws FormatException if a Data Matrix code cannot be decoded
   * @throws ChecksumException if error correction fails
   */
  public Result decode(BinaryBitmap image) throws NotFoundException, FormatException {
    return decode(image, null);
  }

  public Result decode(BinaryBitmap image, Hashtable hints)
      throws NotFoundException, FormatException {

    AztecDetectorResult detectorResult = new Detector(image.getBlackMatrix()).detect();
    ResultPoint[] points = detectorResult.getPoints();

    if (hints != null && detectorResult.getPoints() != null) {
      ResultPointCallback rpcb = (ResultPointCallback) hints.get(DecodeHintType.NEED_RESULT_POINT_CALLBACK);
      if (rpcb != null) {
        for (int i = 0; i < detectorResult.getPoints().length; i++) {
          rpcb.foundPossibleResultPoint(detectorResult.getPoints()[i]);
        }
      }
    }

    DecoderResult decoderResult = new Decoder().decode(detectorResult);

    Result result = new Result(decoderResult.getText(), decoderResult.getRawBytes(), points, BarcodeFormat.AZTEC);
    
    if (decoderResult.getByteSegments() != null) {
      result.putMetadata(ResultMetadataType.BYTE_SEGMENTS, decoderResult.getByteSegments());
    }
    if (decoderResult.getECLevel() != null) {
      result.putMetadata(ResultMetadataType.ERROR_CORRECTION_LEVEL, decoderResult.getECLevel().toString());
    }
    
    return result;
  }

  public void reset() {
    // do nothing
  }

}