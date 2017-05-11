//
//  ViewController.m
//  GSMarkupParserDemo_macOS
//
//  Created by geansea on 2017/5/11.
//
//

#import "ViewController.h"
#import "GSMarkupParser.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.markupTexts = @[
        @"the default font size is 16",
        @"change <font size=\"20\">font</font> size",
        @"use <font name=\"Palatino\">Palatino</font> font",
        @"support <b>bold</b> &amp; <i>italic</i>",
        @"use <font name=\"Palatino\"><b>Stroke</b></font> if no bold",
        @"use <font name=\"Palatino\"><i>Oblique</i></font> if no italic",
        @"&lt;b&gt; &amp; &lt;i&gt; need to be inside &lt;font&gt; for batter support",
        @"change <c hex=\"864\">text</c> color",
        @"support the <c hex=\"486\"><u>underline</u></c> color",
        @"support the <s hex=\"800\">strike</s> color",
    ];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - NSTableViewDataSource

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 48;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _markupTexts.count;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row >= _markupTexts.count) {
        return nil;
    }
    if ([tableColumn.identifier isEqualToString:@"Preview"]) {
        return [GSMarkupParser attributedStringFromMarkupText:_markupTexts[row]];
    }
    if ([tableColumn.identifier isEqualToString:@"Markup"]) {
        return _markupTexts[row];
    }
    return nil;
}


@end
