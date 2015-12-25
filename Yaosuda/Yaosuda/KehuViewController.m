//
//  KehuViewController.m
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "KehuViewController.h"
#import "Color+Hex.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJsonWriter.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "WarningBox.h"
#import "yonghuziliao.h"
#import "XiadanViewController.h"

@interface KehuViewController ()
{
    CGFloat width;
    CGFloat height;
    
    
    NSArray*customerList;
    UIImageView *image;
    UIImageView *image1;
    
   
}
@end

@implementation KehuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString*businesspersonId=[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"];

    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/customer/customerList";
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
    
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:businesspersonId,@"businesspersonId",@"1",@"pageNo",@"100",@"pageSize", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
   
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        
        
        
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            NSDictionary*data=[responseObject valueForKey:@"data"];
            customerList=[data objectForKey:@"customerList"];
            
            [_tableview reloadData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败～" andView:self.view];
     
    }];

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return customerList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;//cell高度 
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;//section高度
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell1";
    UITableViewCell * cell;
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *KHmingzi = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, width/4-10, 30)];
    KHmingzi.text = @"客户姓名:";
    KHmingzi.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    KHmingzi.font = [UIFont systemFontOfSize:13];
    UILabel *KHmingzi1  = [[UILabel alloc]initWithFrame:CGRectMake(width/4-10, 3.5, width/4, 40)];
    KHmingzi1.text = [customerList[indexPath.section] objectForKey:@"customerName" ];
    KHmingzi1.font = [UIFont systemFontOfSize:13];
    KHmingzi1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    KHmingzi1.textAlignment = NSTextAlignmentCenter;
    KHmingzi1.numberOfLines = 0;
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, width, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    
    
    
    UILabel *LXdianhua = [[UILabel alloc]initWithFrame:CGRectMake(width/2-10, 8, width/4-20, 30)];
    LXdianhua.text = @"联系电话:";
    LXdianhua.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    LXdianhua.font = [UIFont systemFontOfSize:13];
    UILabel *LXdianhua1 = [[UILabel alloc]initWithFrame:CGRectMake(width/2+width/4-30, 8, width/4+30, 30)];
    LXdianhua1.text = [customerList[indexPath.section] objectForKey:@"linkmanPhone" ];
    LXdianhua1.font = [UIFont systemFontOfSize:14];
    LXdianhua1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    LXdianhua1.textAlignment = NSTextAlignmentCenter;
   

    
    
    
    UILabel *CKdizhi = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 70, 30)];
    CKdizhi.text = @"仓库地址:";
    CKdizhi.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    CKdizhi.font = [UIFont systemFontOfSize:13];
    UILabel *CKdizhi1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, width-90, 30)];
    CKdizhi1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    
    
    
    
    CKdizhi1.text = [customerList[indexPath.section] objectForKey:@"warehouseAddress" ];
    CKdizhi1.font = [UIFont systemFontOfSize:13];
    CKdizhi1.textAlignment = NSTextAlignmentCenter;
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(0, 75, width, 1)];
    xian2.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    
    

    UILabel *ZCdizhi = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 70, 30)];
    ZCdizhi.text = @"注册地址:";
    ZCdizhi.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    ZCdizhi.font = [UIFont systemFontOfSize:13];
    UILabel *ZCdizhi1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 80, width-90, 30)];
    
    
    
    
    ZCdizhi1.text = [customerList[indexPath.section] objectForKey:@"registerAddress" ];
    ZCdizhi1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    ZCdizhi1.font = [UIFont systemFontOfSize:13];
    ZCdizhi1.textAlignment = NSTextAlignmentCenter;
    

    UILabel *FZren = [[UILabel alloc]initWithFrame:CGRectMake(10, 115, width/4-10, 30)];
    FZren.text = @"负  责  人:";
    FZren.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    FZren.font = [UIFont systemFontOfSize:13];
    UILabel *FZren1 = [[UILabel alloc]initWithFrame:CGRectMake(width/4-10, 115, width/4, 30)];
    
    
    
    
    FZren1.text = [customerList[indexPath.section] objectForKey:@"officer" ];
    FZren1.font = [UIFont systemFontOfSize:13];
    FZren1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    FZren1.textAlignment = NSTextAlignmentCenter;

    
    

    UILabel *LXren = [[UILabel alloc]initWithFrame:CGRectMake(width/2-10, 115, width/4-20, 30)];
    LXren.text = @"联  系  人:";
    LXren.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    LXren.font = [UIFont systemFontOfSize:13];
    UILabel *LXren1 = [[UILabel alloc]initWithFrame:CGRectMake(width/2+width/4-30, 115, width/4+30, 30)];
   
    
    
    LXren1.text = [customerList[indexPath.section] objectForKey:@"linkman" ];
    LXren1.font = [UIFont systemFontOfSize:13];
    LXren1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    LXren1.textAlignment = NSTextAlignmentCenter;
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(0, 115, width, 1)];
    xian3.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];

    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(1, 0, width-2, 150)];
    image.image = [UIImage imageNamed:@"b.png"];
    
    image1 = [[UIImageView alloc]initWithFrame:CGRectMake(width-20, 3, 15, 15)];
    image1.image = [UIImage imageNamed:@"@2x_kh_03.png"];
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    NSFileManager*fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:pathkehu]) {
        if ([[customerList[indexPath.section] objectForKey:@"customerName"]  isEqualToString:[[NSDictionary dictionaryWithContentsOfFile:pathkehu] objectForKey:@"customerName"]]) {
            
            [cell.contentView addSubview:image];
            [cell.contentView addSubview:image1];
        }
    }
    [cell.contentView addSubview:KHmingzi];
    [cell.contentView addSubview:KHmingzi1];
    [cell.contentView addSubview:LXdianhua];
    [cell.contentView addSubview:LXdianhua1];
    [cell.contentView addSubview:CKdizhi];
    [cell.contentView addSubview:CKdizhi1];
    [cell.contentView addSubview:ZCdizhi];
    [cell.contentView addSubview:ZCdizhi1];
    [cell.contentView addSubview:FZren];
    [cell.contentView addSubview:FZren1];
    [cell.contentView addSubview:LXren];
    [cell.contentView addSubview:LXren1];
   
    
    [cell.contentView addSubview:xian1];
    [cell.contentView addSubview:xian2];
    [cell.contentView addSubview:xian3];
    
    
    
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSDictionary* dd=[NSDictionary dictionaryWithDictionary:customerList[indexPath.section]];
    NSString *path =[NSHomeDirectory() stringByAppendingString:@"/Documents/kehuxinxi.plist"];
    [dd writeToFile:path atomically:YES];

    
    
    
    
    
    
//返回上一页
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (IBAction)fanhui:(id)sender {
    
      [self.navigationController popViewControllerAnimated:YES];
    
}
@end
