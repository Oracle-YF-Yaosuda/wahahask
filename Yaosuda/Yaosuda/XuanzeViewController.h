//
//  XuanzeViewController.h
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassTrendValueDelegate.h"

@interface XuanzeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (retain , nonatomic) id<PassTrendValueDelegate>trendDelegate;

@end
