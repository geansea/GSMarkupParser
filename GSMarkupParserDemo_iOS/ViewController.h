//
//  ViewController.h
//  GSMarkupParserDemo_iOS
//
//  Created by geansea on 2017/5/11.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (copy) NSArray<NSString *> *markupTexts;

@end

