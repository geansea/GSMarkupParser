//
//  GSMarkupParser.h
//  GSMarkupParser
//
//  Created by geansea on 2017/5/10.
//
//

#import <Foundation/Foundation.h>

@interface GSMarkupParser : NSObject

+ (NSAttributedString *)attributedStringFromMarkupText:(NSString *)text;

- (instancetype)initWithMarkupText:(NSString *)text;
- (NSAttributedString *)attributedString;

@end
