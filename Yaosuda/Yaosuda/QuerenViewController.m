//
//  QuerenViewController.m
//  Yaosuda
//
//  Created by suokun on 15/12/14.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "QuerenViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJsonWriter.h"
#import "hongdingyi.h"
#import "yonghuziliao.h"
#import "WarningBox.h"
#import "lianjie.h"
#import "ChaxunViewController.h"
#import "Color+Hex.h"

#define ziticolor [UIColor colorWithHexString:@"646464" alpha:1];
#define zitifont [UIFont systemFontOfSize:13];
#define xiancolor [UIColor colorWithHexString:@"e4e4e4" alpha:1];
@interface QuerenViewController (){
    NSMutableArray*shangid;
    NSMutableArray*shuliangji;
    NSString*businesspersonId;
    NSString*customerId;
    NSString*loginUserId;
    
    CGFloat width;
    CGFloat height;
    
    NSMutableArray *Left;
    NSMutableArray *Right;
}
- (IBAction)tijiao:(id)sender;
@end


@implementation QuerenViewController
- (void)viewDidLoad
{
     [super viewDidLoad];
    _yingfu.text=_meme;
    _shouhuoren.text=_xixi;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
   
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    loginUserId= [NSString stringWithFormat:@"%@",[[yonghuziliao getUserInfo] objectForKey:@"id"]];
    businesspersonId=[NSString stringWithFormat:@"%@",[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"]];
    shangid=[NSMutableArray array];
    shuliangji=[NSMutableArray array];
    NSString*path=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
    NSArray*arr=[NSArray arrayWithContentsOfFile:path];
    for (int i=0; i<arr.count; i++) {
       [ shangid addObject:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"id"]]];
        [shuliangji addObject:[arr[i] objectForKey:@"shuliang"]];
    }
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    NSDictionary*kehu=[NSDictionary dictionaryWithContentsOfFile:pathkehu];
    customerId=[NSString stringWithFormat:@"%@",[kehu objectForKey:@"id"]];
    
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    [self makearray];
 
}

-(void)makearray
{
    Left = [[NSMutableArray alloc]init];
    [Left addObject:@"客户姓名:"];
    [Left addObject:@"联系电话:"];
    [Left addObject:@"仓库地址:"];
    [Left addObject:@"注册地址:"];
    [Left addObject:@"负 责 人 :"];
    [Left addObject:@"联 系 人 :"];
    Right = [[NSMutableArray alloc]init];
    [Right addObject:@"暂无数据"];
    [Right addObject:@"暂无数据"];
    [Right addObject:@"暂无数据"];
    [Right addObject:@"暂无数据"];
    [Right addObject:@"暂无数据"];
    [Right addObject:@"暂无数据"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;//cell高度
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;//section高度
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell1";
    UITableViewCell * cell;
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    //创建label
    UILabel *left = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
    left.textColor = ziticolor;
    left.font = zitifont;
    UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, width-90, 40)];
    right.font = zitifont;
    right.textColor = ziticolor;
    right.textAlignment = NSTextAlignmentCenter;
    //label赋值
    left.text = Left[indexPath.section];
    right.text = Right[indexPath.section];
    //自定义线
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, width, 1)];
    xian1.backgroundColor = xiancolor;
    //在cell上显示
    [cell.contentView addSubview:xian1];
    [cell.contentView addSubview:left];
    [cell.contentView addSubview:right];
    
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}





















- (IBAction)tijiao:(id)sender
{
    
       
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/order/submit";
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
    [WarningBox warningBoxModeIndeterminate:@"正在下单中..." andView:self.view];
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"orderType",businesspersonId,@"businesspersonId",@"1",@"fromWhere",customerId,@"customerId",shangid,@"ids",loginUserId,@"loginUserId",shuliangji,@"nums", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
  
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
       if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            [WarningBox warningBoxModeText:@"下单成功" andView:self.view];
            NSFileManager *defaultManager;
            defaultManager = [NSFileManager defaultManager];
            NSString*path=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
            NSString*path1=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
            [defaultManager removeItemAtPath:path error:NULL];
            [defaultManager removeItemAtPath:path1 error:NULL];
           
           //跳转到订单查询
           
           ChaxunViewController *chaxun = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chaxun"];
           [self.navigationController pushViewController:chaxun animated:YES];
           
           
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败～" andView:self.view];

    }];
}
- (IBAction)fanhui:(id)sender
{
    
      [self.navigationController popViewControllerAnimated:YES];
}
@end