//
//  AVCaptureDevice+Device.h
//
//  Created by Darktt on 15/6/10.
//  Copyright © 2015 Darktt Personal Company. All rights reserved.
//

@import AVFoundation.AVCaptureDevice;

NS_ASSUME_NONNULL_BEGIN
@interface AVCaptureDevice (Device)

+ (BOOL)hasDeviceWithPosition:(AVCaptureDevicePosition)position NS_SWIFT_NAME(hasDevice(position:));

+ (instancetype)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position NS_SWIFT_NAME(device(mediaType:preferringPosition:));

@end
NS_ASSUME_NONNULL_END