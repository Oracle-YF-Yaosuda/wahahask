//
//  XiangqingViewController.m
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "XiangqingViewController.h"
#import "Color+Hex.h"
#import "AFHTTPRequestOperationManager.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "SBJsonWriter.h"
#import "WarningBox.h"
#import "ZizunViewController.h"
#import "NSTimer+Addition.h"
#import "CycleScrollView.h"
#import "KeyboardToolBar.h"
#import "UIImageView+WebCache.h"

@interface XiangqingViewController ()<UITextFieldDelegate>
{
    CGFloat width;
    CGFloat height;
    NSMutableDictionary*shangpin;
    UITableViewCell *cell;
    UIImageView *image;
    NSString*stockNum;
    UITextField *shuru;
    NSArray*arr1;
    NSString *shuliangCunFang;
    NSMutableArray *array;
    NSMutableArray *array1;
    NSArray*zizhi;
}
@property(strong,nonatomic) UIScrollView *scrollView;

@property(strong,nonatomic) NSTimer *timer;
@property (nonatomic , retain) CycleScrollView *mainScorllView;
@end

@implementation XiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1   ];
    
    [self arraychuanjian];
    arr1  = [NSArray array];
    zizhi = [NSArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    shangpin=[[NSMutableDictionary alloc] init];
    //    创建数量存放
    shuliangCunFang=[NSString stringWithFormat:@"0"];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/productions";
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_shangID,@"productionsId", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            NSDictionary*data=[responseObject valueForKey:@"data"];
            NSLog(@"%@",responseObject);
            shangpin=(NSMutableDictionary*)[data objectForKey:@"productions"];
            NSString *pic = [shangpin objectForKey:@"pics"];
            NSString *zi  = [shangpin objectForKey:@"quapics"];
            zizhi= [zi  componentsSeparatedByString:@"|"];
            arr1 = [pic componentsSeparatedByString:@"|"];
            
           
            [array1 removeAllObjects];
            
            [array1 addObject:@" "];
            //商品编码
            if ([shangpin objectForKey:@"erpProId"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[shangpin objectForKey:@"erpProId"]];
            }
            
            //名称
            if ([shangpin objectForKey:@"proName"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"proName"]];
            }
            
            //剂型
            if ([shangpin objectForKey:@"dosageForm"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"dosageForm"]];
            }
            
            //规格
            if ([shangpin objectForKey:@"etalon"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"etalon"]];
            }
            
            //单位
            if ([shangpin objectForKey:@"unit"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"unit"]];
            }
            
            //通用名称
            if ([shangpin objectForKey:@"commonName"]==nil) {
                [array1 addObject:@""];
            }else{
            [array1 addObject:[shangpin objectForKey:@"commonName"]];
            }
                //通用名称编码
            if ([shangpin objectForKey:@"commonCode"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[shangpin objectForKey:@"commonCode"]];
            }
            
            //供应商
            if ([[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"provider"] objectForKey:@"corporateName"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"provider"] objectForKey:@"corporateName"]];
            }
            
            //联系人
            if ([shangpin objectForKey:[[shangpin objectForKey:@"provider"] objectForKey:@"linkman"]]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[shangpin objectForKey:@"provider"] objectForKey:@"linkman"]];
            }
            
            //联系电话
            if ([shangpin objectForKey:[[shangpin objectForKey:@"provider"] objectForKey:@"linkmanPhone"]]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[shangpin objectForKey:@"provider"] objectForKey:@"linkmanPhone"]];
            }
            
            //仓库地址
            if ([shangpin objectForKey:[[shangpin objectForKey:@"provider"] objectForKey:@"warehouseAddress"]]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[shangpin objectForKey:@"provider"] objectForKey:@"warehouseAddress"]];
            }
            
            //质量认证情况
            if ([shangpin objectForKey:[[shangpin objectForKey:@"provider"] objectForKey:@"certificate"]]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[shangpin objectForKey:@"provider"] objectForKey:@"certificate"]];
            }
            
           
            //质量机构负责人
            
            if ([shangpin objectForKey:[[shangpin objectForKey:@"provider"] objectForKey:@"certificateOfficer"]]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[shangpin objectForKey:@"provider"] objectForKey:@"certificateOfficer"]];
            }
            
            //生产企业
            if ([shangpin objectForKey:@"proEnterprise"]==nil) {
                [array1 addObject:@""];
            }
            else{
            [array1 addObject:[shangpin objectForKey:@"proEnterprise"]];
            }
            //药品说明书
            if ([shangpin objectForKey:@"specification"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[shangpin objectForKey:@"specification"]];
            }
            
                       //产地
            if ([shangpin objectForKey:@"place"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[shangpin objectForKey:@"place"]];
            }
            
         
            //是否是处方
            if ([shangpin objectForKey:@"isPrescription"]==nil) {
                [array1 addObject:@""];
            }else if([[shangpin objectForKey:@"isPrescription"] intValue]==1){
                [array1 addObject:@"处方"];
            }else{
                [array1 addObject:@"非处方"];
            }
            
            
            //批准文号
            if ( [shangpin objectForKey:@"auditingFileNo"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"auditingFileNo"]];
            }
            
            //质量标准
            if ([shangpin objectForKey:@"qualityStandard"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[shangpin objectForKey:@"qualityStandard"]];
            }
            
           
            //装箱规格
            if ([shangpin objectForKey:@"binningEtalon"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[shangpin objectForKey:@"binningEtalon"]];
            }
            
            
            //储存条件
            if ([shangpin objectForKey:@"storageCondition"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"storageCondition"]];
            }
            
            //批件有效期
            if ([shangpin objectForKey:@"approveDate"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[shangpin objectForKey:@"approveDate"]];
            }
            
         
            //特殊药品类型
            if ([shangpin objectForKey:@"specialDrugsType"]==nil) {
                [array1 addObject:@""];
            }else{
                [array1 addObject:[shangpin objectForKey:@"specialDrugsType"]];
            }
            
          
            //是否含麻黄碱
            if ([shangpin objectForKey:@"isEphedrine"]==nil) {
                [array1 addObject:@""];
            }else if([[shangpin objectForKey:@"isEphedrine"] intValue]==1){
                [array1 addObject:@"包含"];
                 }else{
                     [array1 addObject:@"不包含"];
                 }
            
          
            //是否是冷藏品
            if ([shangpin objectForKey:@"isColdStorage"]==nil) {
                [array1 addObject:@""];
        }else if([[shangpin objectForKey:@"isColdStorage"] intValue]==1)
            {
                [array1 addObject:@"冷藏"];
            }else{
                [array1 addObject:@"不冷藏"];
            }
            
            [_tableview reloadData];
            
        }else
        {
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        
    }];
    
    
    
    
}
-(void)arraychuanjian{
    
    array = [[NSMutableArray alloc]init];
    [array addObject:@"商品简介"];
    [array addObject:@"商品编码"];
    [array addObject:@"商品名称"];
    [array addObject:@"剂型"];
    [array addObject:@"规格"];
    [array addObject:@"单位"];
    [array addObject:@"通用名称"];
    [array addObject:@"通用名称编码"];
    [array addObject:@"供应商名称"];
    [array addObject:@"联系人"];
    [array addObject:@"联系电话"];
    [array addObject:@"仓库地址"];
    [array addObject:@"质量认证情况"];
    [array addObject:@"质量机构负责人"];
    [array addObject:@"生产企业"];
    [array addObject:@"药品说明书"];
    [array addObject:@"产地"];
    [array addObject:@"是否是处方"];
    [array addObject:@"批准文号"];
    [array addObject:@"质量标准"];
    [array addObject:@"装箱规格"];
    [array addObject:@"储存条件"];
    [array addObject:@"批件有效期"];
    [array addObject:@"特殊药品类型"];
    [array addObject:@"是否含麻黄碱"];
    [array addObject:@"是否是冷藏品"];
    //25
    array1 = [[NSMutableArray alloc]initWithArray:array];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3)
    {
        return array.count;
    }else
        
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 250;
    }
    else if(indexPath.section == 1)
    {
        return 85;
    }
    else if(indexPath.section == 2)
    {
        return 40;
    }
    else if(indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            return 35;
        }else
        {
            return 30;
        }
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 1;
    }
    else if(section == 2)
    {
        return 92;
    }
    else if (section == 3)
    {
        return 20;
    }
    return 0;
}
//编辑section
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewForHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 90)];
    viewForHeader.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    if(section == 2)
    {
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 15)];
        name.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        name.text = @"商品名称:";
        name.font = [UIFont systemFontOfSize:12];
        UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, width-20, 15)];
        name1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        name1.font = [UIFont systemFontOfSize:12];
        
        UILabel *changjia = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 60, 15)];
        changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        changjia.text = @"生产厂家:";
        changjia.font = [UIFont systemFontOfSize:12];
        UILabel *changjia1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, width-20, 15)];
        changjia1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        changjia1.font = [UIFont systemFontOfSize:12];
        
        UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 15)];
        guige.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        guige.text = @"规       格:";
        guige.font = [UIFont systemFontOfSize:12];
        UILabel *guige1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, width-20, 15)];
        guige1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        guige1.font = [UIFont systemFontOfSize:12];
        
        UILabel *danwei = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 60, 15)];
        danwei.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        danwei.text = @"单       位:";
        danwei.font = [UIFont systemFontOfSize:12];
        UILabel *danwei1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 70, width-20, 15)];
        danwei1.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        danwei1.font = [UIFont systemFontOfSize:12];
        
        //***************************
        if ([shangpin objectForKey:@"proName"]==nil) {
            name1.text=@"";
        }else{
            name1.text = [NSString stringWithFormat:@"%@",[shangpin objectForKey:@"proName"]];
        }
        
        if ([shangpin objectForKey:@"proEnterprise"]==nil) {
            changjia1.text=@"";
        }else{
        changjia1.text = [NSString stringWithFormat:@"%@",[shangpin objectForKey:@"proEnterprise"]];
        }
        if ([shangpin objectForKey:@"etalon"]==nil) {
            guige1.text=@"";
        }else{
            guige1.text = [NSString stringWithFormat:@"%@",[shangpin objectForKey:@"etalon"]];
        }
        if ([shangpin objectForKey:@"unit"]==nil) {
            danwei1.text=@"";
        }else{
            danwei1.text = [NSString stringWithFormat:@"%@",[shangpin objectForKey:@"unit"]];
        }
        
        
        //****************************
        [viewForHeader addSubview:name];
        [viewForHeader addSubview:name1];
        [viewForHeader addSubview:changjia];
        [viewForHeader addSubview:changjia1];
        [viewForHeader addSubview:guige];
        [viewForHeader addSubview:guige1];
        [viewForHeader addSubview:danwei];
        [viewForHeader addSubview:danwei1];
        return viewForHeader;
    }
    else
    {
        UIView *viewFor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
        viewFor.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
        return viewFor;
    }
}
-(void)tiao:(UIGestureRecognizer*)gg
{
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    
    if (indexPath.section == 0)
    {
        if (arr1.count==0) {
            self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, 250) animationDuration:3];
            //  demo里的scroll
            NSMutableArray *viewsArray = [[NSMutableArray alloc] init];
          
            for (int i = 0; i < 3; ++i)
            {
                UIImageView *tempLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 250)];
                
                tempLabel.image=[UIImage imageNamed:@"11121.jpg"];
                
                
                [viewsArray addObject:tempLabel];
                
            }
            
            self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
            
            self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex)
            {
                return viewsArray[pageIndex];
            };
            int s=3;
            self.mainScorllView.totalPagesCount = ^NSInteger(void)
            {
                return s;
            };
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex)
            {
             
            };
            [cell.contentView addSubview:self.mainScorllView];
            

        }else{
        //轮播
        //创建scrollview
        self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, 250) animationDuration:3];
        //  demo里的scroll
        NSMutableArray *viewsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < arr1.count; ++i)
        {
            UIImageView *tempLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 250)];
            NSString*lian=[NSString stringWithFormat:@"%@",service_host];
            NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",lian,arr1[1]]];
            //tempLabel.image=[UIImage imageNamed:@"3.png"];
            
            [tempLabel sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"11121.jpg"]];
            [viewsArray addObject:tempLabel];
            
        }
        
        self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex)
        {
            return viewsArray[pageIndex];
        };
        int s=(int)arr1.count;
        self.mainScorllView.totalPagesCount = ^NSInteger(void)
        {
            return s;
        };
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex)
        {
            NSLog(@"点击了第%ld个",pageIndex);
        };
        [cell.contentView addSubview:self.mainScorllView];
     
    }
    }
    else if (indexPath.section ==1)
    {
        
//        UILabel *shu = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
//        shu.textColor = [UIColor colorWithHexString:@"f36713" alpha:1];
//        shu.font = [UIFont systemFontOfSize:20];
        
        
        UILabel *biaoti = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, width-20, 42)];
        biaoti.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        biaoti.font = [UIFont systemFontOfSize:18];
        biaoti.numberOfLines = 0;
        
        
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(10,52, width-20, 1)];
        xian.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
        
        
        UILabel *shuliang= [[UILabel alloc]initWithFrame:CGRectMake(10, 59, 60, 21)];
        shuliang.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        shuliang.font = [UIFont systemFontOfSize:15];
        //      － 加
        UIButton *jia = [[UIButton alloc]initWithFrame:CGRectMake(width-30, 60, 20, 20)];
        [jia setImage:[UIImage imageNamed:@"@2x_sp_13.png"] forState:UIControlStateNormal];
        [jia addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
        //      － 减
        UIButton *jian = [[UIButton alloc]initWithFrame:CGRectMake(width-80, 60, 20, 20)];
        [jian setImage:[UIImage imageNamed:@"@2x_sp_11.png"] forState:UIControlStateNormal];
        [jian addTarget:self action:@selector(jia) forControlEvents:UIControlEventTouchUpInside];
        
        //     －加减的数量
        shuru = [[UITextField alloc]initWithFrame:CGRectMake(width-60, 60, 30,20)];
        shuru.text = shuliangCunFang;
        shuru.delegate=self;
        shuru.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        shuru.textAlignment = NSTextAlignmentCenter;
        shuru.borderStyle=UITextBorderStyleNone;
        shuru.delegate=self;
        shuru.keyboardType = UIKeyboardTypeNumberPad;
        //键盘添加完成
        [KeyboardToolBar registerKeyboardToolBar:shuru];

        
        
        biaoti.text = [NSString stringWithFormat:@"%@",array1[2]];
        shuliang.text = @"数量";
        
       // [cell.contentView addSubview:shu];
        [cell.contentView addSubview:biaoti];
        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:shuliang];
        [cell.contentView addSubview:jia];
        [cell.contentView addSubview:jian];
        [cell.contentView addSubview:shuru];
    }
    
    else if (indexPath.section == 2)
    {
        
        UILabel *chanpinzizhi = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 100, 21)];
        chanpinzizhi.font = [UIFont systemFontOfSize:15];
        chanpinzizhi.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        chanpinzizhi.text = @"产品资质";
        UIButton *tu = [[UIButton alloc]initWithFrame:CGRectMake(width-21, 15, 11, 15)];
        [tu setImage:[UIImage imageNamed:@"iconcc.png"] forState:UIControlStateNormal];
        
        
        [cell.contentView addSubview:chanpinzizhi];
        [cell.contentView addSubview:tu];
    }
    
    else if (indexPath.section == 3)
    {
        UILabel *leftlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 30)];
        leftlabel1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        leftlabel1.font = [UIFont systemFontOfSize:13];
        leftlabel1.text = array[indexPath.row];
        
        UILabel *rightLable1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, width-120, 30)];
        rightLable1.textColor= [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        rightLable1.font = [UIFont systemFontOfSize:13];
        rightLable1.text = array1[indexPath.row];
        
        if (indexPath.row == 0)
        {
            leftlabel1.frame= CGRectMake(10, 2, width, 30);
            leftlabel1.font = [UIFont systemFontOfSize:15];
            
            UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(10, 34, width-20, 1.5)];
            xian1.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1 ];
            [cell.contentView addSubview:leftlabel1];
            [cell.contentView addSubview:xian1];
        }else
        {
            
            [cell.contentView addSubview:leftlabel1];
            [cell.contentView addSubview:rightLable1];
            
        }
    }
    
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2)
    {
        ZizunViewController *zixun = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"zixun"];
        zixun.quanshitu=zizhi;
        //zixun.quanshitu=[NSArray arrayWithObjects:@"1",@"2",@"3", nil];
        [self.navigationController pushViewController:zixun animated:YES];
    }
    
}

-(void)jian
{
    int shu= [shuru.text intValue];
    if(shu<1000)
    {
        shuru.text=[NSString stringWithFormat:@"%d",shu+1];
        shuliangCunFang=shuru.text;
    }
    [shuru resignFirstResponder];
}

-(void)jia
{
    
    int shu= [shuru.text intValue];
    if(shu==0)
    {
        
        
    }else
    {
        
        shuru.text=[NSString stringWithFormat:@"%d",shu-1];
        shuliangCunFang=shuru.text;
    }
    
    [shuru resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [shuru resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    [shuru becomeFirstResponder];
    return YES;
}
- (IBAction)tianjia:(id)sender
{
    if ([shuru.text isEqualToString:@""]||[shuru.text isEqualToString: @"0"]) {
        [WarningBox warningBoxModeText:@"购买数量太少了哟!" andView:self.view];
    }else{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/stockNum";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];

    
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_shangID,@"productionsId", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*data=[responseObject objectForKey:@"data"];
        stockNum=[data objectForKey:@"stockNum"];
        if ([stockNum intValue]-[shuru.text intValue]<0) {
            NSString*message=[NSString stringWithFormat:@"您选择了%@件商品，当前剩余库存为%@件",shuru.text,stockNum];
            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"库存不足" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            UIAlertAction*action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
            
            
        }
        else{
            NSMutableArray *arr=[NSMutableArray array] ;
            NSString *path=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
            NSFileManager *file=[NSFileManager defaultManager];
            
            //         添加数量
            NSMutableDictionary*dd=[NSMutableDictionary dictionaryWithDictionary:shangpin];
            
            [dd setObject:shuliangCunFang forKey:@"shuliang"];
            //    判断
            if([file fileExistsAtPath:path])
            {
                
                //   获取文件里的数据
                arr=[NSMutableArray arrayWithContentsOfFile:path];
                
                [arr addObject:dd];
                
                [arr writeToFile:path atomically:YES];
                [WarningBox warningBoxModeText:@"添加成功～" andView:self. navigationController.view];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                
                
                [arr addObject:dd];
                [arr writeToFile:path atomically:YES];
                [WarningBox warningBoxModeText:@"添加成功～" andView:self. navigationController.view];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        
    }];
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@""]){
        
        NSString*yuanlai=[NSString stringWithFormat:@"%@",shuliangCunFang];
        int x=[yuanlai intValue]/10;
        
        shuliangCunFang=[NSString stringWithFormat:@"%d",x];
        
      
        
    }else {
        
        NSString*yuanlai=[NSString stringWithFormat:@"%@",shuliangCunFang];
        int x=[yuanlai intValue]*10+[string intValue];
        yuanlai=[NSString stringWithFormat:@"%d",x];
        
        shuliangCunFang=yuanlai;
  
        
    }

 
    
    return YES;
    
}
- (IBAction)fanhui:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
