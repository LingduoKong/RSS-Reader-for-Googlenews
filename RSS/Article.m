//
//  Article.m
//  RSS
//
//  Created by Lingduo Kong on 2/23/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "Article.h"

@implementation Article

- (void)encodeWithCoder:(NSCoder *)encoder {
    //[super encodeWithCoder: encoder];
    // if super conforms to NSCoding
    [encoder encodeObject:self.favourite forKey:@"favourite"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    //self = [super initWithCoder: decoder];
    // if super conforms to NSCoding
    self = [super init];
    self.favourite = [decoder decodeObjectForKey:@"favourite"];
    return self;
}

@end
