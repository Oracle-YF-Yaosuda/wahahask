//
//  XiadanViewController.m
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "XiadanViewController.h"
#import "Color+Hex.h"
#import "XiadanbianjiViewController.h"
#import "KehuViewController.h"

@interface XiadanViewController ()
{
    CGFloat width;
    CGFloat height;
    NSArray*jieshou;
    UITableViewCell *cell;
}

@end

@implementation XiadanViewController
-(void)passTrendValue:(NSArray *)values{
    
    NSString *path =[NSHomeDirectory() stringByAppendingString:@"/Documents/xiadanmingxi.plist"];
    NSFileManager*fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [values writeToFile:path atomically:YES];
    }
    
    else{
        
        NSMutableArray*arr=[NSMutableArray arrayWithContentsOfFile:path];
        NSArray*guo=[NSArray arrayWithArray:values];
        for (NSDictionary*d in guo) {
            [arr addObject:d];
        }
        [arr writeToFile:path atomically:YES];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
    
    NSString*path=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
    jieshou=[[NSMutableArray alloc] init];
    jieshou=[NSArray arrayWithContentsOfFile:path];
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    NSFileManager*fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:pathkehu]) {
        
    }
    else{
        _kehumingzi.text=[[NSDictionary dictionaryWithContentsOfFile:pathkehu] objectForKey:@"customerName"];
    }
    [_tableview reloadData];
    
}
- (void)viewDidLoad {
    
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(tiao)];
    self.navigationItem.rightBarButtonItem = right;
    
}

-(void)tiao{
    
    XiadanbianjiViewController*xiadan =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xiadanbianji"];
    [self.navigationController pushViewController:xiadan animated:YES];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // NSLog(@"返回组数的接受数据／／／／／／／／%@",jieshou);
    return jieshou.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;//section高度
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;//cell高度
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell";
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
    name.text = @"商品名称:";
    name.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    name.font = [UIFont systemFontOfSize:15];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 35, width, 1)];
    xian.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, width-40-80, 30 )];
    name1.text = @"暂无数据";
    name1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    name1.font = [UIFont systemFontOfSize:15];
    name1.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    UILabel *shuliang = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 80, 30)];
    shuliang.text = @"商品数量:";
    shuliang.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    shuliang.font = [UIFont systemFontOfSize:15];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, 75, width, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    
    UILabel *shuliang1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 45, width-40-80, 30 )];
    shuliang1.text = @"暂无数据";
    shuliang1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    shuliang1.font = [UIFont systemFontOfSize:15];
    shuliang1.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    
    
    UILabel *danjia = [[UILabel alloc]initWithFrame:CGRectMake(20, 85, 80, 30)];
    danjia.text = @"商品单价:";
    danjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    danjia.font = [UIFont systemFontOfSize:15];
    
    UILabel *danjia1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 85, width-40-80, 30 )];
    danjia1.text = @"暂无数据";
    danjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    danjia1.font = [UIFont systemFontOfSize:15];
    danjia1.textAlignment = NSTextAlignmentCenter;
    
    
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:name1];
    [cell.contentView addSubview:xian];
    
    [cell.contentView addSubview:shuliang];
    [cell.contentView addSubview:shuliang1];
    [cell.contentView addSubview:xian1];
    
    [cell.contentView addSubview:danjia];
    [cell.contentView addSubview:danjia1];
    
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
