//
//  ZizunViewController.h
//  Yaosuda
//
//  Created by oracle on 15/12/4.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZizunViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView *tableview;
- (IBAction)fanhui:(id)sender;


@end
