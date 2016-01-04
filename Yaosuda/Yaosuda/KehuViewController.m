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



@interface KehuViewController ()<MJRefreshBaseViewDelegate>
{   MJRefreshFooterView*footer;
    MJRefreshHeaderView*header;
    CGFloat width;
    CGFloat height;
    int ye;
    
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
    ye=5;
 

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
    NSString*pageSize=[NSString stringWithFormat:@"%d",ye];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:businesspersonId,@"businesspersonId",@"1",@"pageNo",pageSize,@"pageSize", nil];
    
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
            NSLog(@"%@",customerList);
            [_tableview reloadData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败～" andView:self.view];
        
    }];
}
-(void)setupre{
    header=[MJRefreshHeaderView header];
    header.scrollView=_tableview;
    header.delegate=self;
    header.tag=1001;
    footer=[MJRefreshFooterView footer];
    footer.scrollView=_tableview;
    footer.delegate=self;
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [self performSelector:@selector(done:) withObject:refreshView afterDelay:0];
    
    
}
-(void)done:(MJRefreshBaseView*)refr{
    if (refr.tag==1001) {
        ye=5;
        [self kkk];
        [_tableview reloadData];
        [refr endRefreshing];
        
        
    }
    else{
        ye+=5;
        [self kkk];
        [_tableview reloadData];
        [refr endRefreshing];
    }}

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
    return width/2+width/2/4;//cell高度
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
    KHmingzi.textColor = ziticolor;
    KHmingzi.font = zitifont;
    //KHmingzi.backgroundColor = [UIColor redColor];
    UILabel *KHmingzi1  = [[UILabel alloc]initWithFrame:CGRectMake(((kuan-10)/4-(kuan-10)/4/4)+5, 0, kuan-((kuan-10)/4-(kuan-10)/4/4)-10, gao/4)];
    KHmingzi1.font =zitifont;
    KHmingzi1.textColor = ziticolor;
    KHmingzi1.textAlignment = NSTextAlignmentCenter;
    KHmingzi1.numberOfLines = 0;
    

    UILabel *LXdianhua = [[UILabel alloc]initWithFrame:CGRectMake(5,gao/4, (kuan-10)/4-(kuan-10)/4/4, gao/4)];
    LXdianhua.textColor = ziticolor;
    LXdianhua.font =zitifont;
    UILabel *LXdianhua1 = [[UILabel alloc]initWithFrame:CGRectMake(((kuan-10)/4-(kuan-10)/4/4)+5, gao/4,kuan-((kuan-10)/4-(kuan-10)/4/4)-10 , gao/4)];
    LXdianhua1.font = zitifont;
    LXdianhua1.textColor = ziticolor;
    LXdianhua1.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *CKdizhi = [[UILabel alloc]initWithFrame:CGRectMake(5, gao/2, (kuan-5)/4-15, gao/4)];
    CKdizhi.textColor =ziticolor;
    CKdizhi.font =zitifont;
    UILabel *CKdizhi1 = [[UILabel alloc]initWithFrame:CGRectMake((kuan-5)/4-15, gao/2, kuan-((kuan-5)/4-15)-5, gao/4)];
    CKdizhi1.textColor = ziticolor;
    CKdizhi1.font = zitifont;
    CKdizhi1.textAlignment = NSTextAlignmentCenter;
  

    UILabel *ZCdizhi = [[UILabel alloc]initWithFrame:CGRectMake(5, gao/4*3, (kuan-5)/4-15, gao/4)];
    ZCdizhi.textColor =ziticolor;
    ZCdizhi.font = zitifont;
    UILabel *ZCdizhi1 = [[UILabel alloc]initWithFrame:CGRectMake((kuan-5)/4-15, gao/4*3, kuan-((kuan-5)/4-15)-5, gao/4)];
    ZCdizhi1.textColor = ziticolor;
    ZCdizhi1.font = zitifont;
    ZCdizhi1.textAlignment = NSTextAlignmentCenter;
    

    UILabel *FZren = [[UILabel alloc]initWithFrame:CGRectMake(5, gao, (kuan-10)/4-(kuan-10)/4/4, gao/4)];
    FZren.textColor =ziticolor;
    FZren.font = zitifont;
    UILabel *FZren1 = [[UILabel alloc]initWithFrame:CGRectMake((kuan-10)/4-(kuan-10)/4/4, gao, (kuan-5)/4+15, gao/4)];
    FZren1.font = zitifont;
    FZren1.textColor = ziticolor;
    FZren1.textAlignment = NSTextAlignmentCenter;

    UILabel *LXren = [[UILabel alloc]initWithFrame:CGRectMake((kuan-5)/4*2, gao, (kuan-10)/4-(kuan-10)/4/4, gao/4)];
    LXren.textColor = ziticolor;
    LXren.font = zitifont;
    UILabel *LXren1 = [[UILabel alloc]initWithFrame:CGRectMake((kuan-5)/4*2+( (kuan-10)/4-(kuan-10)/4/4), gao, (kuan-5)/4+15, gao/4)];
    LXren1.font = zitifont;
    LXren1.textColor = ziticolor;
    LXren1.textAlignment = NSTextAlignmentCenter;
    

    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, gao/4, kuan, 1)];
    xian1.backgroundColor = xiancolor;
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(0, gao/2, width, 1)];
    xian2.backgroundColor = xiancolor;
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(0, gao/4*3, width, 1)];
    xian3.backgroundColor = xiancolor;
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(0, gao, width, 1)];
    xian4.backgroundColor = xiancolor;

    KHmingzi.text = @"客户姓名";
    KHmingzi1.text = [customerList[indexPath.section] objectForKey:@"customerName" ];
    LXdianhua.text = @"联系电话";
    //LXdianhua1.text =[customerList[indexPath.section] objectForKey:@"linkmanPhone" ];
    LXdianhua1.text = @"无字段";
    CKdizhi.text = @"仓库地址";
    //CKdizhi1.text = [customerList[indexPath.section] objectForKey:@"warehouseAddress" ];
    CKdizhi1.text = @"无字段";
    ZCdizhi.text = @"注册地址";
    ZCdizhi1.text = [customerList[indexPath.section] objectForKey:@"registerAddress" ];
    FZren.text = @"负  责  人";
    FZren1.text = [customerList[indexPath.section] objectForKey:@"officer" ];
    LXren.text = @"联  系  人";
    // LXren1.text = [customerList[indexPath.section] objectForKey:@"linkman" ];
    LXren1.text = @"无字段";
    
    
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(1, 0, kuan-2, width/2+width/2/4)];
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
