//
//  UYLStyleController.m
//  First APP
//
//  Created by Lingduo Kong on 1/26/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//
#import "UYLStyleController.h"
#import <UIKit/UIKit.h>

@implementation UYLStyleController
+(void)applyStyle{
    
    UIColor *color = [UIColor colorWithRed:188/255.0f green:20.0f/255.0f blue:254/255.0f alpha:1.0];
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBarTintColor:color];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    [navigationBarAppearance setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"AmericanTypewriter-CondensedBold" size:30.0f], NSForegroundColorAttributeName:[UIColor whiteColor]}];    
    
}

@end
