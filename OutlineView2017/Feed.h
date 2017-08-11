//
//  Feed.h
//  OutlineView2017
//
//  Created by Demian Turner on 11/08/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

@interface Feed : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray<FeedItem *> *children;

- (instancetype)initWithName:(NSString *)name;
+ (NSMutableArray<Feed *> *)feedList:(NSString *)fileName;

@end
