

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>

#import "DataMatrix.h"

const static int QR_ECLEVEL_AUTO =  0;


const static int QR_VERSION_AUTO =  -1;

const static int BITS_PER_BYTE =    8;
const static int BYTES_PER_PIXEL =  4;

const static unsigned char WHITE =  0xff;

@interface QREncoder : NSObject {
    
}

+ (DataMatrix*)encodeWithECLevel:(int)ecLevel version:(int)version string:(NSString *)string AESPassphrase:(NSString*)AESPassphrase;

+ (DataMatrix*)encodeWithECLevel:(int)ecLevel version:(int)version string:(NSString*)string;

+ (UIImage*)renderDataMatrix:(DataMatrix*)matrix imageDimension:(int)imageDimension;

@end

void FLProviderReleaseData(void *info, const void *data, size_t size);
