//
//  GSMarkupLabel.h
//  GSMarkupParser
//
//  Created by zhaiguanghe on 2017/8/15.
//
//

#import <Cocoa/Cocoa.h>

@interface GSMarkupLabel : NSTextView

- (instancetype)initWithFrame:(NSRect)frameRect;
- (void)setMarkupText:(NSString *)markupText;

@end
