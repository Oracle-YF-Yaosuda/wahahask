//
//  QuerenViewController.h
//  Yaosuda
//
//  Created by suokun on 15/12/14.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuerenViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shouhuoren;
@property (weak, nonatomic) IBOutlet UILabel *yingfu;
@property (strong , nonatomic)NSString*meme;
@property (strong , nonatomic)NSString*xixi;
@property (strong , nonatomic)NSString*haha;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)fanhui:(id)sender;


@end
