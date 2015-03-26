//
//  SharedNetworking.m
//  RSS
//
//  Created by Lingduo Kong on 2/14/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "SharedNetworking.h"

@implementation SharedNetworking

// -----------------------------------------------------------------------------
#pragma mark - Initialization
// -----------------------------------------------------------------------------
+ (id)sharedSharedNetworking
{
    static dispatch_once_t pred;
    static SharedNetworking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if ( self = [super init] ) {
        
    }
    return self;
}

#pragma - Requests

-(void)getRSSForURL:(NSString*)url
                 success:(void (^)(NSMutableDictionary *array, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion
{
    if (![self isNetworkActive])return;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     
                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                     if (httpResp.statusCode == 200) {
                                         NSError *jsonError;
                                         NSMutableDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                         NSLog(@"DownloadeData successful");
                                         successCompletion(array,nil);
                                     }
                                     else {
                                         NSLog(@"Fail Not 200:");
                                         dispatch_async(dispatch_get_main_queue(), ^{
//                                             if (failureCompletion)
                                                 failureCompletion();
                                         });
                                     }
                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                 }] resume];
}

// -----------------------------------------------------------------------------
#pragma mark - isNetworkActive
// -----------------------------------------------------------------------------

-(bool)isNetworkActive {
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus networkStatus = [reach currentReachabilityStatus];
    if(networkStatus==NotReachable){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INTERNET ERROR" message:@"No internet available!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return false;
    }
    else return true;
}
@end
