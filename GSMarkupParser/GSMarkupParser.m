//
//  GSMarkupParser.m
//  GSMarkupParser
//
//  Created by geansea on 2017/5/10.
//
//

#import "GSMarkupParser.h"

// Keys for dictionary
NSString * const GSSpanDictNameKey      = @"_name";
NSString * const GSSpanDictRangeKey     = @"_range";

NSString * const GSSpanString_Para      = @"p";
NSString * const GSSpanString_Font      = @"font";
NSString * const GSSpanString_Size      = @"size";
NSString * const GSSpanString_Name      = @"name";
NSString * const GSSpanString_Bold      = @"b";
NSString * const GSSpanString_Italic    = @"i";
NSString * const GSSpanString_Color     = @"c";
NSString * const GSSpanString_Hex       = @"hex";
NSString * const GSSpanString_Underline = @"u";
NSString * const GSSpanString_Strike    = @"s";
NSString * const GSSpanString_Shadow    = @"shadow";
NSString * const GSSpanString_X         = @"x";
NSString * const GSSpanString_Y         = @"y";
NSString * const GSSpanString_Blur      = @"blur";
NSString * const GSSpanString_Base      = @"base";
NSString * const GSSpanString_Move      = @"move";
NSString * const GSSpanString_Ancher    = @"a";
NSString * const GSSpanString_Link      = @"link";
NSString * const GSSpanString_Image     = @"img";
NSString * const GSSpanString_Bundle    = @"@";
NSString * const GSSpanString_Width     = @"w";
NSString * const GSSpanString_Height    = @"h";

// Compatibility
#if TARGET_OS_IOS

#import <UIKit/UIKit.h>
@compatibility_alias GSColor UIColor;
@compatibility_alias GSImage UIImage;
@compatibility_alias GSFont UIFont;
@compatibility_alias GSFontDescriptor UIFontDescriptor;
#define GSFontDescriptorTraitItalic UIFontDescriptorTraitItalic
#define GSFontDescriptorTraitBold UIFontDescriptorTraitBold
#define GSRectMake(x, y, w, h) CGRectMake(x, y, w, h)
#define GSSizeMake(w, h) CGSizeMake(w, h)

#else

#import <AppKit/AppKit.h>
@compatibility_alias GSColor NSColor;
@compatibility_alias GSImage NSImage;
@compatibility_alias GSFont NSFont;
@compatibility_alias GSFontDescriptor NSFontDescriptor;
#define GSFontDescriptorTraitItalic NSFontItalicTrait
#define GSFontDescriptorTraitBold NSFontBoldTrait
#define GSRectMake(x, y, w, h) NSMakeRect(x, y, w, h)
#define GSSizeMake(w, h) NSMakeSize(w, h)

#endif

typedef NSMutableDictionary<NSString *, NSString *> SpanDict;

@interface GSMarkupParser () <NSXMLParserDelegate>

@property (strong) NSMutableString *string;
@property (strong) NSMutableArray<SpanDict *> *spans;
@property (strong) NSMutableArray<SpanDict *> *spanStack;

- (void)parseText:(NSString *)text;
// Font
+ (BOOL)fontIsBold:(GSFont *)font;
+ (BOOL)fontIsItalic:(GSFont *)font;
+ (GSFont *)converFontToBold:(GSFont *)font;
+ (GSFont *)converFontToItalic:(GSFont *)font;
// Color
+ (GSColor *)colorFromHex:(NSString *)hex;

@end

@implementation GSMarkupParser

+ (NSAttributedString *)attributedStringFromMarkupText:(NSString *)text {
    GSMarkupParser *parser = [[GSMarkupParser alloc] initWithMarkupText:text];
    return [parser attributedString];
}

- (instancetype)initWithMarkupText:(NSString *)text {
    if (self = [super init]) {
        self.string = [NSMutableString string];
        self.spans = [NSMutableArray array];
        self.spanStack = [NSMutableArray array];
        [self parseText:text];
    }
    return self;
}

- (NSAttributedString *)attributedString {
    //
    // Default attributes
    //
    NSDictionary<NSString *, id> *defaultAttributes = @{
                                                        NSFontAttributeName : [GSFont systemFontOfSize:17],
                                                        NSForegroundColorAttributeName : [GSColor blackColor],
                                                        };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_string attributes:defaultAttributes];
    //
    // Span attributes
    //
    for (SpanDict *span in _spans) {
        NSString *name = span[GSSpanDictNameKey];
        NSRange range = NSRangeFromString(span[GSSpanDictRangeKey]);
        if (0 == range.length) {
            continue;
        }
        if ([name isEqualToString:GSSpanString_Font]) {
            GSFont *font = [attributedString attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
            CGFloat fontSize = [span[GSSpanString_Size] floatValue];
            if (fontSize <= 0) {
                fontSize = font.pointSize;
            }
            NSString *fontName = span[GSSpanString_Name];
            if (0 == fontName.length) {
                fontName = font.fontName;
            }
            [attributedString addAttribute:NSFontAttributeName value:[GSFont fontWithName:fontName size:fontSize] range:range];
        } else if ([name isEqualToString:GSSpanString_Bold]) {
            GSFont *font = [attributedString attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
            GSFont *boldFont = [GSMarkupParser converFontToBold:font];
            if (boldFont) {
                [attributedString addAttribute:NSFontAttributeName value:boldFont range:range];
            } else {
                [attributedString addAttribute:NSStrokeWidthAttributeName value:@(-3) range:range];
            }
        } else if ([name isEqualToString:GSSpanString_Italic]) {
            GSFont *font = [attributedString attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
            GSFont *italicFont = [GSMarkupParser converFontToItalic:font];
            if (italicFont) {
                [attributedString addAttribute:NSFontAttributeName value:italicFont range:range];
            } else {
                [attributedString addAttribute:NSObliquenessAttributeName value:@(0.2) range:range];
            }
        } else if ([name isEqualToString:GSSpanString_Color]) {
            NSString *colorHex = span[GSSpanString_Hex];
            GSColor *color = [GSMarkupParser colorFromHex:colorHex];
            if (color) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
            }
        } else if ([name isEqualToString:GSSpanString_Underline]) {
            NSString *colorHex = span[GSSpanString_Hex];
            GSColor *color = [GSMarkupParser colorFromHex:colorHex];
            if (!color) {
                color = [attributedString attribute:NSForegroundColorAttributeName atIndex:range.location effectiveRange:NULL];
            }
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
            [attributedString addAttribute:NSUnderlineColorAttributeName value:color range:range];
        } else if ([name isEqualToString:GSSpanString_Strike]) {
            NSString *colorHex = span[GSSpanString_Hex];
            GSColor *color = [GSMarkupParser colorFromHex:colorHex];
            if (!color) {
                color = [attributedString attribute:NSForegroundColorAttributeName atIndex:range.location effectiveRange:NULL];
            }
            [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
            [attributedString addAttribute:NSStrikethroughColorAttributeName value:color range:range];
        } else if ([name isEqualToString:GSSpanString_Shadow]) {
            NSString *colorHex = span[GSSpanString_Hex];
            GSColor *color = [GSMarkupParser colorFromHex:colorHex];
            if (!color) {
                color = [attributedString attribute:NSForegroundColorAttributeName atIndex:range.location effectiveRange:NULL];
                color = [color colorWithAlphaComponent:0.33];
            }
            CGFloat x = [span[GSSpanString_X] floatValue];
            CGFloat y = [span[GSSpanString_Y] floatValue];
            CGFloat blur = [span[GSSpanString_Blur] floatValue];
            NSShadow *shadow = [[NSShadow alloc] init];
            shadow.shadowOffset = GSSizeMake(x, y);
            shadow.shadowBlurRadius = blur;
            shadow.shadowColor = color;
            [attributedString addAttribute:NSShadowAttributeName value:shadow range:range];
        } else if ([name isEqualToString:GSSpanString_Base]) {
            CGFloat move = [span[GSSpanString_Move] floatValue];
            [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(move) range:range];
        } else if ([name isEqualToString:GSSpanString_Ancher]) {
            NSString *link = span[GSSpanString_Link];
            [attributedString addAttribute:NSLinkAttributeName value:link range:range];
        } else if ([name isEqualToString:GSSpanString_Image]) {
            NSString *link = span[GSSpanString_Link];
            CGFloat width = [span[GSSpanString_Width] floatValue];
            CGFloat height = [span[GSSpanString_Height] floatValue];
            if ([link hasPrefix:GSSpanString_Bundle]) {
                NSString *imageName = [link substringFromIndex:GSSpanString_Bundle.length];
                GSImage *image = [GSImage imageNamed:imageName];
                if (image && image.size.width > 0 && image.size.height > 0) {
                    if (width <= 0 && height <= 0) {
                        width = image.size.width;
                        height = image.size.height;
                    } else if (width <= 0) {
                        width = height * image.size.width / image.size.height;
                    } else if (height <= 0) {
                        height = width * image.size.height / image.size.width;
                    }
                    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                    attachment.image = image;
                    attachment.bounds = GSRectMake(0, 0, width, height);
                    [attributedString addAttribute:NSAttachmentAttributeName value:attachment range:range];
                }
            } else if (link.length > 0 && width > 0 && height > 0) {
                // Additional: Support web image
            }
        }
    }
    return attributedString;
}

#pragma mark - Private

- (void)parseText:(NSString *)text {
    NSString *xmlText = [NSString stringWithFormat:@"<%@>%@</%@>", GSSpanString_Para, text, GSSpanString_Para];
    NSData *xmlData = [xmlText dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    parser.shouldProcessNamespaces = NO;
    parser.shouldReportNamespacePrefixes = NO;
    parser.shouldResolveExternalEntities = NO;
    parser.delegate = self;
    if (![parser parse]) {
        NSLog(@"error occures");
    }
}

#pragma mark Font

+ (BOOL)fontIsBold:(GSFont *)font {
    return ((font.fontDescriptor.symbolicTraits & GSFontDescriptorTraitBold) != 0);
}

+ (BOOL)fontIsItalic:(GSFont *)font {
    return ((font.fontDescriptor.symbolicTraits & GSFontDescriptorTraitItalic) != 0);
}

+ (GSFont *)converFontToBold:(GSFont *)font {
    if ([GSMarkupParser fontIsBold:font]) {
        return font;
    }
    GSFontDescriptor *boldDescriptor = [font.fontDescriptor fontDescriptorWithSymbolicTraits:GSFontDescriptorTraitBold];
    GSFont *boldFont = [GSFont fontWithDescriptor:boldDescriptor size:font.pointSize];
    if ([GSMarkupParser fontIsBold:boldFont]) {
        return boldFont;
    }
    return nil;
}

+ (GSFont *)converFontToItalic:(GSFont *)font {
    if ([GSMarkupParser fontIsItalic:font]) {
        return font;
    }
    GSFontDescriptor *italicDescriptor = [font.fontDescriptor fontDescriptorWithSymbolicTraits:GSFontDescriptorTraitItalic];
    GSFont *italicFont = [GSFont fontWithDescriptor:italicDescriptor size:font.pointSize];
    if ([GSMarkupParser fontIsItalic:italicFont]) {
        return italicFont;
    }
    return nil;
}

#pragma mark Color

+ (GSColor *)colorFromHex:(NSString *)hex {
    unsigned hexValue = 0;
    if (![[NSScanner scannerWithString:hex] scanHexInt:&hexValue]) {
        return nil;
    }
    CGFloat comps[4] = { 1, 0, 0, 0 };
    switch (hex.length) {
        case 4:
            comps[0] = (CGFloat)((hexValue >> 12) & 0x0F) / 0x0F;
        case 3:
            comps[1] = (CGFloat)((hexValue >> 8)  & 0x0F) / 0x0F;
            comps[2] = (CGFloat)((hexValue >> 4)  & 0x0F) / 0x0F;
            comps[3] = (CGFloat)( hexValue        & 0x0F) / 0x0F;
            break;
        case 8:
            comps[0] = (CGFloat)((hexValue >> 24) & 0xFF) / 0xFF;
        case 6:
            comps[1] = (CGFloat)((hexValue >> 16) & 0xFF) / 0xFF;
            comps[2] = (CGFloat)((hexValue >> 8)  & 0xFF) / 0xFF;
            comps[3] = (CGFloat)( hexValue        & 0xFF) / 0xFF;
            break;
        default:
            break;
    }
    return [GSColor colorWithRed:comps[1] green:comps[2] blue:comps[3] alpha:comps[0]];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    SpanDict *spanDict = [SpanDict dictionary];
    // name
    [spanDict setObject:elementName forKey:GSSpanDictNameKey];
    // range
    NSRange range = NSMakeRange(_string.length, 0);
    [spanDict setObject:NSStringFromRange(range) forKey:GSSpanDictRangeKey];
    // attributes
    [spanDict addEntriesFromDictionary:attributeDict];
    // Push
    [_spans addObject:spanDict];
    [_spanStack addObject:spanDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    SpanDict *currentSpan = _spanStack.lastObject;
    if (currentSpan) {
        NSAssert([elementName isEqualToString:currentSpan[GSSpanDictNameKey]], @"End tag </%@> not match tag <%@>", elementName, currentSpan[GSSpanDictNameKey]);
        NSRange range = NSRangeFromString(currentSpan[GSSpanDictRangeKey]);
        range.length = _string.length - range.location;
        [currentSpan setObject:NSStringFromRange(range) forKey:GSSpanDictRangeKey];
    }
    // Pop
    [_spanStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    SpanDict *currentSpan = _spanStack.lastObject;
    if ([currentSpan[GSSpanDictNameKey] isEqualToString:GSSpanString_Image]) {
        
        return;
    }
    [_string appendString:string];
}

@end
