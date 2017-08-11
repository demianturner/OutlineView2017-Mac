//
//  ViewController.m
//  OutlineView2017
//
//  Created by Demian Turner on 11/08/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController() <NSOutlineViewDelegate, NSOutlineViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;

    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Feeds" ofType:@"plist"];
    self.feeds = [Feed feedList:filePath];
}


//- (void)setRepresentedObject:(id)representedObject {
//    [super setRepresentedObject:representedObject];
//
//    // Update the view, if already loaded.
//}

#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    Feed *feed = (Feed *)item;
    if (feed) {
        return feed.children.count;
    } else {
        return self.feeds.count;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    Feed *feed = (Feed *)item;
    if (feed) {
        return feed.children[index];
    } else {
        return self.feeds[index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[Feed class]]){
        Feed *feed = (Feed *)item;
        return feed.children.count > 0;
    } else {
        return NO;
    }        
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *view;
    
    if ([item isKindOfClass:[Feed class]]){
        Feed *feed = (Feed *)item;
        view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"FeedCell" owner:self];
        NSTextField *textField = view.textField;
        if (textField) {
            textField.stringValue = feed.name;
            [textField sizeToFit];
        }
    } else if ([item isKindOfClass:[FeedItem class]]) {
        FeedItem *feedItem = (FeedItem *)item;
        if ([tableColumn.identifier isEqualToString:@"DateColumn"]) {
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"DateCell" owner:self];
            NSTextField *textField = view.textField;
            if (textField) {
                textField.stringValue = [self.dateFormatter stringFromDate:feedItem.publishingDate];
                [textField sizeToFit];
            }
        } else {
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"FeedItemCell" owner:self];
            NSTextField *textField = view.textField;
            if (textField) {
                textField.stringValue = feedItem.title;
                [textField sizeToFit];
            }
        }
    }
    return view;
}

@end
