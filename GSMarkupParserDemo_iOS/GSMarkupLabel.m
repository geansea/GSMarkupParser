//
//  GSMarkupLabel.m
//  GSMarkupParser
//
//  Created by geansea on 2017/8/15.
//
//

#import "GSMarkupLabel.h"
#import "GSMarkupParser.h"

@protocol QRMarkupAttachmentDelegate <NSObject>

- (void)attachmentChanged;

@end

@interface QRMarkupAttachment : NSTextAttachment

@property (nonatomic, copy)   NSString *imageUrl;
@property (nonatomic, weak)   id<QRMarkupAttachmentDelegate> delegate;

@end

@implementation QRMarkupAttachment

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = [imageUrl copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
            [self.delegate attachmentChanged];
        });
    });
}

- (CGRect)attachmentBoundsForTextContainer:(nullable NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    CGSize size = self.bounds.size;
    CGFloat lineWidth = CGRectGetWidth(lineFrag);
    if (size.width > lineWidth) {
        size.height = ceil(lineWidth * size.height / size.width);
        size.width = lineWidth;
    }
    return CGRectMake(0, 0, size.width, size.height);
}

@end

@interface GSMarkupLabel () <QRMarkupAttachmentDelegate>

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
        QRMarkupAttachment *attachment = [[QRMarkupAttachment alloc] init];
        attachment.image = nil;
        attachment.bounds = CGRectMake(0, 0, width, height);
        attachment.imageUrl = imageUrl;
        attachment.delegate = self;
        return attachment;
    }];
}

- (void)attachmentChanged {
    [self setNeedsDisplay];
}

@end
