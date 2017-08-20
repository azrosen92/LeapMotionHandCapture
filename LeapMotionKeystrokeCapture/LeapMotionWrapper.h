//
//  LeapMotionWrapper.h
//  LeapMotionKeystrokeCapture
//
//  Created by Aaron Rosen on 5/18/17.
//  Copyright © 2017 Aaron Rosen. All rights reserved.
//
@import Foundation;

#ifndef LeapMotionWrapper_h
#define LeapMotionWrapper_h
@interface LeapMotionWrapper : NSObject

- (NSArray*) recordFrameForKeyCode:(int) keyCode;

@end

#endif /* LeapMotionWrapper_h */
