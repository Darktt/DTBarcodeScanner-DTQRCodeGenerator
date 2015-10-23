//
//  AVCaptureDevice+Device.h
//
//  Created by Darktt on 15/6/10.
//  Copyright (c) 2015 Darktt Personal Company. All rights reserved.
//

@import AVFoundation.AVCaptureDevice;

NS_ASSUME_NONNULL_BEGIN
@interface AVCaptureDevice (Device)

+ (BOOL)hasDeviceWithPosition:(AVCaptureDevicePosition)position;

+ (instancetype)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position;

@end
NS_ASSUME_NONNULL_END