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
#import "MJRefresh.h"

#define ziticolor [UIColor colorWithHexString:@"646464" alpha:1];
#define zitifont [UIFont systemFontOfSize:13];
#define xiancolor [UIColor colorWithHexString:@"e4e4e4" alpha:1];

@interface KehuViewController ()
{
    CGFloat width;
    CGFloat height;
    int ye;
    NSMutableArray*tulv;
    NSArray*customerList;
    UIImageView *image;
    UIImageView *image1;
    NSString*count;
    
}
@end

@implementation KehuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tulv=[NSMutableArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    count = [NSString string];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    ye=1;
    
    
    [self kkk];
    [self setupre];
    
}
-(void)kkk{
    NSString*businesspersonId=[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/customer/customerList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //出入参数：
    NSString*pageSize=[NSString stringWithFormat:@"%d",ye];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:businesspersonId,@"businesspersonId",pageSize,@"pageNo",@"3",@"pageSize", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    NSLog(@"%@",dic);
    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            
             NSLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            NSDictionary*data=[responseObject valueForKey:@"data"];
            customerList=[data objectForKey:@"customerList"];
            count=[NSString stringWithFormat:@"%@",[data objectForKey:@"count"]];
            for (NSDictionary*dd in customerList) {
                [tulv addObject:dd];
            }
            
            [_tableview reloadData];
            
        }
        

        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败～" andView:self.view];
        
    }];
}
-(void)setupre{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewdata)];
    self.tableview.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter*footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableview.mj_footer = footer;

}
-(void)loadNewdata{
    ye=1;
    tulv=[NSMutableArray array];
    [self kkk];
    [_tableview reloadData];
    [_tableview.mj_header endRefreshing];

}
-(void)loadNewData{
    ye+=1;
    if ((ye-1)*3>=[count intValue]) {
        [WarningBox warningBoxModeText:@"已经是最后一页了!" andView:self.view];
        [_tableview.mj_footer endRefreshing];
    }else{
        
        
        [self kkk];
        [_tableview reloadData];
        [_tableview.mj_footer endRefreshing];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"tulv---%ld",tulv.count);
    return tulv.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return width/2;//cell高度
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *diview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    diview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return diview;
    
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
    CGFloat kuan = width;
    CGFloat gao = width/2;
    
    
    UILabel *KHmingzi = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, (kuan-10)/4-(kuan-10)/4/4, gao/4)];
    KHmingzi.textColor = [UIColor colorWithHexString:@"0CB7FF" alpha:1];
    KHmingzi.font = zitifont;
    //KHmingzi.backgroundColor = [UIColor redColor];
    UILabel *KHmingzi1  = [[UILabel alloc]initWithFrame:CGRectMake(((kuan-10)/4-(kuan-10)/4/4)+5, 0, kuan-((kuan-10)/4-(kuan-10)/4/4)-10, gao/4)];
    KHmingzi1.font =zitifont;
    KHmingzi1.textColor = [UIColor colorWithHexString:@"0CB7FF" alpha:1];
    KHmingzi1.textAlignment = NSTextAlignmentLeft;
    KHmingzi1.numberOfLines = 0;
    
    UILabel *LXdianhua = [[UILabel alloc]initWithFrame:CGRectMake(5,gao/4, (kuan-10)/4-(kuan-10)/4/4, gao/4)];
    LXdianhua.textColor = ziticolor;
    LXdianhua.font =zitifont;
    UILabel *LXdianhua1 = [[UILabel alloc]initWithFrame:CGRectMake(((kuan-10)/4-(kuan-10)/4/4)+5, gao/4,kuan-((kuan-10)/4-(kuan-10)/4/4)-10 , gao/4)];
    LXdianhua1.font = zitifont;
    LXdianhua1.textColor = ziticolor;
    LXdianhua1.textAlignment = NSTextAlignmentLeft;
    ///////
    UILabel *ZCdizhi = [[UILabel alloc]initWithFrame:CGRectMake(5, gao/2, (kuan-5)/4-15, gao/4)];
    
    UILabel *ZCdizhi1 = [[UILabel alloc]initWithFrame:CGRectMake((kuan-5)/4-15, gao/2, kuan-((kuan-5)/4-15)-5, gao/4)];
    
    ZCdizhi1.textColor = ziticolor;
    ZCdizhi1.font = zitifont;
    ZCdizhi1.textAlignment = NSTextAlignmentLeft;
    UILabel *LXren= [[UILabel alloc]initWithFrame:CGRectMake(5, gao/4*3, (kuan-5)/4-15, gao/4)];
    LXren.textColor =ziticolor;
    LXren.font = zitifont;
    UILabel *LXren1= [[UILabel alloc]initWithFrame:CGRectMake((kuan-5)/4-15, gao/4*3, kuan-((kuan-5)/4-15)-5, gao/4)];
    
    
    LXren1.font = zitifont;
    LXren1.textColor = ziticolor;
    LXren1.textAlignment = NSTextAlignmentLeft;
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, gao/4, kuan, 1)];
    xian1.backgroundColor = xiancolor;
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(0, gao/2, width, 1)];
    xian2.backgroundColor = xiancolor;
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(0, gao/4*3, width, 1)];
    xian3.backgroundColor = xiancolor;
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(0, gao, width, 1)];
    xian4.backgroundColor = xiancolor;
    
    KHmingzi.text = @"客户名称:";
    KHmingzi1.text = [tulv[indexPath.section] objectForKey:@"customerName" ];
    LXdianhua.text = @"联系电话:";
    LXdianhua1.text =[tulv[indexPath.section] objectForKey:@"linkmanPhone" ];
    //    CKdizhi.text = @"仓库地址";
    //    CKdizhi1.text = [customerList[indexPath.section] objectForKey:@"warehouseAddress" ];
    //    CKdizhi1.text = [tulv[indexPath.section] objectForKey:@"warehouseAddress"];
    ZCdizhi.text = @"注册地址:";
    ZCdizhi.textColor =ziticolor;
    ZCdizhi.font = zitifont;
    ZCdizhi1.text = [tulv[indexPath.section] objectForKey:@"registerAddress" ];
    
    //    FZren.text = @"负  责  人";
    //    FZren1.text = [tulv[indexPath.section] objectForKey:@"officer" ];
    LXren.text = @"联  系  人:";
    
    LXren1.text = [tulv[indexPath.section] objectForKey:@"linkman" ];
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(1, 0, kuan-2, width/2)];
    image.image = [UIImage imageNamed:@"b.png"];
    
    image1 = [[UIImageView alloc]initWithFrame:CGRectMake(width-20, 3, 15, 15)];
    image1.image = [UIImage imageNamed:@"@2x_kh_03.png"];
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    NSFileManager*fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:pathkehu]) {
        if ([[tulv[indexPath.section] objectForKey:@"customerName"]  isEqualToString:[[NSDictionary dictionaryWithContentsOfFile:pathkehu] objectForKey:@"customerName"]]) {
            
            [cell.contentView addSubview:image];
            [cell.contentView addSubview:image1];
        }
    }
    [cell.contentView addSubview:KHmingzi];
    [cell.contentView addSubview:KHmingzi1];
    [cell.contentView addSubview:LXdianhua];
    [cell.contentView addSubview:LXdianhua1];
    
    [cell.contentView addSubview:ZCdizhi];
    [cell.contentView addSubview:ZCdizhi1];
    
    [cell.contentView addSubview:LXren];
    [cell.contentView addSubview:LXren1];
    
    [cell.contentView addSubview:xian1];
    [cell.contentView addSubview:xian2];
    [cell.contentView addSubview:xian3];
    [cell.contentView addSubview:xian4];
    
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* dd=[NSDictionary dictionaryWithDictionary:tulv[indexPath.section]];
    NSString *path =[NSHomeDirectory() stringByAppendingString:@"/Documents/kehuxinxi.plist"];
    [dd writeToFile:path atomically:YES];
    
    //返回上一页
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (IBAction)fanhui:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
