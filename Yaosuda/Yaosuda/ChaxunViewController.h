//
//  ChaxunViewController.h
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassTrendValueDelegate.h"

@interface ChaxunViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PassTrendValueDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end
