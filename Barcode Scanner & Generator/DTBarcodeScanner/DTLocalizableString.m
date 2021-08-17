//
//  DTLocalizableString.m
//
//  Created by Darktt on 15/7/2.
//  Copyright © 2015 Darktt Personal Company. All rights reserved.
//

#import "DTLocalizableString.h"

static NSBundle *currentBundle = nil;

NSString *const bundleName = @"DTBarcodeScanner";

NSString *DTLocalizableString(NSString *string, NSString *comment) {
    if (currentBundle == nil) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *bundlePath = [mainBundle pathForResource:bundleName ofType:@"bundle"];
        
        currentBundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    NSString *localizedString = [currentBundle localizedStringForKey:string value:@"" table:@"Localizable"];
    
    return localizedString;
}
