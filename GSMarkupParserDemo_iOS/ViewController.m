//
//  ViewController.m
//  GSMarkupParserDemo_iOS
//
//  Created by geansea on 2017/5/11.
//
//

#import "ViewController.h"
#import "GSMarkupParser.h"
#import "GSMarkupLabel.h"

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
        @"change <c hex=\"864\">text</c> <c hex=\"CC88EEFF\">color</c>",
        @"support <c hex=\"486\"><u>underline</u></c>",
        @"support <s hex=\"800\">strike</s> <s>through</s>",
        @"add <shadow x=\"2\" y=\"1\" blur=\"2\">shadow</shadow>",
        @"move <base move=\"-2\"><font size=\"24\">baseline</font></base> to align middle",
        @"use <a link=\"https://github.com\"><c hex=\"24f\">link</c></a>",
        @"add image <img link=\"@TestImage\" w=\"16\" h=\"16\" /> from bundle",
        @"add image <img link=\"http://cn.bing.com/s/cn/cn_logo_serp.png\" w=\"16\" h=\"16\" /> from web",
        @"support the <s><base move=\"0\">strike</base></s> on 10.3",
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
        cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        cell.textLabel.text = _markupTexts[indexPath.row / 2];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.attributedText = [GSMarkupParser attributedStringFromMarkupText:_markupTexts[indexPath.row / 2]];
    }
    return cell;
}

@end
