//
//  DTQRCodeGenerator.h
//
//  Created by Darktt on 15/6/9.
//  Copyright (c) 2015 Darktt Personal Company. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, DTQRCodeCorrectionLevel) {
    DTQRCodeCorrectionLevelLow = 0,
    DTQRCodeCorrectionLevelMediumLow,
    DTQRCodeCorrectionLevelMediumHeigh,
    DTQRCodeCorrectionLevelHeigh
};

NS_ASSUME_NONNULL_BEGIN
@interface DTQRCodeGenerator : NSObject

@property (assign) CGSize perferredSize;

+ (instancetype)QRCodeGeneratorWithString:(NSString *)string correctionLevel:(DTQRCodeCorrectionLevel)level;

/** data The data need convert using the NSISOLatin1StringEncoding string. */
+ (instancetype)QRCodeGeneratorWithData:(NSData *)data correctionLevel:(DTQRCodeCorrectionLevel)level;

- (instancetype)initWithString:(NSString *)string correctionLevel:(DTQRCodeCorrectionLevel)level;

/** data The data need convert using the NSISOLatin1StringEncoding string. */
- (instancetype)initWithData:(NSData *)data correctionLevel:(DTQRCodeCorrectionLevel)level;

- (void)setForegroundColor:(UIColor *)foregroundcolor backgeoundColor:(UIColor *)backgroundColor;

- (UIImage *)outputImage;

@end
NS_ASSUME_NONNULL_END