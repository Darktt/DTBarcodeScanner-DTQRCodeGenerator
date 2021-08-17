//
//  UIImage+Bundle.m
//
//  Created by Darktt on 15/7/2.
//  Copyright © 2015 Darktt Personal Company. All rights reserved.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (UIImage *)imageNamed:(NSString *)name inBundleName:(NSString *)bundleName
{
    NSString *imageNamed = nil;
    
    if ([bundleName hasSuffix:@"bundle"]) {
        imageNamed = [NSString stringWithFormat:@"%@/%@", bundleName, name];
    } else {
        imageNamed = [NSString stringWithFormat:@"%@.bundle/%@", bundleName, name];
    }
    
    return [self imageNamed:imageNamed];
}

@end
