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
}
@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) UIPageControl *pageControl;
@property(strong,nonatomic) NSTimer *timer;
@property (nonatomic , retain) CycleScrollView *mainScorllView;
@end

@implementation XiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
  shangpin=[[NSMutableDictionary alloc] init];
//    创建数量存放
    shuliangCunFang=[NSString stringWithFormat:@"0"];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource =self;

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
            NSLog(@"---%@",shangpin);
            
            [_tableview reloadData];
            
            
            
        }else{
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 250;
    }
    else if(indexPath.section == 1){
        return 105;
    }
    else if(indexPath.section == 2){
    return 40;
    }
    else if(indexPath.section == 3){
        return 155;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if(section == 1) {
        return 1;
    }
    else if(section == 2){
        return 92;
    }
    else if (section == 3){
        return 20;
    }
    return 0;
}
//编辑section
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewForHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 90)];
    viewForHeader.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    if(section == 2){
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
    
    }
    return viewForHeader;
}
-(void)tiao:(UIGestureRecognizer*)gg{
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"cell1";
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    
    if (indexPath.section == 0) {
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
        NSMutableArray *viewsArray = [@[] mutableCopy];
        
        for (int i = 0; i < 5; ++i) {
            UIImageView *tempLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 250)];
            tempLabel.image=[UIImage imageNamed:@"3.png"];
            
            [viewsArray addObject:tempLabel];
            
            
        }
        
        
        self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        self.mainScorllView.totalPagesCount = ^NSInteger(void){
            return 5;
        };
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%ld个",pageIndex);
        };
         [cell.contentView addSubview:self.mainScorllView];
        [cell.contentView addSubview:self.pageControl];
        [cell.contentView bringSubviewToFront:self.pageControl];

    
        
        

    }
    else if (indexPath.section ==1){
        
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
    
    else if (indexPath.section == 2){
        
        UILabel *chanpinzizhi = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 100, 21)];
        chanpinzizhi.font = [UIFont systemFontOfSize:14];
        chanpinzizhi.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        chanpinzizhi.text = @"产品资质";
        UIButton *tu = [[UIButton alloc]initWithFrame:CGRectMake(width-21, 15, 11, 15)];
        [tu setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
        
        
        [cell.contentView addSubview:chanpinzizhi];
        [cell.contentView addSubview:tu];
    }
    
    else if (indexPath.section == 3){
        
        UILabel *jianjie = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, width, 21)];
        jianjie.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        jianjie.font = [UIFont systemFontOfSize:14];
        jianjie.numberOfLines = 0;
        jianjie.text = @"商品简介";
        
        
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(10, 26, width-20, 1)];
        xian.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];

        UILabel *mingcheng = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, 100, 20)];
        mingcheng.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
        mingcheng.font = [UIFont systemFontOfSize:10];
        mingcheng.numberOfLines = 0;
        mingcheng.text = @"商品名称";
        UILabel *mingcheng1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 29, 100, 20)];
        mingcheng1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        mingcheng1.font = [UIFont systemFontOfSize:10];
        mingcheng1.numberOfLines = 0;
        
        UILabel *jixing = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 100, 21)];
        jixing.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
        jixing.font = [UIFont systemFontOfSize:10];
        jixing.numberOfLines = 0;
        jixing.text = @"剂型";
        UILabel *jixing1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 45, 100, 21)];
        jixing1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        jixing1.font = [UIFont systemFontOfSize:10];
        jixing1.numberOfLines = 0;
        
        UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(10, 61, 100, 21)];
        guige.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
        guige.font = [UIFont systemFontOfSize:10];
        guige.numberOfLines = 0;
        guige.text = @"规格";
        UILabel *guige1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 61, 100, 21)];
        guige1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        guige1.font = [UIFont systemFontOfSize:10];
        guige1.numberOfLines = 0;

        UILabel *gongying = [[UILabel alloc]initWithFrame:CGRectMake(10, 77, 100, 21)];
        gongying.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
        gongying.font = [UIFont systemFontOfSize:10];
        gongying.numberOfLines = 0;
        gongying.text = @"供应商";
        UILabel *gongying1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 77, 100, 21)];
        gongying1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        gongying1.font = [UIFont systemFontOfSize:10];
        gongying1.numberOfLines = 0;

        UILabel *qiye = [[UILabel alloc]initWithFrame:CGRectMake(10, 93, 100, 21)];
        qiye.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
        qiye.font = [UIFont systemFontOfSize:10];
        qiye.numberOfLines = 0;
        qiye.text = @"生产企业";
        UILabel *qiye1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 93, 100, 21)];
        qiye1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        qiye1.font = [UIFont systemFontOfSize:10];
        qiye1.numberOfLines = 0;

        UILabel *tongyongming = [[UILabel alloc]initWithFrame:CGRectMake(10, 109, 100, 21)];
        tongyongming.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
        tongyongming.font = [UIFont systemFontOfSize:10];
        tongyongming.numberOfLines = 0;
        tongyongming.text = @"通用名称";
        UILabel *tongyongming1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 109, 100, 21)];
        tongyongming1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        tongyongming1.font = [UIFont systemFontOfSize:10];
        tongyongming1.numberOfLines = 0;

        UILabel *TYbianma = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 100, 21)];
        TYbianma.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
        TYbianma.font = [UIFont systemFontOfSize:10];
        TYbianma.numberOfLines = 0;
        TYbianma.text = @"通用名称编码";
        UILabel *TYbianma1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 110, 100, 21)];
        TYbianma1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        TYbianma1.font = [UIFont systemFontOfSize:10];
        TYbianma1.numberOfLines = 0;
        
        UILabel *chufang = [[UILabel alloc]initWithFrame:CGRectMake(10, 126, 100, 21)];
        chufang.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
        chufang.font = [UIFont systemFontOfSize:10];
        chufang.numberOfLines = 0;
        chufang.text = @"是否是处方";
        UILabel *chufang1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 126, 100, 21)];
        chufang1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        chufang1.font = [UIFont systemFontOfSize:10];
        chufang1.numberOfLines = 0;

        
        mingcheng1.text = @"通用名称编码";
        jixing1.text = @"3213211";
        guige1.text = @"";
        gongying1.text = @"";
        qiye1.text = @"";
        tongyongming1.text = @"";
        TYbianma1.text = @"";
        chufang1.text = @"";
        
        [cell.contentView addSubview:jianjie];
        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:mingcheng];
        [cell.contentView addSubview:mingcheng1];
        [cell.contentView addSubview:jixing];
        [cell.contentView addSubview:jixing1];
        [cell.contentView addSubview:guige];
        [cell.contentView addSubview:guige1];
        [cell.contentView addSubview:gongying];
        [cell.contentView addSubview:gongying1];
        [cell.contentView addSubview:qiye];
        [cell.contentView addSubview:qiye1];
        [cell.contentView addSubview:TYbianma];
        [cell.contentView addSubview:TYbianma1];
        [cell.contentView addSubview:chufang];
        [cell.contentView addSubview:chufang1];
    }
    
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
      
        ZizunViewController *zixun = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"zixun"];
        [self.navigationController pushViewController:zixun animated:YES];
    }
    
}

-(void)jian{
   int shu= [shuru.text intValue];
    if(shu<1000){
    shuru.text=[NSString stringWithFormat:@"%d",shu+1];
        shuliangCunFang=shuru.text;
    }
    [shuru resignFirstResponder];
}
-(void)jia{
    
    int shu= [shuru.text intValue];
    if(shu==0){
       
        
    }else{
        
         shuru.text=[NSString stringWithFormat:@"%d",shu-1];
        shuliangCunFang=shuru.text;
    }
    
      [shuru resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [shuru resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
     [shuru becomeFirstResponder];
    return YES;
}
- (IBAction)tianjia:(id)sender {
    
    NSMutableArray *arr=[NSMutableArray array] ;
    NSString *path=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
    NSFileManager *file=[NSFileManager defaultManager];
    
    //         添加数量
    NSMutableDictionary*dd=[NSMutableDictionary dictionaryWithDictionary:shangpin];
    
    [dd setObject:shuliangCunFang forKey:@"shuliang"];
//    判断
    if([file fileExistsAtPath:path]){
       

        
  //        获取文件里的数据
  
        arr=[NSMutableArray arrayWithContentsOfFile:path];
    

     
       
    
//   判断输入的是否为0
        if([shuliangCunFang isEqualToString:@"0"]){
          
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
        if([shuliangCunFang isEqualToString:@"0"]){
           
        }
  else
        {
            [arr addObject:dd];
        [arr writeToFile:path atomically:YES];
        
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
@end
