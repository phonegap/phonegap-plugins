

#import <Foundation/Foundation.h>


@interface DataMatrix : NSObject {
    
    int dim;
    bool** data;

}

- (id)initWith:(int)dimension;

- (int)dimension;

- (void)set:(bool)value x:(int)x y:(int)y;

- (bool)valueAt:(int)x y:(int)y;

- (NSString*)toString;

@end
