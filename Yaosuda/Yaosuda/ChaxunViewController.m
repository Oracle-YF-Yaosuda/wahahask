//
//  ChaxunViewController.m
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "ChaxunViewController.h"
#import "Color+Hex.h"
#import "XiadanViewController.h"
#import "XinxiViewController.h"
#import "lianjie.h"
#import "hongdingyi.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "WarningBox.h"
#import "yonghuziliao.h"
#import "MJRefresh.h"

#define ziticolor [UIColor colorWithHexString:@"646464" alpha:1];
#define zitifont [UIFont systemFontOfSize:15];
#define xiancolor [UIColor colorWithHexString:@"e4e4e4" alpha:1];
#define beijingcolor [UIColor colorWithHexString:@"f4f4f4" alpha:1];

@interface ChaxunViewController ()<MJRefreshBaseViewDelegate>
{   MJRefreshHeaderView*header;
    MJRefreshFooterView*footer;
    CGFloat width;
    CGFloat height;
    NSArray*zuobian;
    NSArray*youbian;
    int zhi;
    int ye;
    int index;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *xiaodian;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fenduan;
- (IBAction)fenduan:(id)sender;
@property(strong,nonatomic) UITextField *qian;
@property(strong,nonatomic) UITextField *hou;
@property(strong,nonatomic) UIButton *chaxun;
- (IBAction)queding:(id)sender;
- (IBAction)quxiao:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) IBOutlet UIView *beijing;

@end

@implementation ChaxunViewController
-(void)viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"dian"] intValue]==1) {
        
    }else{
        _xiaodian.hidden=YES;
    }
     _tableview.frame=CGRectMake(0, 0, width, height);
    [_tableview reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //遵守 tableview 代理
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    //获取设备 宽和高
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //初始view隐藏
    self.beijing.hidden = YES;
    _tableview.frame=CGRectMake(0, 40, width, height);
    
    zhi = 1;
    ye=5;
    [self huoququanbu];
   // [self huoqudaishenhe];
    [self setupre];
}
-(void)setupre
{
    header=[MJRefreshHeaderView header];
    header.scrollView=_tableview;
    header.delegate=self;
    header.tag=1001;
    footer=[MJRefreshFooterView footer];
    footer.scrollView=_tableview;
    footer.delegate=self;
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self performSelector:@selector(done:) withObject:refreshView afterDelay:0];

}
-(void)done:(MJRefreshBaseView*)refr
{
    if (refr.tag==1001) {
        ye=5;
        if (zhi==1) {
            
        [self huoququanbu];
        }
        else
        [self huoqudaishenhe];
     
        [_tableview reloadData];
        [refr endRefreshing];
        
        
    }
    else{
        ye+=5;
        if (zhi==1) {
            [self huoququanbu];
        }else
            [self huoqudaishenhe];
        [_tableview reloadData];
        [refr endRefreshing];
    }}
//获取全部订单网络数据
-(void)huoququanbu
{
 NSString*loginUserID=[[yonghuziliao getUserInfo] objectForKey:@"id"];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString *url = @"/order/list";
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];

   
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    NSString  *Now;
    NSDateFormatter*ff=[[NSDateFormatter alloc] init];
    [ff setDateFormat:@"yyyy-MM-dd"];
    Now=[ff stringFromDate:[NSDate date]];
    
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDate* theDate;
    theDate = [[NSDate date] initWithTimeIntervalSinceNow: -oneDay*3 ];
    NSString*san=[ff stringFromDate:theDate];

    //出入参数：
    NSString*pageSize=[NSString stringWithFormat:@"%d",ye];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:loginUserID,@"loginUserId",san,@"startDate",Now,@"endDate", @"",@"state", @"1",@"pageNo",pageSize,@"pageSize",nil];
       NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];

    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];

   
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
 
   
    
    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
           
            NSDictionary *datadic = [responseObject valueForKey:@"data"];
            zuobian=[datadic objectForKey:@"orderList"];
            
            [_tableview reloadData];
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"获取数据失败!" andView:self.view];

           }];
}
//获取待审核数据
-(void)huoqudaishenhe
{
    NSString*businesspersonId=[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString *url = @"/order/auditList";
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];

   
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：

    NSDictionary*datadic1=[NSDictionary dictionaryWithObjectsAndKeys:businesspersonId,@"businesspersonId",nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic1];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic1=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    

    [manager GET:url1 parameters:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
        
            NSDictionary *data1 = [responseObject valueForKey:@"data"];
            youbian=[data1 objectForKey:@"orderList"];
            
            [_tableview reloadData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"数据加载失败..." andView:self.view];
    }];
    
}
//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (zhi == 1)
    {
        if (zuobian.count!=0)
        {
            return zuobian.count +1;
        }else
        return 0;
    }
    else if (zhi == 2)
    {
        if (youbian.count!=0)
        {
            return youbian.count;
        }else
        return 0;
    }
    return 0;
}
//cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (zhi == 1)
    {
        if (indexPath.section == 0)
        {
            return 80;
        }
        else
            return width;
    }
    else if(zhi == 2)
    {
        return width;
    }
    return 0;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (zhi == 1) {
        if (section == 0) {
            return 15;
        }
        else
            return 32;
    }
    else if(zhi == 2){
        return 32;
    }
        return 0;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    

    if (zhi == 1)
    {
        if (section == 0)
        {
            UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
            baseView.backgroundColor = beijingcolor;

            return baseView;
        }
        UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
        baseView.backgroundColor = beijingcolor;
        
        UILabel *groupName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 35)];
        groupName.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        groupName.text =@"订单信息";
        groupName.font = [UIFont systemFontOfSize:15];
        
       
        NSString*huo=[[NSString alloc] init];
        
            
        
        UILabel *shenhe = [[UILabel alloc]init];
        if([[zuobian[section-1] objectForKey:@"state"] intValue]==0){
            huo = @"完成";
        }else if([[zuobian[section-1] objectForKey:@"state"] intValue]==2){
            huo = @"联系人审核";
        }else if([[zuobian[section-1] objectForKey:@"state"] intValue]==4){
            huo = @"开票员审核";
        }else if([[zuobian[section-1] objectForKey:@"state"] intValue]==6){
            shenhe.text = @"财务审核";
        }else if([[zuobian[section-1] objectForKey:@"state"] intValue]==7){
            huo = @"撤销";
        }else if([[zuobian[section-1] objectForKey:@"state"] intValue]==8){
            huo = @"退货";
        }else if([[zuobian[section-1] objectForKey:@"state"] intValue]==9){
            huo = @"退货确认";
        }else{
            huo =@"未审核";
        }
        
        CGRect textRect = [huo boundingRectWithSize:CGSizeMake(100,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil ];
        shenhe.text=huo;
        shenhe.frame=CGRectMake(width-textRect.size.width-5, 0, textRect.size.width, 35);
        shenhe.font = [UIFont systemFontOfSize:15];
        shenhe.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        
       UIButton *tu = [[UIButton alloc] initWithFrame:CGRectMake(width-30-shenhe.frame.size.width, 8, 20, 20)];
         [tu setBackgroundImage:[UIImage imageNamed:@"@2x_dd_22_18.png"] forState:UIControlStateNormal];
        [baseView addSubview:shenhe];
        [baseView addSubview:groupName];
        [baseView addSubview:tu];
        
        return baseView;
    }
    else if(zhi == 2)
        {
           

            UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
            baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
            
            UILabel *groupName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 35)];
            groupName.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            groupName.text =@"订单信息";
            groupName.font = [UIFont systemFontOfSize:15];
            
            NSString*huo=[[NSString alloc] init];
            
            UILabel *shenhe = [[UILabel alloc]init];
            if([[youbian[section] objectForKey:@"state"] intValue]==0){
                huo = @"完成";
            }else if([[youbian[section] objectForKey:@"state"] intValue]==2){
                huo = @"联系人审核";
            }else if([[zuobian[section] objectForKey:@"state"] intValue]==4){
                huo = @"开票员审核";
            }else if([[youbian[section] objectForKey:@"state"] intValue]==6){
                shenhe.text = @"财务审核";
            }else if([[youbian[section] objectForKey:@"state"] intValue]==7){
                huo = @"撤销";
            }else if([[youbian[section] objectForKey:@"state"] intValue]==8){
                huo = @"退货";
            }else if([[youbian[section] objectForKey:@"state"] intValue]==9){
               huo = @"退货确认";
            }else{
                huo =@"未审核";
            }
            
            CGRect textRect = [huo boundingRectWithSize:CGSizeMake(100,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil ];
            shenhe.text=huo;
            shenhe.frame=CGRectMake(width-textRect.size.width-5, 0, textRect.size.width, 35);
            shenhe.font = [UIFont systemFontOfSize:15];
            shenhe.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            UIButton *tu = [[UIButton alloc] initWithFrame:CGRectMake(width-30-shenhe.frame.size.width, 8, 20,20)];
            [tu setBackgroundImage:[UIImage imageNamed:@"@2x_dd_22_18.png"] forState:UIControlStateNormal];
            
            [baseView addSubview:shenhe];
            [baseView addSubview:groupName];
            [baseView addSubview:tu];
            return baseView;
        
        }
    return nil;
}
//编辑cell内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    
    CGFloat gao = width;
    CGFloat labheight = gao/8;
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, labheight)];
    lab1.textColor = ziticolor;
    lab1.font =zitifont;
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(20, gao/8, width-40, 1)];
    xian1.backgroundColor =xiancolor;
    UILabel *lab11 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, width-120, labheight)];
    lab11.textColor = ziticolor;
    lab11.font = zitifont;
    lab11.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab2 = [[UILabel  alloc]initWithFrame:CGRectMake(20, gao/8, 80, labheight)];
    lab2.textColor = ziticolor;
    lab2.font = zitifont;
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(20, gao/4, width-40, 1)];
    xian2.backgroundColor = xiancolor;
    UILabel *lab21 = [[UILabel alloc]initWithFrame:CGRectMake(100, gao/8, width-40-80, labheight)];
    lab21.textColor = ziticolor;
    lab21.font =zitifont;
    lab21.textAlignment = NSTextAlignmentCenter;
    lab21.numberOfLines = 0;
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, gao/4, 80, labheight)];
    lab3.textColor = ziticolor;
    lab3.font = zitifont;
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(20, gao/8*3, width-40, 1)];
    xian3.backgroundColor = xiancolor;
    UILabel *lab31 = [[UILabel alloc]initWithFrame:CGRectMake(100, gao/4, width-40-80, labheight)];
    lab31.textColor = ziticolor;
    lab31.font = zitifont;
    lab31.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(20, gao/8*3, 80, labheight)];
    lab4.textColor = ziticolor;
    lab4.font = zitifont;
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(20, gao/2, width-40, 1)];
    xian4.backgroundColor = xiancolor;
    UILabel *lab41 = [[UILabel alloc]initWithFrame:CGRectMake(100, gao/8*3, width-40-80, labheight)];
    lab41.textColor = ziticolor;
    lab41.font = zitifont;
    lab41.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(20,  gao/2, 80, labheight)];
    lab5.textColor = ziticolor;
    lab5.font = zitifont;
    UIView *xian5 = [[UIView alloc]initWithFrame:CGRectMake(20, gao/8*5, width-40, 1)];
    xian5.backgroundColor = xiancolor;
    UILabel *lab51 = [[UILabel alloc]initWithFrame:CGRectMake(100,  gao/2, width-40-80, labheight)];
    lab51.textColor = ziticolor;
    lab51.font = zitifont;
    lab51.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(20, gao/8*5, 80, labheight)];
    lab6.textColor = ziticolor;
    lab6.font = zitifont;
    UIView *xian6 = [[UIView alloc]initWithFrame:CGRectMake(20, gao/8*6, width-40, 1)];
    xian6.backgroundColor = xiancolor;
    UILabel *lab61 = [[UILabel alloc]initWithFrame:CGRectMake(100, gao/8*5, width-40-80, labheight)];
    lab61.textColor = ziticolor;
    lab61.font = zitifont;
    lab61.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(20, gao/8*6, 80, labheight)];
    lab7.textColor = ziticolor;
    lab7.font = zitifont;
    UIView *xian7 = [[UIView alloc]initWithFrame:CGRectMake(20, gao/8*7, width-40, 1)];
    xian7.backgroundColor = xiancolor;
    UILabel *lab71 = [[UILabel alloc]initWithFrame:CGRectMake(100, gao/8*6, width-40-80, labheight)];
    lab71.textColor = ziticolor;
    lab71.font = zitifont;
    lab71.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab8 = [[UILabel alloc]initWithFrame:CGRectMake(20, gao/8*7, 80, labheight)];
    lab8.textColor = ziticolor;
    lab8.font = zitifont;
    UILabel *lab81 = [[UILabel alloc]initWithFrame:CGRectMake(100, gao/8*7, width-40-80, labheight)];
    lab81.textColor = ziticolor;
    lab81.font = zitifont;
    lab81.textAlignment = NSTextAlignmentCenter;

    
    lab1.text = @"订单编号:";
    lab2.text = @"订单名称:";
    lab3.text = @"客户姓名:";
    lab4.text = @"订单金额:";
    lab5.text = @"优惠金额:";
    lab6.text = @"下单时间:";
    lab7.text = @"更新时间:";
    lab8.text = @"业务人员:";
    
   
    
    
    if(zhi == 1)
    {
        if (indexPath.section == 0)
        {
            UILabel *CXSH = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, width, 21)];
            CXSH.text = @"查询时间";
            CXSH.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            CXSH.font = [UIFont systemFontOfSize:14];
            
            self.qian = [[UITextField alloc]initWithFrame:CGRectMake(15, 42, (width- 60)/3, 30)];
            self.qian.placeholder = @" 请选择日期";
            self.qian.font = [UIFont systemFontOfSize:13];
            self.qian.layer.borderColor = [[UIColor colorWithHexString:@"0CB7FF" alpha:1] CGColor];
            self.qian.layer.borderWidth =1;
            self.qian.layer.cornerRadius = 5.0;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(22+(width- 60)/3, 47, 20, 21)];
            label.text = @"至";
            label.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            label.font = [UIFont systemFontOfSize:15];
            
            self.hou = [[UITextField alloc]initWithFrame:CGRectMake(45+(width- 60)/3, 42,  (width- 60)/3, 30)];
            self.hou.placeholder = @" 请选择日期";
            self.hou.font = [UIFont systemFontOfSize:13];
            self.hou.layer.borderColor = [[UIColor colorWithHexString:@"0CB7FF" alpha:1] CGColor];
            self.hou.layer.borderWidth =1;
            self.hou.layer.cornerRadius = 5.0;
            
            
            
            self.chaxun = [[UIButton alloc]initWithFrame:CGRectMake(45+(width- 60)/3*2+20, 42, (width- 60)/3-20, 30)];
            self.chaxun.backgroundColor = [UIColor colorWithHexString:@"0CB7FF" alpha:1];
            [self.chaxun setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.chaxun addTarget:self action:@selector(cha) forControlEvents:UIControlEventTouchUpInside];
            [self.chaxun setTitle:@"查询" forState:UIControlStateNormal];
            self.chaxun.layer.cornerRadius = 5.0;
            self.chaxun.titleLabel.font = [UIFont systemFontOfSize:15];
            
            //textfield代理
            self.qian.delegate = self;
            self.hou.delegate = self;
            
            [cell.contentView addSubview:CXSH];
            [cell.contentView addSubview:self.qian];
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:self.hou];
            [cell.contentView addSubview:self.chaxun];
            
            
        }else
        {
          
            lab11.text = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"orderCode"]];
          
            lab21.text = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"orderName"]];
           
            lab31.text = [[zuobian[indexPath.section-1] objectForKey:@"customer"] objectForKey:@"customerName"];
           
            lab41.text = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"amount"]];
            
            lab51.text = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"discountAmount"]];
            
            lab61.text =[NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"createDate"]];
            
            if ([zuobian[indexPath.section-1] objectForKey:@"updateDate"]==nil) {
                lab71.text=@"";
            }else{
            lab71.text = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"updateDate"]];
            }
            lab81.text = [NSString stringWithFormat:@"%@",[[zuobian[indexPath.section-1]objectForKey:@"businessperson"] objectForKey:@"name"]];
            
            
            
            UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, width-10, gao)];
            imag.image = [UIImage imageNamed:@"b.png"];
            
            UIImageView *imag1 = [[UIImageView alloc]initWithFrame:CGRectMake(width-60, gao-55, 60, 55)];
            imag1.image = [UIImage imageNamed:@"@2x_dd_22_22.png"];
            [cell.contentView addSubview:imag];
            [cell.contentView addSubview:imag1];

            
            [cell.contentView addSubview:lab1];
            [cell.contentView addSubview:xian1];
            [cell.contentView addSubview:lab11];
            
            [cell.contentView addSubview:lab2];
            [cell.contentView addSubview:xian2];
            [cell.contentView addSubview:lab21];
            
            [cell.contentView addSubview:lab3];
            [cell.contentView addSubview:xian3];
            [cell.contentView addSubview:lab31];
            
            [cell.contentView addSubview:lab4];
            [cell.contentView addSubview:xian4];
            [cell.contentView addSubview:lab41];
            
            [cell.contentView addSubview:lab5];
            [cell.contentView addSubview:xian5];
            [cell.contentView addSubview:lab51];
            
            [cell.contentView addSubview:lab6];
            [cell.contentView addSubview:xian6];
            [cell.contentView addSubview:lab61];
            
            [cell.contentView addSubview:lab7];
            [cell.contentView addSubview:xian7];
            [cell.contentView addSubview:lab71];
            
            [cell.contentView addSubview:lab8];
            [cell.contentView addSubview:lab81];
        }
    }
    else if (zhi == 2)
    {
        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, width-10, gao)];
        imag.image = [UIImage imageNamed:@"a.png"];
        
        UIImageView *imag1 = [[UIImageView alloc]initWithFrame:CGRectMake(width-60, gao-55, 60, 55)];
        imag1.image = [UIImage imageNamed:@"@2x_dd_22_22_22.png"];
        [cell.contentView addSubview:imag];
        [cell.contentView addSubview:imag1];
//cell  赋值
        
        lab11.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"orderCode"]];
        lab21.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"orderName"]];
        lab31.text=[[youbian[indexPath.section] objectForKey:@"customer"] objectForKey:@"customerName"];
        lab41.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"amount"]];
        lab51.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"discountAmount"]];
        lab61.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"createDate"]];
        lab71.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"updateDate"]];
        lab81.text=[NSString stringWithFormat:@"%@",[[youbian[indexPath.section] objectForKey:@"businessperson"] objectForKey:@"name"]];

       
        [cell.contentView addSubview:lab1];
        [cell.contentView addSubview:xian1];
        [cell.contentView addSubview:lab11];
        
        [cell.contentView addSubview:lab2];
        [cell.contentView addSubview:xian2];
        [cell.contentView addSubview:lab21];
        
        [cell.contentView addSubview:lab3];
        [cell.contentView addSubview:xian3];
        [cell.contentView addSubview:lab31];
        
        [cell.contentView addSubview:lab4];
        [cell.contentView addSubview:xian4];
        [cell.contentView addSubview:lab41];
        
        [cell.contentView addSubview:lab5];
        [cell.contentView addSubview:xian5];
        [cell.contentView addSubview:lab51];
        
        [cell.contentView addSubview:lab6];
        [cell.contentView addSubview:xian6];
        [cell.contentView addSubview:lab61];
        
        [cell.contentView addSubview:lab7];
        [cell.contentView addSubview:xian7];
        [cell.contentView addSubview:lab71];
        
        [cell.contentView addSubview:lab8];
        [cell.contentView addSubview:lab81];

    
    }
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;

    
    return cell;
}
//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *orderType1;//订单类型
    //NSString *isGather1;//是否收款
    //NSString *isInvoice1;//是否开票
    //NSString *isNewRecord1;//是否退货
    XinxiViewController*xinxi =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xinxi"];
    
    
    if (zhi == 1){
        if (indexPath.section == 0)
        {
            
        }else
        {
            xinxi.orderId=[NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"id"]];
            
            xinxi.orderType = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"orderType"]];
            xinxi.isGather = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"isGather"]];
            xinxi.isInvoice = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1] objectForKey:@"isInvoice"]];
            xinxi.isNewRecord = [NSString stringWithFormat:@"%@",[zuobian[indexPath.section-1]objectForKey:@"isNewRecord"]];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"shen"];
             [self.navigationController pushViewController:xinxi animated:YES];
        }
    }
    else if (zhi == 2){
        
            xinxi.orderId=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"id"]];
        
            xinxi.orderType = [NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"orderType"]];
            xinxi.isGather = [NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"isGather"]];
            xinxi.isInvoice = [NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"isInvoice"]];
            xinxi.isNewRecord = [NSString stringWithFormat:@"%@",[youbian[indexPath.section]objectForKey:@"isNewRecord"]];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"shen"];
            [self.navigationController pushViewController:xinxi animated:YES];
        
            }

}
//textfield点击事件
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.qian){
        self.beijing.hidden = NO;
        zhi=3;
        return NO;
    }
    else if (textField == self.hou){
        self.beijing.hidden = NO;
        zhi=4;
        return NO;
    }
    
    return YES;
}
- (IBAction)fenduan:(id)sender
{
    
    index = (int)_fenduan.selectedSegmentIndex;
    if (index == 0 ) {
        zhi = 1;
        self.qian.text=nil;
        self.hou.text=nil;
        [self.tableview reloadData];
    }
    else if(index == 1){
        zhi = 2;
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"dian"];
        _xiaodian.hidden=YES;
        [self huoqudaishenhe];
        self.qian.text=nil;
        self.hou.text=nil;
        [self.tableview reloadData];
    }

}
- (IBAction)queding:(id)sender
{
    //获取用户设置的时间
    NSDate *selected = [self.picker date];
    //创建一个日期格式器
    NSDateFormatter *dataFoematter = [[NSDateFormatter alloc]init];
    //为日期格式器设置格式字符串
    [dataFoematter setDateFormat:@"yyyy-MM-dd"];
    //使用日期格式器格式化时间
    NSString *destDateString = [dataFoematter stringFromDate:selected];
    
   
    
    self.beijing.hidden = YES;
    if (zhi == 3) {
        if ([_hou.text isEqualToString:@""]) {
           NSString* xiaode= [self compareOneDay:[NSDate date] withAnotherDay:[self dateFromString:destDateString]];
            
        self.qian.text = xiaode;

        }else {
            NSString* xiaode= [self compareOneDay:[self dateFromString:_hou.text] withAnotherDay:[self dateFromString:destDateString]];
            
            self.qian.text = xiaode;
        }
           }
    else if (zhi == 4){
        if ([_qian.text isEqualToString:@""]) {
            NSString* xiaode= [self compareOneDay:[NSDate date] withAnotherDay:[self dateFromString:destDateString]];
            
            self.hou.text = xiaode;
        }
        else{
            NSString* dade= [self compareOneDay:[self dateFromString:_qian.text] Day:[self dateFromString:destDateString]];
            NSString* xiaode= [self compareOneDay:[self dateFromString:dade] withAnotherDay:[NSDate date]];

        self.hou.text = xiaode;
        }
    }
}
- (IBAction)quxiao:(id)sender
{
     self.beijing.hidden = YES;
    
}
-(void)cha
{
    [WarningBox warningBoxModeIndeterminate:@"正在加载..." andView:self.view];
    NSString*loginUserID=[[yonghuziliao getUserInfo] objectForKey:@"id"];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString *url = @"/order/list";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
 
    //出入参数：
    
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:loginUserID,@"loginUserId",_qian.text,@"startDate",_hou.text,@"endDate", @"",@"state", @"1",@"pageNo",@"10",@"pageSize",nil];
    NSString*jsonstring=[writer stringWithObject:datadic];
   
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
    
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    
    
    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
            
            NSDictionary *datadic = [responseObject valueForKey:@"data"];
            zuobian=[datadic objectForKey:@"orderList"];
            zhi=1;
            [_tableview reloadData];
         
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"加载失败～" andView:self.view];
        
    }];
}
/**
 *  取小时间
 */
-(NSString*)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    
    if (result == NSOrderedDescending) {
       
        //Date1  is in the future ;
        return anotherDayStr;
    }
    else if (result == NSOrderedAscending){
        
        //Date1 is in the past ;
        return oneDayStr;
    }else{
        //Both dates are the same ;
       
        return oneDayStr;
    }
}
/**
 *  取大时间
 */
-(NSString*)compareOneDay:(NSDate *)oneDay Day:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    
    if (result == NSOrderedDescending) {
        
        //Date1  is in the future ;
        return oneDayStr;
    }
    else if (result == NSOrderedAscending){
        
        //Date1 is in the past ;
        return anotherDayStr;
    }else{
        //Both dates are the same ;
        
        return oneDayStr;
    }
}
/**
 *  NSString 转换成NSDate
 */
-(NSDate*)dateFromString:(NSString*)string
{
    
    //设置转换格式
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate*date=[formatter dateFromString:string];
    return date;
}
@end
