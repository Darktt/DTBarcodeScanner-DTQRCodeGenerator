//
//  DTQRCodeGenerator.m
//  CueME
//
//  Created by Darktt on 15/6/9.
//  Copyright © 2015 Darktt Personal Company. All rights reserved.
//

#import "DTQRCodeGenerator.h"

@import CoreImage;

@interface DTQRCodeGenerator ()
{
    NSData *_inputData;
    DTQRCodeCorrectionLevel _correctionLevel;
    UIColor *_foregroundColor;
    UIColor *_backgroundColor;
    
    BOOL _hasChangeColor;
}

@end

@implementation DTQRCodeGenerator

+ (instancetype)QRCodeGeneratorWithString:(NSString *)string correctionLevel:(DTQRCodeCorrectionLevel)level
{
    return [[[self alloc] initWithString:string correctionLevel:level] autorelease];
}

+ (instancetype)QRCodeGeneratorWithData:(NSData *)data correctionLevel:(DTQRCodeCorrectionLevel)level
{
    return [[[self alloc] initWithData:data correctionLevel:level] autorelease];
}

- (instancetype)initWithString:(NSString *)string correctionLevel:(DTQRCodeCorrectionLevel)level
{
    NSData *inputData = [string dataUsingEncoding:NSISOLatin1StringEncoding];
    
    return [self initWithData:inputData correctionLevel:level];
}

- (instancetype)initWithData:(NSData *)data correctionLevel:(DTQRCodeCorrectionLevel)level
{
    self = [super init];
    
    if (self == nil) return nil;
    
    _inputData = [[NSData alloc] initWithData:data];
    _correctionLevel = level;
    
    _foregroundColor = [[UIColor blackColor] retain];
    _backgroundColor = [[UIColor whiteColor] retain];
    _hasChangeColor = NO;
    
    return self;
}

- (void)dealloc
{
    [_inputData release];
    
    [_foregroundColor release];
    [_backgroundColor release];
    
    [super dealloc];
}

- (void)setForegroundColor:(UIColor *)foregroundcolor backgeoundColor:(UIColor *)backgroundColor
{
    _hasChangeColor = YES;
    
    [_foregroundColor release];
    _foregroundColor = [foregroundcolor retain];
    
    [_backgroundColor release];
    _backgroundColor = [backgroundColor retain];
}

- (UIImage *)outputImage
{
    CIImage *QRCodeImage = [self generatorQRCodeImage];
    UIImage *drawImage = nil;
    
    if (_hasChangeColor) {
        CIImage *colorChangedImage = [self changeImageColorWithImage:QRCodeImage];
        drawImage = [UIImage imageWithCIImage:colorChangedImage];
    } else {
        drawImage = [UIImage imageWithCIImage:QRCodeImage];
    }
    
    CGRect drawRect = (CGRect) {
        .size = self.perferredSize
    };
    
    UIGraphicsBeginImageContextWithOptions(self.perferredSize, YES, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    [drawImage drawInRect:drawRect];
    
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return drawnImage;
}

#pragma mark - Private Methods

- (NSString *)stringFromCorrectionLevel
{
    NSString *correntionLevelString = nil;
    
    switch (_correctionLevel) {
        case DTQRCodeCorrectionLevelLow:
            correntionLevelString = @"L";
            break;
            
        case DTQRCodeCorrectionLevelMediumLow:
            correntionLevelString = @"M";
            break;
            
        case DTQRCodeCorrectionLevelMediumHeigh:
            correntionLevelString = @"Q";
            break;
            
        case DTQRCodeCorrectionLevelHeigh:
            correntionLevelString = @"H";
            break;
        
        default:
            break;
    }
    
    return correntionLevelString;
}

- (CIImage *)generatorQRCodeImage
{
    NSString *correntionLevelString = [self stringFromCorrectionLevel];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:_inputData forKey:@"inputMessage"];
    [filter setValue:correntionLevelString forKey:@"inputCorrectionLevel"];
    
    return filter.outputImage;
}

- (CIImage *)changeImageColorWithImage:(CIImage *)image
{
    CIColor *color1 = [CIColor colorWithCGColor:_foregroundColor.CGColor];
    CIColor *color2 = [CIColor colorWithCGColor:_backgroundColor.CGColor];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
    [filter setValue:image forKey:@"inputImage"];
    [filter setValue:color1 forKey:@"inputColor0"];
    [filter setValue:color2 forKey:@"inputColor1"];
    
    return filter.outputImage;
}

@end
