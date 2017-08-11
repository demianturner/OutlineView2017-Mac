//
//  Feed.m
//  OutlineView2017
//
//  Created by Demian Turner on 11/08/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import "Feed.h"
#import "FeedItem.h"

@implementation Feed

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
        _children = [NSMutableArray array];
    }
    return self;
}

+ (NSMutableArray<Feed *> *)feedList:(NSString *)fileName
{
    NSMutableArray<Feed *> *feeds = [NSMutableArray array];
    NSDictionary *feedList = (NSDictionary *)[NSArray arrayWithContentsOfFile:fileName];
    for (NSDictionary *feedItems in feedList) {
        Feed *feed = [[Feed alloc] initWithName:feedItems[@"name"]];
        NSArray<NSDictionary *> *items = (NSArray<NSDictionary *> *)feedItems[@"items"];
        for (NSDictionary *dict in items) {
            FeedItem *item = [[FeedItem alloc] initWithDictionary:dict];
            [feed.children addObject:item];
        }
        [feeds addObject:feed];
    }
    return feeds; // po ((Feed *)feeds[0]).children
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@; children: %lu", self.name, (unsigned long)self.children.count];
}


@end
