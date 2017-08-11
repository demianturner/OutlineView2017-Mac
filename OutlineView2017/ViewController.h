//
//  ViewController.h
//  OutlineView2017
//
//  Created by Demian Turner on 11/08/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "Feed.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet WKWebView *webView;
@property (nonatomic, strong) NSMutableArray<Feed *> *feeds;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

