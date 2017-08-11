//
//  FeedItem.m
//  OutlineView2017
//
//  Created by Demian Turner on 11/08/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _url = dict[@"url"];
        _title = dict[@"title"];
        _publishingDate = (NSDate *)dict[@"date"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"url: %@; title %@; publishingDate:%@", self.url, self.title, self.publishingDate];
}

@end
