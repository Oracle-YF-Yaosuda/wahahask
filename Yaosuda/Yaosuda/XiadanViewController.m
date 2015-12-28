//
//  XiadanViewController.m
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
#import "XiadanViewController.h"
#import "Color+Hex.h"
#import "KehuViewController.h"
#import "QuerenViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "WarningBox.h"
#import "yonghuziliao.h"
#import "SBJsonWriter.h"
#import "lianjie.h"
#import "hongdingyi.h"


@interface XiadanViewController ()
{
    
    CGFloat width;
    CGFloat height;
    NSMutableArray *jieshou;
    NSMutableArray*arr;
    NSMutableArray *jiage;
    NSMutableDictionary *dicc;
    UIBarButtonItem *right;
    UIBarButtonItem *right1;
   
    int aa;
    
    UIButton *jia;
    UIButton *jian;
    NSMutableArray *xiuGaiShangPin;
    UIView * di;
}

@end

@implementation XiadanViewController

-(void)passTrendValue:(NSArray *)values
{
    
    NSString *path =[NSHomeDirectory() stringByAppendingString:@"/Documents/xiadanmingxi.plist"];
    NSFileManager*fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [values writeToFile:path atomically:YES];
    }
    
    else{
        
        NSMutableArray*arp=[NSMutableArray arrayWithContentsOfFile:path];
        NSArray*guo=[NSArray arrayWithArray:values];
        for (NSDictionary*d in guo) {
            [arp addObject:d];
        }
        [arp writeToFile:path atomically:YES];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
//   数量修改
    xiuGaiShangPin=[NSMutableArray array];
    di.hidden = YES;
    aa = 1;
    
    //接取商品价格
    jiage=[NSMutableArray array];
    //接受订单数据
    NSString*path=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
    jieshou=[[NSMutableArray alloc] init];
    jieshou=[NSMutableArray arrayWithContentsOfFile:path];
    NSLog(@"  jiesou--------- %@",jieshou);
    
    NSMutableArray*wo=[NSMutableArray array];
    for (int i=0; i<jieshou.count; i++) {
        [wo addObject:[jieshou[i] objectForKey:@"shuliang"]];
    }
//    NSString*pp=[NSString stringWithFormat:@"%@/Documents/guodu.plist",NSHomeDirectory()];
//    [wo writeToFile:pp atomically:YES];
    //接受客户数据
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    NSDictionary*kehuxinxi=[NSDictionary dictionaryWithContentsOfFile:pathkehu];
    
    
    NSFileManager*fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:pathkehu]) {
        _kehumingzi.text=@"请选择客户";
        jieshou=[NSMutableArray array];
    }
    else{
        _kehumingzi.text=[[NSDictionary dictionaryWithContentsOfFile:pathkehu] objectForKey:@"customerName"];
    
     
    //用户id
    NSString*businesspersonId=[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"];
    //提取客户id
    NSString*kehuID=[NSString stringWithFormat:@"%@",[kehuxinxi objectForKey:@"id"]];
    if (kehuID!=nil&&![kehuID isEqual:[NSNull null]]) {
        
    //[WarningBox warningBoxModeIndeterminate:@"数据加载中..." andView:self.view];
    for (int i=0; i<jieshou.count; i++) {
      
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/prod/priceByNum";
        
        //时间戳
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        NSDate *datenow = [NSDate date];
        NSString *nowtimeStr = [formatter stringFromDate:datenow];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter* writer=[[SBJsonWriter alloc] init];
        //数量
        NSString*acount=[NSString stringWithFormat:@"%@",[jieshou[i] objectForKey:@"shuliang"]];
        //商品id
        NSString*shangpinID= [ NSString stringWithFormat:@"%@",[jieshou[i] objectForKey:@"id"]];
        //出入参数：
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",businesspersonId],@"businesspersonId",acount,@"acount",kehuID,@"customerId",shangpinID,@"productionsId", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
       
       
        //需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                NSDictionary*data=[responseObject objectForKey:@"data"];
                NSString*customerPrice=[NSString stringWithFormat:@"%@",[data objectForKey:@"customerPrice"]];
                [dicc setObject:customerPrice forKey:[NSString stringWithFormat:@"%d",i]];
                [jiage addObject:@"1"];

            }
            [_tableview reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络连接失败～" andView:self.view];
                   }];
       }
      }
    }[_tableview reloadData];
    
}
- (void)viewDidLoad
{
    
    dicc=[NSMutableDictionary dictionary];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    
    
    right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(bianij)];
    right1 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(baocun)];
     self.navigationItem.rightBarButtonItem = right;
}

-(void)bianij
{
    aa=2;
    self.navigationItem.rightBarButtonItem = right1;
    [self.tableview reloadData];
    
    di = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    di.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
    UIButton *quan = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [quan addTarget:self action:@selector(xiaoshi) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *iam = [[UIImageView alloc]initWithFrame:CGRectMake(50, 200, width-100, 100)];
    iam.image = [UIImage imageNamed:@"huadong.png"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 320, width, 25)];
    lab.font = [UIFont systemFontOfSize:17];
    lab.textColor = [UIColor redColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"*  向左侧拉删除";

    [self.view addSubview:di];
    [di addSubview:quan];
    [quan addSubview:iam];
    [quan addSubview:lab];
    
    
  
}
-(void)baocun
{
    di.hidden=YES;
    aa=1;
    self.navigationItem.rightBarButtonItem = right;
    
//  保存plist文件 重新写入
    NSString*path=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
    [jieshou writeToFile:path atomically:YES];
 
    [self.tableview reloadData];
    [self viewWillAppear:YES];
}
-(void)xiaoshi
{
    
    di.hidden = YES;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return jieshou.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;//section高度
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *diview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    diview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return diview;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;//cell高度
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell";
   
    
   UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
    name.text = @"商品名称:";
    name.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    name.font = [UIFont systemFontOfSize:15];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 35, width, 1)];
    xian.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, width-40-80, 30 )];
    name1.text = [NSString stringWithFormat:@"%@", [jieshou[indexPath.row] objectForKey:@"proName"]];
    name1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    name1.font = [UIFont systemFontOfSize:15];
    name1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *shuliang = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 80, 30)];
    shuliang.text = @"商品数量:";
    shuliang.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    shuliang.font = [UIFont systemFontOfSize:15];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, width, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    
   UITextField* shuliang1 = [[UITextField alloc]initWithFrame:CGRectMake(100, 40, width-40-80, 30 )];
    shuliang1.delegate=self;
    shuliang1.tag=(int)indexPath.row+999;
    shuliang1.text = [NSString stringWithFormat:@"%@",[jieshou[indexPath.row] objectForKey:@"shuliang"]];
    shuliang1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    shuliang1.font = [UIFont systemFontOfSize:15];
    shuliang1.textAlignment = NSTextAlignmentCenter;
    shuliang1.delegate=self;
    
    UILabel *danjia = [[UILabel alloc]initWithFrame:CGRectMake(20, 75, 80, 30)];
    danjia.text = @"客户单价:";
    danjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    danjia.font = [UIFont systemFontOfSize:15];
    
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(0, 105, width, 1)];
    xian2.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    
    UILabel *danjia1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 75, width-40-80, 30 )];
    
    if (jiage.count!=jieshou.count) {
        danjia1.text=@"待估价";
        
        danjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        danjia1.font = [UIFont systemFontOfSize:15];
        danjia1.textAlignment = NSTextAlignmentCenter;
    }
    else{
    danjia1.text =[dicc objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];

    danjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    danjia1.font = [UIFont systemFontOfSize:15];
    danjia1.textAlignment = NSTextAlignmentCenter;
    }
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, width, 10)];
    xian3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    UILabel *LXdanjia = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 80, 30)];
    LXdanjia.text = @"联系人单价:";
    LXdanjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    LXdanjia.font = [UIFont systemFontOfSize:15];

    UILabel *LXdanjia1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 110, width-40-80, 30 )];
    
    if (jiage.count!=jieshou.count) {
        LXdanjia1.text=@"待估价";
        LXdanjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        LXdanjia1.font = [UIFont systemFontOfSize:15];
        LXdanjia1.textAlignment = NSTextAlignmentCenter;
    }
    else{
        LXdanjia1.text =[dicc objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        
        LXdanjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        LXdanjia1.font = [UIFont systemFontOfSize:15];
        LXdanjia1.textAlignment = NSTextAlignmentCenter;
    }

    
    
    
    if (aa == 1)
    {
        
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:name1];
        [cell.contentView addSubview:xian];
        
        [cell.contentView addSubview:shuliang];
        [cell.contentView addSubview:shuliang1];
        [cell.contentView addSubview:xian1];
        
        [cell.contentView addSubview:danjia];
        [cell.contentView addSubview:danjia1];
        [cell.contentView addSubview:xian2];
        
        [cell.contentView addSubview:LXdanjia];
        [cell.contentView addSubview:LXdanjia1];
        [cell.contentView addSubview:xian3];

    }
    else if (aa == 2)
    {
        //   减创建
        jian = [[UIButton alloc]initWithFrame:CGRectMake(width/3*1.5,50 , 20, 20)];
        [jian setImage:[UIImage imageNamed:@"@2x_sp_11.png"] forState:UIControlStateNormal];
        [jian addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
        jian.tag=indexPath.row+20000;
        //   加创建
        jia = [[UIButton alloc]initWithFrame:CGRectMake(width/3*1.5+60, 50, 20, 20)];
        [jia setImage:[UIImage imageNamed:@"@2x_sp_13.png"] forState:UIControlStateNormal];
        [jia addTarget:self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
        jia.tag=indexPath.row+10000 ;

        [cell.contentView addSubview:name];
        [cell.contentView addSubview:name1];
        [cell.contentView addSubview:xian];
        
        [cell.contentView addSubview:shuliang];
        [cell.contentView addSubview:shuliang1];
        [cell.contentView addSubview:xian1];
        
        [cell.contentView addSubview:danjia];
        [cell.contentView addSubview:danjia1];
        [cell.contentView addSubview:xian2];
        
        [cell.contentView addSubview:LXdanjia];
        [cell.contentView addSubview:LXdanjia1];
        [cell.contentView addSubview:xian3];

        [cell.contentView addSubview:jia];
        [cell.contentView addSubview:jian];
        
    }
    
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (aa == 2) {
        
        return YES;
    }
    return NO;
}
- (IBAction)fanhui:(id)sender {
    if (aa!=2) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [WarningBox warningBoxModeText:@"请保存您的操作！" andView:self.view];
    
}
- (IBAction)queren:(id)sender {
  
    if (jiage.count==0) {
        [WarningBox warningBoxModeText:@"请选择商品及客户！" andView:self.view];
    }else{
    float m;
        
        for (NSString* a in [dicc allValues]) {
            m+=[a intValue];
       
        }
        
        NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
        NSDictionary*kehu=[NSDictionary dictionaryWithContentsOfFile:pathkehu];
        NSString*customerId=[NSString stringWithFormat:@"%@",[kehu objectForKey:@"id"]];
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/orderdict/consign";
        
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
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:customerId,@"customerId", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        
        //需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        
        [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                NSDictionary*data=[responseObject valueForKey:@"data"];
                NSArray*consignList=[data objectForKey:@"consignList"];
                QuerenViewController *qu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"queren"];
                
                qu.xixi=[NSString stringWithFormat:@"%@",[consignList[0] objectForKey:@"customerdepotId"]];
                qu.haha=[NSString stringWithFormat:@"%@",[consignList[0] objectForKey:@"contactPerson"]];
                qu.meme =[NSString stringWithFormat:@"%.2f元",m];
                [self.navigationController pushViewController:qu animated:YES];

                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
           
        }];
   
       }
}

#pragma mark - 滑动删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
    if(aa==2){
        return  UITableViewCellEditingStyleDelete;   //返回此值时,Cell上不会出现Delete按键,即Cell不做任何响应
  
    }else{
        return UITableViewCellEditingStyleNone;
       }
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath //对选中的Cell根据editingStyle进行操作
{
    if (aa == 2) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            //删除字典内容
            
            [jieshou removeObjectAtIndex:indexPath.row];
          
            [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
             [self.tableview reloadData];
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
            [self.tableview reloadData];
        }
        
    }
 }
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//按钮起名
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


-(void)jia:(UIButton*)tt{
    [self.view endEditing:YES];
    UITableViewCell *cell=(UITableViewCell*)[[tt superview] superview ];
    
    NSIndexPath *index=[self.tableview indexPathForCell:cell];
   
    UILabel*oo=[cell viewWithTag:index.row+999];
   
    NSString*qw=oo.text;
    
    int wq=[qw intValue];
    
    qw =[NSString stringWithFormat:@"%d", wq+1];
    
    oo.text=qw;

//  存入jieshou数组中
    [jieshou[index.row] setObject:qw forKey:@"shuliang"];
    
    
    
}

-(void)jian:(UIButton*)tt{
    [self.view endEditing:YES];
    UITableViewCell *cell=(UITableViewCell*)[[tt superview] superview ];
    
    NSIndexPath *index=[self.tableview indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+999];
    
    NSString*qw=oo.text;
    
    int wq=[qw intValue];
    if ([oo.text intValue]==1) {
        
    }else
    qw =[NSString stringWithFormat:@"%d", wq-1];
    
    oo.text=qw;
    //  存入jieshou数组中
    [jieshou[index.row] setObject:qw forKey:@"shuliang"];

}


@end
