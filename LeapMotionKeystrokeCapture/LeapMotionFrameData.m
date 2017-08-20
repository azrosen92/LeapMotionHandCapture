//
//  LeapMotionFrameData.m
//  LeapMotionKeystrokeCapture
//
//  Created by Aaron Rosen on 5/18/17.
//  Copyright © 2017 Aaron Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapMotionFrameData.h"

@implementation LeapMotionFrameData : NSObject

- (instancetype)initWithImageData:(NSData*)imageData andSerializedFrameData:(NSData*)serializedFrameData andKeyCode:(int)keyCode
{
    self = [super init];
    if (self) {
        self.imageData = imageData;
        self.serializedFrameData = serializedFrameData;
        self.keyCode = keyCode;
    }
    return self;
}

@end
