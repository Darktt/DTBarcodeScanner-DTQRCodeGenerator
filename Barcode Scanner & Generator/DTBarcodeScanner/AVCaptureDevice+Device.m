//
//  AVCaptureDevice+Device.m
//
//  Created by Darktt on 15/6/10.
//  Copyright © 2015 Darktt Personal Company. All rights reserved.
//

@import AVFoundation;

#import "AVCaptureDevice+Device.h"

@implementation AVCaptureDevice (Device)

+ (BOOL)hasDeviceWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    BOOL hasDevice = NO;
    
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            hasDevice = YES;
            
            break;
        }
    }
    
    return hasDevice;
}

+ (instancetype)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            captureDevice = device;
            
            break;
        }
    }
    
    // When devices is only one, using that one.
    // (e.g. iPod touch 5th gen 8GB, that has front camera, hasn't back camera.)
    if (captureDevice == nil) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
    }
    
    return captureDevice;
}

@end
