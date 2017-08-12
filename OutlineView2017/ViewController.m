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

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Feeds" ofType:@"plist"];
    if (filePath) {
        self.feeds = [Feed feedList:filePath];
        NSLog(@"feeds: %@", self.feeds);
    }
}

#pragma mark - Actions

- (IBAction)doubleClickedItem:(NSOutlineView *)sender
{
    Feed *item = [sender itemAtRow:[sender clickedRow]];
    if ([item isKindOfClass:[Feed class]]) {
        if ([sender isItemExpanded:item]) {
            [sender collapseItem:item];
        } else {
            [sender expandItem:item];
        }
    }
}

#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if ([item isKindOfClass:[Feed class]]) {
        NSLog(@"feed.children.count");
        Feed *feed = (Feed *)item;
        return feed.children.count;
    } else {
        NSLog(@"self.feeds.count");
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
    if ([item isKindOfClass:[Feed class]]) {
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
        if ([tableColumn.identifier isEqualToString:@"DateColumn"]) {
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"DateCell" owner:self];
            NSTextField *textField = view.textField;
            if (textField) {
                textField.stringValue = @"";
                [textField sizeToFit];
            }
        } else {
            view = (NSTableCellView *)[outlineView makeViewWithIdentifier:@"FeedCell" owner:self];
            NSTextField *textField = view.textField;
            if (textField) {
                textField.stringValue = feed.name;
                [textField sizeToFit];
            }
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


- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if (![notification.object isKindOfClass:[NSOutlineView class]]) {
        return;
    }
    NSOutlineView *outlineView = (NSOutlineView *)notification.object;
    NSInteger selectedIndex = outlineView.selectedRow;
    FeedItem *feedItem = [outlineView itemAtRow:selectedIndex];
    if (![feedItem isKindOfClass:[FeedItem class]]) {
        return;
    }
    if (feedItem) {
        NSURL *url = [NSURL URLWithString:feedItem.url];
        if (url) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
}

#pragma mark - Keyboard Handling

- (void)keyDown:(NSEvent *)event
{
    [self interpretKeyEvents:[NSArray arrayWithObject:event]];
}

- (void)deleteBackward:(id)sender
{
    NSLog(@"delete key detected");
    
    NSUInteger selectedRow = self.outlineView.selectedRow;
    if (selectedRow == -1) {
        return;
    }
    
    [self.outlineView beginUpdates];
    
    id item = [self.outlineView itemAtRow:selectedRow];
    if ([item isKindOfClass:[Feed class]]) {
        Feed *feed = (Feed *)item;
        NSUInteger index = [self.feeds indexOfObjectPassingTest:^BOOL(Feed * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [feed.name isEqualToString:obj.name];
        }];
        if (index != NSNotFound) {
            [self.feeds removeObjectAtIndex:index];
            [self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] inParent:nil withAnimation:NSTableViewAnimationSlideLeft];
        }
    } else if ([item isKindOfClass:[FeedItem class]]) {
        FeedItem *feedItem = (FeedItem *)item;
        for (Feed *feed in self.feeds) {
            NSUInteger index = [feed.children indexOfObjectPassingTest:^BOOL(FeedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [feedItem.title isEqualToString:obj.title];
                
            }];
            if (index != NSNotFound) {
                [feed.children removeObjectAtIndex:index];
                [self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:feed withAnimation:NSTableViewAnimationSlideLeft];
            }
        }
    }
    
    [self.outlineView endUpdates];
}

@end





















