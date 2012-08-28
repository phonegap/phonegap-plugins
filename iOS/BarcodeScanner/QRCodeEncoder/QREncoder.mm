
#import "QREncoder.h"
#include "QR_Encode.h"

const static int QR_ECLEVEL_H =     QR_LEVEL_H;
const static int QR_ECLEVEL_M =     QR_LEVEL_M;
const static int QR_ECLEVEL_L =     QR_LEVEL_L;
const static int QR_ECLEVEL_Q =     QR_LEVEL_Q;

@implementation QREncoder

+ (NSData*)AESEncryptString:(NSString*)string withPassphrase:(NSString*)passphrase {
    if (passphrase.length>kCCKeySizeAES256) {
        throw [NSException exceptionWithName:@"invalid passphrase exception" reason:[NSString stringWithFormat:@"passphrase too long: %d", passphrase.length] userInfo:nil];
    }
    const char* cstrPassphraseOriginal = [passphrase cStringUsingEncoding:NSUTF8StringEncoding];
    char cstrPassphrasePadded[kCCKeySizeAES256 + 1];
    memset(cstrPassphrasePadded, 0, sizeof(cstrPassphrasePadded));
    memcpy(cstrPassphrasePadded, cstrPassphraseOriginal, [passphrase length]);
    const char* dataIn = [string cStringUsingEncoding:NSUTF8StringEncoding];
    size_t dataInLength = [string length];
    size_t dataOutLength = dataInLength + kCCBlockSizeAES128;
    void* dataOut = malloc(dataOutLength);
    size_t encryptedDataLength = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, cstrPassphrasePadded, kCCKeySizeAES256, NULL, dataIn, dataInLength, dataOut, dataOutLength, &encryptedDataLength);
    NSData* encryptedData = nil;
    if (status==kCCSuccess) {
        encryptedData = [NSData dataWithBytes:dataOut length:encryptedDataLength];
    }
    free(dataOut);
    return encryptedData;
}

+ (NSString*)AESDecryptString:(NSData*)string withPassphrase:(NSString*)passphrase {
    if (passphrase.length>kCCKeySizeAES256) {
        throw [NSException exceptionWithName:@"invalid passphrase exception" reason:[NSString stringWithFormat:@"passphrase too long: %d", passphrase.length] userInfo:nil];
    }
    const char* cstrPassphraseOriginal = [passphrase cStringUsingEncoding:NSASCIIStringEncoding];
    char cstrPassphrase[kCCKeySizeAES256 + 1];
    memset(cstrPassphrase, 0, sizeof(cstrPassphrase));
    memcpy(cstrPassphrase, cstrPassphraseOriginal, [passphrase length]);
    const void* dataIn = [string bytes];
    size_t dataInLength = [string length];
    size_t dataOutLength = dataInLength + kCCBlockSizeAES128;
    void* dataOut = malloc(dataOutLength);
    size_t decryptedDataLength = 0;
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, cstrPassphrase, kCCKeySizeAES256, NULL, dataIn, dataInLength, dataOut, dataOutLength, &decryptedDataLength);
    NSString* decryptedString = nil;
    if (status==kCCSuccess) {
        NSData* data = [NSData dataWithBytes:dataOut length:decryptedDataLength];
        decryptedString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    free(dataOut);
    return decryptedString;
}

+ (DataMatrix*)encodeCStringWithECLevel:(int)ecLevel version:(int)version cstring:(const char*)cstring {
    CQR_Encode* encoder = new CQR_Encode;
    encoder->EncodeData(ecLevel, version, true, -1, cstring);
    int dimension = encoder->m_nSymbleSize;
    DataMatrix* matrix = [[[DataMatrix alloc] initWith:dimension] autorelease];
    for (int y=0; y<dimension; y++) {
        for (int x=0; x<dimension; x++) {
            int v = encoder->m_byModuleData[y][x];
            bool bk = v==1;
            [matrix set:bk x:y y:x];
        }
    }
    
    delete encoder;
    
    return matrix;

}

+ (DataMatrix*)encodeWithECLevel:(int)ecLevel version:(int)version string:(NSString *)string AESPassphrase:(NSString*)AESPassphrase {
    NSData* encryptedString = [QREncoder AESEncryptString:string withPassphrase:AESPassphrase];
    const unsigned int len = [encryptedString length];
    char cstring[len + 1];
    bzero(cstring, len + 1);
    [encryptedString getBytes:cstring length:len];
    DataMatrix* matrix = [QREncoder encodeCStringWithECLevel:ecLevel version:version cstring:cstring];
    return matrix;
}

+ (DataMatrix*)encodeWithECLevel:(int)ecLevel version:(int)version string:(NSString *)string {
    const char* cstring = [string cStringUsingEncoding:NSUTF8StringEncoding];
    DataMatrix* matrix = [QREncoder encodeCStringWithECLevel:ecLevel version:version cstring:cstring];
    return matrix;
}

+ (UIImage*)renderDataMatrix:(DataMatrix*)matrix imageDimension:(int)imageDimension {
    
    const int bitsPerPixel = BITS_PER_BYTE * BYTES_PER_PIXEL;
    const int bytesPerLine = BYTES_PER_PIXEL * imageDimension;
    const int rawDataSize = imageDimension * imageDimension * BYTES_PER_PIXEL;
    unsigned char* rawData = (unsigned char*)malloc(rawDataSize);
    
    int matrixDimension = [matrix dimension];
    int pixelPerDot = imageDimension / matrixDimension;
    int offsetTopAndLeft = (int)((imageDimension - pixelPerDot * matrixDimension) / 2);
    int offsetBottomAndRight = (imageDimension - pixelPerDot * matrixDimension - offsetTopAndLeft);
    
    // alpha, blue, green, red
    const uint32_t white = 0xFFFFFFFF, black = 0xFF000000, transp = 0x00FFFFFF;
    
    uint32_t *ptrData = (uint32_t *)rawData;
    // top offset
    for(int c=offsetTopAndLeft*imageDimension; c>0; c--)
        *(ptrData++) = transp;
    
    for(int my=0; my<matrixDimension; my++) {
        uint32_t *ptrDataSouce = ptrData; // start of the row we will copy
        // left offset
        for(int c=offsetTopAndLeft; c>0; c--) 
            *(ptrData++) = transp;
        
        for(int mx=0; mx<matrixDimension; mx++) {
            uint32_t clr = [matrix valueAt:mx y:my] ? black : white;
            // draw one pixel line of data
            for(int c=pixelPerDot; c>0; c--) 
                *(ptrData++) = clr;
        }
        
        // right offset
        for(int c=offsetBottomAndRight; c>0; c--) 
            *(ptrData++) = transp;
        
        // then copy that row pixelPerDot-1 times
        for(int c=(pixelPerDot-1)*imageDimension; c>0; c--) 
            *(ptrData++) = *(ptrDataSouce++);
    }
    
    // bottom offset
    for(int c=offsetBottomAndRight*imageDimension; c>0; c--) 
        *(ptrData++) = transp;
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, 
                                                              rawData, 
                                                              rawDataSize, 
                                                              FLProviderReleaseData);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageDimension,
                                        imageDimension,
                                        BITS_PER_BYTE,
                                        bitsPerPixel,
                                        bytesPerLine,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL,NO,renderingIntent);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    return newImage;
}

void FLProviderReleaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}

@end
