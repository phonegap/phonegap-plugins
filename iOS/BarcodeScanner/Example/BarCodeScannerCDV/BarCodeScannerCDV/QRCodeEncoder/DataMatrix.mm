

#import "DataMatrix.h"


@implementation DataMatrix

- (id)initWith:(int)dimension {
    if ([super init]) {
        self->dim = dimension;
        self->data = (bool**)malloc(sizeof(bool*) * self->dim);
        for (int y=0; y<self->dim; y++) {
            self->data[y] = (bool*)malloc(sizeof(bool) * self->dim);
            if (self->data[y]==NULL) {
                NSLog(@"null!");
            }
        }
        
    }
    return self;
}

- (int)dimension {
    return self->dim;
}

- (void)set:(bool)value x:(int)x y:(int)y {
    self->data[y][x] = value;
}

- (bool)valueAt:(int)x y:(int)y {
    return self->data[y][x];
}

- (NSString*)toString {
    NSString* string = [NSString string];
    for (int y=0; y<self->dim; y++) {
        for (int x=0; x<self->dim; x++) {
            bool value = self->data[y][x];
            string = [string stringByAppendingFormat:@"%d", value];
        }
        string = [string stringByAppendingString:@"\n"];
    }
    return string;
}

- (void)dealloc {
    for (int y=0; y<self->dim; y++) {
        free(self->data[y]);
    }
    free(self->data);
    [super dealloc];
}

@end
