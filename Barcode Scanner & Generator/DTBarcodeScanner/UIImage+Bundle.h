//
//  UIImage+Bundle.h
//
//  Created by Darktt on 15/7/2.
//  Copyright (c) 2015年 Darktt Personal Company. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@interface UIImage (Bundle)

/**
 * @method imageNamed:inBundleName:
 *
 * @abstract Create image instance
 *
 * @param name Image resource name
 *
 * @param bundleName The bundle name, contains image resource file.
 */
+ (UIImage *)imageNamed:(NSString *)name inBundleName:(NSString *)bundleName;

@end
NS_ASSUME_NONNULL_END