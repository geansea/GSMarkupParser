//
//  GSMarkupLabel.m
//  GSMarkupParser
//
//  Created by geansea on 2017/8/15.
//
//

#import "GSMarkupLabel.h"
#import "GSMarkupParser.h"

@protocol GSMarkupAttachmentDelegate <NSObject>

- (void)attachmentNeedsDisplay:(NSTextAttachment *)attachment;

@end

@interface GSMarkupAttachment : NSTextAttachment

@property (nonatomic, copy)   NSString *imageUrl;
@property (nonatomic, weak)   id<GSMarkupAttachmentDelegate> delegate;

@end

@implementation GSMarkupAttachment

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = [imageUrl copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
            [self.delegate attachmentNeedsDisplay:self];
        });
    });
}

@end

@interface GSMarkupLabel () <GSMarkupAttachmentDelegate>

@end

@implementation GSMarkupLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame textContainer:nil]) {
        self.editable = NO;
    }
    return self;
}

- (void)setMarkupText:(NSString *)markupText {
    GSMarkupParser *parser = [[GSMarkupParser alloc] initWithMarkupText:markupText];
    self.attributedText = [parser attributedStringWithAttachmentGenerator:^NSTextAttachment *(NSString *imageUrl, NSInteger width, NSInteger height) {
        GSMarkupAttachment *attachment = [[GSMarkupAttachment alloc] init];
        attachment.image = nil;
        attachment.bounds = CGRectMake(0, 0, width, height);
        attachment.imageUrl = imageUrl;
        attachment.delegate = self;
        return attachment;
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

#pragma mark - GSMarkupAttachmentDelegate

- (void)attachmentNeedsDisplay:(NSTextAttachment *)attachment {
    __block NSRange attachmentRange = NSMakeRange(0, 0);
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textStorage.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (attachment == value) {
            attachmentRange = range;
            *stop = YES;
        }
    }];
    [self.layoutManager invalidateDisplayForCharacterRange:attachmentRange];
}

@end
