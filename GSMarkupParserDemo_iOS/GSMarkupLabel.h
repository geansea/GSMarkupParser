//
//  GSMarkupLabel.h
//  GSMarkupParser
//
//  Created by geansea on 2017/8/15.
//
//

#import <UIKit/UIKit.h>

@interface GSMarkupLabel : UITextView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setMarkupText:(NSString *)markupText;

@end
