//
//  ViewController.h
//  GSMarkupParserDemo_macOS
//
//  Created by geansea on 2017/5/11.
//
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (copy) NSArray<NSString *> *markupTexts;

@end

