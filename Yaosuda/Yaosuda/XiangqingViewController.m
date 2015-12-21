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

@interface XiangqingViewController ()<UITextFieldDelegate>
{
    CGFloat width;
    CGFloat height;
    NSMutableDictionary*shangpin;
    UITableViewCell *cell;
    UIImageView *image;
    UITextField *shuru;
    NSString *shuliangCunFang;
    NSMutableArray *array;
    NSMutableArray *array1;
}
@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) UIPageControl *pageControl;
@property(strong,nonatomic) NSTimer *timer;
@property (nonatomic , retain) CycleScrollView *mainScorllView;
@end

@implementation XiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self arraychuanjian];
    
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
   
    
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
           
            shangpin=(NSMutableDictionary*)[data objectForKey:@"productions"];
            
            [array1 removeAllObjects];
            
            [array1 addObject:@" "];
            //商品编码
            [array1 addObject:@"12"];
            //名称
            [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"proName"]];
            //剂型
            [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"dosageForm"]];
            //规格
            [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"erpProId"]];
            //单位
            [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"unit"]];
            //通用名称
            [array1 addObject:@"17"];
            //通用名称编码
            [array1 addObject:@"18"];
            //供应商
            [array1 addObject:[[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"provider"] objectForKey:@"corporateName"]];
            //联系人
            [array1 addObject:@"110"];
            //联系电话
            [array1 addObject:@"111"];
            //仓库地址
            [array1 addObject:@"112"];
            //质量认证情况
            [array1 addObject:@"113"];
            //质量机构负责人
            [array1 addObject:@"114"];
            //生产企业
            [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"proEnterprise"]];
            //药品说明书
            [array1 addObject:@"116"];
            //产地
            [array1 addObject:@"117"];
            //是否是处方
            [array1 addObject:@"118"];
            //批准文号
            [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"auditingFileNo"]];
            //质量标准
            [array1 addObject:@"120"];
            //装箱规格
            [array1 addObject:@"121"];
            //储存条件
            [array1 addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"storageCondition"]];
            //批件有效期
            [array1 addObject:@"123"];
            //特殊药品类型
            [array1 addObject:@"124"];
            //是否含麻黄碱
            [array1 addObject:@"125"];
            //是否是冷藏品
            [array1 addObject:@"127"];
            
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
        return 105;
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
        
        name1.text = [NSString stringWithFormat:@"%@",[shangpin objectForKey:@"proName"]];
        changjia1.text = [NSString stringWithFormat:@"%@",[shangpin objectForKey:@"proEnterprise"]];
        guige1.text = [NSString stringWithFormat:@"%@",[shangpin objectForKey:@"etalon"]];
        danwei1.text = [NSString stringWithFormat:@"%@",[shangpin objectForKey:@"unit"]];
        
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
        return nil;
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
        //轮播
        //创建scrollview
        self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, 250) animationDuration:3];
        
        //穿件uipageconrol
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 230, width, 10)];
        //设置uipageconrol的圆点颜色
        self.pageControl.pageIndicatorTintColor = [UIColor redColor];
        //设置uipageconrol的高亮圆点颜色
        self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        //设置uipagecontrol控件当前显示第几页
        self.pageControl.currentPage = 0;
        // 设置uipageconcrol控件总共包含几页
        self.pageControl.numberOfPages = 4;
        self.pageControl.hidesForSinglePage = YES;
 
        //  demo里的scroll
        NSMutableArray *viewsArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 5; ++i)
        {
            UIImageView *tempLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 250)];
            tempLabel.image=[UIImage imageNamed:@"3.png"];
            
            [viewsArray addObject:tempLabel];
            
        }
        
        self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex)
        {
            return viewsArray[pageIndex];
        };
        self.mainScorllView.totalPagesCount = ^NSInteger(void)
        {
            return 5;
        };
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex)
        {
            NSLog(@"点击了第%ld个",pageIndex);
        };
        [cell.contentView addSubview:self.mainScorllView];
        [cell.contentView addSubview:self.pageControl];
        [cell.contentView bringSubviewToFront:self.pageControl];
    }
    else if (indexPath.section ==1)
    {
        
        UILabel *shu = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
        shu.textColor = [UIColor colorWithHexString:@"f36713" alpha:1];
        shu.font = [UIFont systemFontOfSize:20];
        
        
        UILabel *biaoti = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, width-20, 42)];
        biaoti.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        biaoti.font = [UIFont systemFontOfSize:14];
        biaoti.numberOfLines = 0;
       
        
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(10, 72, width-20, 1)];
        xian.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
        

        UILabel *shuliang= [[UILabel alloc]initWithFrame:CGRectMake(10, 79, 60, 21)];
        shuliang.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        shuliang.font = [UIFont systemFontOfSize:14];
//      － 加
        UIButton *jia = [[UIButton alloc]initWithFrame:CGRectMake(width-30, 80, 20, 20)];
        [jia setImage:[UIImage imageNamed:@"@2x_sp_11.png"] forState:UIControlStateNormal];
         [jia addTarget:self action:@selector(jia) forControlEvents:UIControlEventTouchUpInside];
//      － 减
        UIButton *jian = [[UIButton alloc]initWithFrame:CGRectMake(width-80, 80, 20, 20)];
        [jian setImage:[UIImage imageNamed:@"@2x_sp_13.png"] forState:UIControlStateNormal];
         [jian addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
        
 //     －加减的数量
        shuru = [[UITextField alloc]initWithFrame:CGRectMake(width-60, 80, 30,20)];
        shuru.text = shuliangCunFang;
        shuru.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        shuru.textAlignment = NSTextAlignmentCenter;
        shuru.borderStyle=UITextBorderStyleNone;
        shuru.delegate=self;

        
        shu.text = @"￥88.88";
        biaoti.text = @"惠氏 善存 多维元素片 惠氏 善存 多维元素片 惠氏 善存 多维元素片 惠氏 善存 多维元素片";
        shuliang.text = @"数量";
        
        [cell.contentView addSubview:shu];
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
        chanpinzizhi.font = [UIFont systemFontOfSize:14];
        chanpinzizhi.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        chanpinzizhi.text = @"产品资质";
        UIButton *tu = [[UIButton alloc]initWithFrame:CGRectMake(width-21, 15, 11, 15)];
        [tu setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
        
        
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
//   判断输入的是否为0
        if([shuliangCunFang isEqualToString:@"0"])
        {
          
     }
        
   else
       
     {
      
       [arr addObject:dd];
         NSLog(@"%@",arr);
         NSLog(@"%@",dd);
         
        [arr writeToFile:path atomically:YES];
            
        }
    }
    else{
      
//        也判断一下是否为添加的是否为0
        if([shuliangCunFang isEqualToString:@"0"])
        {
           
        }
  else
        {
            [arr addObject:dd];
        [arr writeToFile:path atomically:YES];
        
        }
        
    }
    
}
@end
