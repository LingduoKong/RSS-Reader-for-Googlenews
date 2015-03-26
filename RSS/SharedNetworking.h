//
//  SharedNetworking.h
//  RSS
//
//  Created by Lingduo Kong on 2/14/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface SharedNetworking : NSObject
+ (id)sharedSharedNetworking;
- (id)init;
-(void)getRSSForURL:(NSString*)url
            success:(void (^)(NSMutableDictionary *array, NSError *error))successCompletion
            failure:(void (^)(void))failureCompletion;
-(bool)isNetworkActive ;
@property BOOL flag;

@end
