//
//  LeapMotionFrameData.h
//  LeapMotionKeystrokeCapture
//
//  Created by Aaron Rosen on 5/18/17.
//  Copyright © 2017 Aaron Rosen. All rights reserved.
//
@import Foundation;

#ifndef LeapMotionFrameData_h
#define LeapMotionFrameData_h

@interface LeapMotionFrameData : NSObject
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSData *serializedFrameData;
@property (nonatomic) int keyCode;

- (instancetype)initWithImageData:(NSData*)imageData andSerializedFrameData:(NSData*)serializedFrameData andKeyCode:(int)keyCode;

@end

#endif /* LeapMotionFrameData_h */
