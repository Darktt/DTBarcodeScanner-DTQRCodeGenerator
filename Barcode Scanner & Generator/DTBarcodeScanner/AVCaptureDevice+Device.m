//
//  AVCaptureDevice+CaptureDevice.m
//
//  Created by Darktt on 15/12/1.
//  Copyright © 2015 Darktt Personal Company. All rights reserved.
//

#import "AVCaptureDevice+Device.h"

@import AVFoundation;

@implementation AVCaptureDevice (CaptureDevice)

+ (BOOL)hasDeviceWithPosition:(AVCaptureDevicePosition)position
{
    return [self hasWideAngleCameraWithPosition:position];
}

+ (BOOL)hasWideAngleCameraWithPosition:(AVCaptureDevicePosition)position
{
    if ([AVCaptureDeviceDiscoverySession respondsToSelector:@selector(discoverySessionWithDeviceTypes:mediaType:position:)]) {
        
        AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        
        return (discoverySession != nil);
    }
    
    // Remove deprecated message.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSArray<AVCaptureDevice *> *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    BOOL hasDevice = NO;
    
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            hasDevice = YES;
            
            break;
        }
    }
    
    return hasDevice;
    
#pragma clang diagnostic pop
}

+ (BOOL)hasTelephotoCameraWithPosition:(AVCaptureDevicePosition)position
{
    if (![AVCaptureDeviceDiscoverySession respondsToSelector:@selector(discoverySessionWithDeviceTypes:mediaType:position:)]) {
        
        return NO;
    }
    
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInTelephotoCamera] mediaType:AVMediaTypeVideo position:position];
    
    return (discoverySession != nil);
}

+ (BOOL)hasDuoCameraWithPosition:(AVCaptureDevicePosition)position
{
    if (![AVCaptureDeviceDiscoverySession respondsToSelector:@selector(discoverySessionWithDeviceTypes:mediaType:position:)]) {
        
        return NO;
    }
    
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInDuoCamera] mediaType:AVMediaTypeVideo position:position];
    
    return (discoverySession != nil);
}

+ (instancetype)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray<AVCaptureDevice *> *devices = nil;
    
    if ([AVCaptureDeviceDiscoverySession respondsToSelector:@selector(discoverySessionWithDeviceTypes:mediaType:position:)]) {
        
        AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        
        devices = discoverySession.devices;
    } else {
        
        // Remove deprecated message.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        devices = [AVCaptureDevice devicesWithMediaType:mediaType];
        
#pragma clang diagnostic pop
    }
    
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            captureDevice = device;
            
            break;
        }
    }
    
    // When devices is only one, using that one.
    // (e.g. iPod touch 5th gen 8GB, that has front camera, has not back camera.)
    if (captureDevice == nil) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
    }
    
    return captureDevice;
}

@end
