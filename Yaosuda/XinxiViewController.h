//
//  XinxiViewController.h
//  Yaosuda
//
//  Created by suokun on 15/12/9.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "ViewController.h"

@interface XinxiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong , nonatomic) NSString*orderId;
@property (strong,nonatomic) NSString *orderType;
@property (strong,nonatomic) NSString *isGather;
@property (strong,nonatomic) NSString *isInvoice;
@property (strong,nonatomic) NSString *isNewRecord;
@property (strong,nonatomic) NSString *chuan1;
@property (strong,nonatomic) NSString *chuan2;
@property (strong,nonatomic) NSString *chuan3;
@property (strong,nonatomic) NSString *chuan4;
@property (strong,nonatomic) NSString *chuan5;
@property (strong,nonatomic) NSString *chuan6;
@property (strong,nonatomic) NSString *chuan7;
@property (strong,nonatomic) NSString *chuan8;
@property (strong,nonatomic) NSString *chuan9;
@end
