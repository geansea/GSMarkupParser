//
//  GSMarkupParser.h
//  GSMarkupParser
//
//  Created by geansea on 2017/5/10.
//
//

#import <Foundation/Foundation.h>

@class NSTextAttachment;

typedef NSTextAttachment * (^AttachmentGenerator)(NSString *);

@interface GSMarkupParser : NSObject

+ (NSAttributedString *)attributedStringFromMarkupText:(NSString *)text;

- (instancetype)initWithMarkupText:(NSString *)text;
- (NSAttributedString *)attributedString;
- (NSAttributedString *)attributedStringWithAttachmentGenerator:(AttachmentGenerator)generator;

@end
