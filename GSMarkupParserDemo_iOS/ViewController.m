//
//  ViewController.m
//  GSMarkupParserDemo_iOS
//
//  Created by geansea on 2017/5/11.
//
//

#import "ViewController.h"
#import "GSMarkupParser.h"

@interface ViewController ()

@end

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _markupTexts.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSMarkupCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GSMarkupCell"];
    }
    cell.textLabel.numberOfLines = 0;
    if (indexPath.row >= _markupTexts.count * 2) {
        cell.textLabel.text = @"";
        return cell;
    }
    if (0 == indexPath.row % 2) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.attributedText = [GSMarkupParser attributedStringFromMarkupText:_markupTexts[indexPath.row / 2]];
    } else {
        cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        cell.textLabel.text = _markupTexts[indexPath.row / 2];
    }
    return cell;
}


@end
