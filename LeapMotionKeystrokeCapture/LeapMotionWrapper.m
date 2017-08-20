//
//  LeapMotionWrapper.m
//  LeapMotionKeystrokeCapture
//
//  Created by Aaron Rosen on 5/15/17.
//  Copyright © 2017 Aaron Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
// http://www.ios-blog.co.uk/tutorials/objective-c/how-to-use-objective-c-classes-in-swift/
// https://developer.leapmotion.com/documentation/objc/devguide/Project_Setup.html#id1
#import "LeapMotionWrapper.h"
#import "LeapObjectiveC.h"
#import "LeapMotionFrameData.h"

@interface LeapMotionWrapper () <LeapListener>
@property (nonatomic, strong) LeapController *controller;
@end

@implementation LeapMotionWrapper : NSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.controller = [[LeapController alloc] init];
        [self.controller addListener:self];
        NSLog(@"running");
    }

    return self;
}

/*
- (void)onFrame:(NSNotification *)notification
{
    LeapFrame *frame = [self.controller frame:0];
    NSArray<LeapImage *> *images = frame.images;

    NSLog(@"Images processed: %ld", [images count]);
    NSLog(@"Frame id: %lld, timestamp: %lld, hands: %ld, fingers: %ld, tools: %ld, gestures: %ld",
          [frame id], [frame timestamp], [[frame hands] count],
          [[frame fingers] count], [[frame tools] count], [[frame gestures:nil] count]);
}
*/
- (NSArray*)recordFrameForKeyCode:(int)keyCode
{
    // Get the most recent frame and report some basic information
    LeapFrame *frame = [self.controller frame:0];
    /*
    NSLog(@"Frame id: %lld, timestamp: %lld, hands: %ld, fingers: %ld",
          [frame id], [frame timestamp], [[frame hands] count],
          [[frame fingers] count]);
     */

    // Record data about the frame.
    NSData *serializedFrame = [frame serialize];
    int64_t frameTimestamp = frame.timestamp;
    NSArray *images = frame.images;

    NSMutableArray *leapMotionFrameDatum = [[NSMutableArray alloc] initWithArray:images copyItems:NO];

    for (LeapImage *image in images) {
        NSData *imageData = [[NSData alloc] initWithBytesNoCopy:(void *) image.data length:image.width * image.height deallocator:^(void * _Nonnull bytes, NSUInteger length) {}];

        LeapMotionFrameData *frameData = [[LeapMotionFrameData alloc] initWithImageData:imageData andSerializedFrameData:serializedFrame andKeyCode:keyCode];

        [leapMotionFrameDatum addObject:frameData];
    }

    LeapHand *leftHand = frame.hands.leftmost;
    LeapHand *rightHand = frame.hands.rightmost;

    return [[NSArray alloc] initWithArray:leapMotionFrameDatum copyItems:NO];
}

@end
