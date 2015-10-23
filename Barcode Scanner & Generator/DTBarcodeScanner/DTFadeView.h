//
//  DTFadeView.h
//
//  Created by Darktt on 15/6/11.
//  Copyright (c) 2015年 Darktt Personal Company. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@class DTFadeView;
typedef void (^DTFadFinishBlock) (DTFadeView *view, BOOL finished);

@interface DTFadeView : UIView

/** The time of animation duration. Default is 0.25 seconds. */
@property (assign) NSTimeInterval duration;

/** The amount of time (measured in seconds) to wait before beginning the animations. Default is 0 second. */
@property (assign) NSTimeInterval delay;

/** Create new fade view instance */
+ (instancetype)fadeViewWithFrame:(CGRect)frame;

/** Get indtance when exist in super view. */
+ (nullable DTFadeView *)fadeViewInView:(__kindof UIView *)superView withTag:(NSInteger)tag;

/** Fade in then dismiss. */
- (void)fadeIn;

/** Fade in with custom handler */
- (void)fadeInWithFinishHandler:(nullable DTFadFinishBlock)finishHandler;

/** Fade out then dismiss. */
- (void)fadeOut;

/** Fade out with custom handler */
- (void)fadeOutWithFinishHandler:(nullable DTFadFinishBlock)finishHandler;

@end
NS_ASSUME_NONNULL_END