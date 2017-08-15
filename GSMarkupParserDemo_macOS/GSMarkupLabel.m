//
//  GSMarkupLabel.m
//  GSMarkupParser
//
//  Created by geansea on 2017/8/15.
//
//

#import "GSMarkupLabel.h"

@implementation GSMarkupLabel

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect textContainer:nil]) {
        self.editable = NO;
    }
    return self;
}

- (void)setMarkupText:(NSString *)markupText {
    
}

@end
