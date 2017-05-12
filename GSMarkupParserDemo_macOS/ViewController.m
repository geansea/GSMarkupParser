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
        @"change <c hex=\"864\">text</c> <c hex=\"CC88EEFF\">color</c>",
        @"support <c hex=\"486\"><u>underline</u></c>",
        @"support <s hex=\"800\">strike</s> <s>through</s>",
        @"add <shadow x=\"2\" y=\"-1\" blur=\"2\">shadow</shadow>",
        @"move <base move=\"-2\"><font size=\"24\">baseline</font></base> to align middle",
        @"use <a link=\"https://github.com\"><c hex=\"24f\">link</c></a>",
        @"add image <img link=\"@\" w=\"16\" h=\"16\" /> from bundle",
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
