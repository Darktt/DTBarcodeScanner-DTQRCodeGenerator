//
//  DTFadeView.m
//
//  Created by Darktt on 15/6/11.
//  Copyright (c) 2015年 Darktt Personal Company. All rights reserved.
//

#import "DTFadeView.h"

@interface DTFadeView ()

@end

@implementation DTFadeView

+ (instancetype)fadeViewWithFrame:(CGRect)frame
{
    DTFadeView *view = [[DTFadeView alloc] initWithFrame:frame];
    
    return [view autorelease];
}

+ (instancetype)fadeViewInView:(UIView *)superView withTag:(NSInteger)tag
{
    DTFadeView *fadeView = (DTFadeView *)[superView viewWithTag:tag];
    
    if (![fadeView isKindOfClass:[self class]]) {
        NSLog(@"%s [%d] : FadeView not found.", __func__, __LINE__);
        
        return nil;
    }
    
    return fadeView;
}

- (instancetype)init
{
    self = [super init];
    if (self == nil) return nil;
    
    [self setDuration:0.25f];
    [self setDelay:0.0f];
    
    return self;
}

- (void)fadeIn
{
    DTFadFinishBlock finishHandler = ^(DTFadeView *view, BOOL finished) {
        [view removeFromSuperview];
    };
    
    [self fadeInWithFinishHandler:finishHandler];
}

- (void)fadeInWithFinishHandler:(DTFadFinishBlock)finishHandler
{
    [self setAlpha:0.0f];
    
    void (^animations) (void) = ^{
        [self setAlpha:1.0f];
    };
    
    void (^completion) (BOOL finished) = ^(BOOL finished) {
        if (finishHandler != nil) finishHandler(self, finished);
    };
    
    [UIView animateWithDuration:self.duration delay:self.delay options:UIViewAnimationOptionCurveLinear animations:animations completion:completion];
}

- (void)fadeOut
{
    DTFadFinishBlock finishHandler = ^(DTFadeView *view, BOOL finished) {
        [view removeFromSuperview];
    };
    
    [self fadeOutWithFinishHandler:finishHandler];
}

- (void)fadeOutWithFinishHandler:(DTFadFinishBlock)finishHandler
{
    [self setAlpha:1.0f];
    
    void (^animations) (void) = ^{
        [self setAlpha:0.0f];
    };
    
    void (^completion) (BOOL finished) = ^(BOOL finished) {
        if (finishHandler != nil) finishHandler(self, finished);
    };
    
    [UIView animateWithDuration:self.duration delay:self.delay options:UIViewAnimationOptionCurveLinear animations:animations completion:completion];
}

@end
