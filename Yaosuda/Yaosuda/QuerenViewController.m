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
    
    NSArray*arr;
    NSDictionary*kehu;
    
}
- (IBAction)tijiao:(id)sender;
@end


@implementation QuerenViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"\n\n\n\n应付金额\n%@\n\n\n\n\n",_meme);
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
    arr=[NSArray arrayWithContentsOfFile:path];
    NSLog(@"arr------------------%@",arr);
    
    for (int i=0; i<arr.count; i++) {
        [ shangid addObject:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"id"]]];
        [shuliangji addObject:[arr[i] objectForKey:@"shuliang"]];
    }
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    kehu=[NSDictionary dictionaryWithContentsOfFile:pathkehu];
    NSLog(@"kehu----------------------%@",kehu);
    customerId=[NSString stringWithFormat:@"%@",[kehu objectForKey:@"id"]];
    
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    [self makearray];
    
}

-(void)makearray
{
    
    Left = [[NSMutableArray alloc]init];
    [Left addObject:@"商品名称:"];
    [Left addObject:@"商品数量:"];
    [Left addObject:@"单      位:"];
    [Left addObject:@"商品规格:"];
    [Left addObject:@"联系电话:"];
    Right = [[NSMutableArray alloc]init];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return width/16;//cell高度
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;//section高度
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell1";
    UITableViewCell * cell;
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, width-90, width/16)];
    right.font = zitifont;
    right.textColor = ziticolor;
    if (indexPath.row==0) {
        
    right.text= [NSString stringWithFormat:@"%@",[arr [indexPath.section] objectForKey:@"proName"]];
    }else if (indexPath.row==1){
    right.text= [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"shuliang"]];
    }else if(indexPath.row==2){
    right.text= [NSString stringWithFormat:@"%@",[arr[indexPath.section] objectForKey:@"unit"]];
    }else if (indexPath.row==3){
    right.text= [NSString stringWithFormat:@"%@",[arr [indexPath.section]objectForKey:@"etalon"]];
    }else if (indexPath.row==4){
    if ([kehu objectForKey:@"linkmanPhone"]==nil) {
        right.text= @"";
    }else{
        right.text= [NSString stringWithFormat:@"%@",[kehu objectForKey:@"linkmanPhone"]];
    }
    }
  

    
    
    
    //创建label
    UILabel *left = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, width/16)];
    left.textColor = ziticolor;
    left.font = zitifont;
    left.text=Left[indexPath.row];
    
    

//    //自定义线
//    
//    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, width/16-1, width, 1)];
//    xian1.backgroundColor = xiancolor;
    //在cell上显示
//    [cell.contentView addSubview:xian1];
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
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
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
            [WarningBox warningBoxModeText:@"下单成功" andView:self.navigationController.view];
            //删除本地文件
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