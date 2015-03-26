//
//  ActiveIndicateView.m
//  RSS
//
//  Created by Lingduo Kong on 2/21/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "ActiveIndicateView.h"

@implementation ActiveIndicateView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _activityView=[[UIActivityIndicatorView alloc] init];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityView.backgroundColor = [UIColor grayColor];
    _activityView.tag = 100;
    _activityView.alpha = 0.5;
    _activityView.clipsToBounds = YES;
    _activityView.layer.cornerRadius = 10.0;
    [_activityView startAnimating];
    [self.superview addSubview:_activityView];
    _activityView.hidden = YES;
    
}

@end
