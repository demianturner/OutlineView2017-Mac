//
//  FeedItem.h
//  OutlineView2017
//
//  Created by Demian Turner on 11/08/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedItem : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *publishingDate;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
