//
//  XuanzeViewController.m
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "XuanzeViewController.h"
#import "Color+Hex.h"
#import "XiangqingViewController.h"
#import "hongdingyi.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJsonWriter.h"
#import "WarningBox.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "XiadanViewController.h"
#import "MJRefresh.h"
#import "KeyboardToolBar.h"
#import "yonghuziliao.h"


#define ziticolor [UIColor colorWithHexString:@"3c3c3c" alpha:1];
#define zitifont [UIFont systemFontOfSize:13];
@interface XuanzeViewController ()<UITextFieldDelegate>
{
    NSMutableArray*jiahao;
    NSMutableArray*shuzi;
    CGFloat width;
    NSString*tupian;
    CGFloat height;
    UIButton *jian;
    UIButton *tianjia;
    UILabel *shuru;
    NSMutableArray*chuande;
    NSArray*productionsList;
    UIButton *jia ;
    NSString*count;
    int ye;
    NSMutableArray*xiaolv;
    
//  数组中存放各个产品的下单  数量
    NSMutableArray *xiadanshuliang;
    
}
@property(strong , nonatomic)UIImageView *imagr;
@end

@implementation XuanzeViewController

//取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    _search.showsCancelButton=NO;
    [self diaoyong:searchBar.text];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
    }
    return YES;
}
//按键搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self diaoyong:searchBar.text];
    _search.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    xiaolv =[ NSMutableArray array];
    _search.delegate=self;
    _search.showsCancelButton=NO;

    shuzi=[NSMutableArray array];
    jiahao=[NSMutableArray array];
    chuande=[NSMutableArray array];
//    初始化
    xiadanshuliang=[NSMutableArray array];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    ye=1;
    [self xxx:@""];
    [self setupre];
}
-(void)xxx:(NSString*)zhao{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/productionsList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    [WarningBox warningBoxModeIndeterminate:@"数据加载中..." andView:self.view];
    //出入参数：
    NSString*pageSize=[NSString stringWithFormat:@"%d",ye];
    NSString *proName=[NSString stringWithFormat:@"%@",zhao];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"qtype",proName,@"proName",@"",@"proCatalog",pageSize,@"pageNo",@"10",@"pageSize", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
           
            NSDictionary*data=[responseObject valueForKey:@"data"];
            count=[NSString stringWithFormat:@"%@",[data objectForKey:@"count"]];
            productionsList=[data objectForKey:@"productionsList"];
            
            for (NSDictionary*dd in productionsList) {
                [xiaolv addObject:dd];
            }
            for (int i=0; i<xiaolv.count; i++) {
                [shuzi addObject:[NSString stringWithFormat:@"shuzi%d",i]];
                [jiahao addObject:[NSString stringWithFormat:@"jiahao%d",i]];
                
                //       下单数量默认为0
                [xiadanshuliang addObject:@"0"];
                
            }
            
            
            
            [_tableview reloadData];
            
            
        }else{
            
            
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
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableview.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter*footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    self.tableview.mj_footer = footer;
    
}

-(void)headerRereshing{
    ye=1;
    xiaolv=[NSMutableArray array];
    [self xxx:_search.text];
    [_tableview reloadData];
    [self.tableview.mj_header endRefreshing];
}
-(void)footerRereshing{
    ye+=1;
    
    if ((ye-1)*10>=[count intValue]) {
        [WarningBox warningBoxModeText:@"已经是最后一页!" andView:self.view];
        [self.tableview.mj_footer endRefreshing];
    }else{
        [self xxx:_search.text];
        [_tableview reloadData];
        [self.tableview.mj_footer endRefreshing];
    }

}
-(void)changePhone:(UITextField*)xixi
{
    int MaxLen = 4;
    NSString* szText = [xixi text];
    if ([xixi.text length]> MaxLen)
    {
        xixi.text = [szText substringToIndex:MaxLen];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return xiaolv.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return width/3;//cell高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell2";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    _imagr = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,width/3 ,width/3)];
    
    
    if ([xiaolv[indexPath.row] objectForKey:@"pics"]==nil) {
        _imagr.image=[UIImage imageNamed:@"11121.jpg"];
        tupian=@"";
    }else{
        tupian=[NSString stringWithFormat:@"%@",[xiaolv[indexPath.row] objectForKey:@"pics"]];
    }
    
    
    
    NSArray*arr=[tupian componentsSeparatedByString:@"|"];
    
    
    
    if (tupian.length<10) {
        
        _imagr.image=[UIImage imageNamed:@"11121.jpg"];
        
    }
    else{
        NSString*lian=[NSString stringWithFormat:@"%@",service_host];
        NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",lian,arr[1]]];
        
        [_imagr sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"11121.jpg"]];
    }
    
    
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, 0,width/3*2/3-15, width/3/6)];
    name.font= zitifont;
    name.text = @"商品名称:";
    name.textColor = ziticolor;
    
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15, 0, width-width/3-width/3*2/3+5, width/3/6)];
    name1.font= zitifont;
    name1.textColor = ziticolor;
    
    
    
    UILabel *changjia = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, width/3/6+3, width/3*2/3-15, width/3/6)];
    changjia.font= zitifont;
    changjia.text = @"生产厂家:";
    changjia.textColor = ziticolor;
    
    UILabel *changjia1 = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15,width/3/6+3,  width-width/3-width/3*2/3+5, width/3/6)];
    changjia1.font= zitifont;
    changjia1.textColor = ziticolor;
    
    
    
    UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, width/3/6*2+6, width/3*2/3-15, width/3/6)];
    guige.font= zitifont;
    guige.text = @"规       格:";
    guige.textColor = ziticolor;
    
    UILabel *guige1 = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15, width/3/6*2+6,  width-width/3-width/3*2/3+5-70, width/3/6)];
    guige1.font= zitifont;
    guige1.textColor = ziticolor;
    
    
    
    
    tianjia = [[UIButton alloc]initWithFrame:CGRectMake((width/3+5+width/3*2/3-15)+(width-width/3-width/3*2/3+5-70)+15, width/3/6*2+10, width-(width/3+5+width/3*2/3-15)-(width-width/3-width/3*2/3+5-70)-20, width/3/5)];
    [tianjia setTag:indexPath.row+2000];
    [tianjia setImage:[UIImage imageNamed:@"@2x_sp_07.png"] forState:UIControlStateNormal];
    [tianjia addTarget:self action:@selector(tianjia:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *danwei = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, width/3/6*3+9, width/3*2/3-15, width/3/6)];
    danwei.font= zitifont;
    danwei.text = @"单       位:";
    danwei.textColor = ziticolor;
    
    UILabel *danwei1 = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15, width/3/6*3+9,  width-width/3-width/3*2/3+5-70, width/3/6)];
    danwei1.font= zitifont;
    danwei1.textColor = ziticolor;
    
    
    UILabel *shuliang = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, width/3/6*4+12, width/3*2/3-15, width/3/6)];
    shuliang.font= zitifont;
    shuliang.text = @"下单数量:";
    shuliang.textColor =ziticolor;
    
    
    //   减创建
    jian = [[UIButton alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15, width/3/6*4+12, (width-width/3-width/3*2/3+5-70)/3-10,  width/3/6)];
    [jian setImage:[UIImage imageNamed:@"@2x_sp_11.png"] forState:UIControlStateNormal];
    [jian addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
    jian.tag=indexPath.row+20000;
    
    //   加创建
    jia = [[UIButton alloc]initWithFrame:CGRectMake((width/3+5+width/3*2/3-15)+((width-width/3-width/3*2/3+5-70)/3-10)+(width-width/3-width/3*2/3+5-70)/3-5, width/3/6*4+12, (width-width/3-width/3*2/3+5-70)/3-10,  width/3/6)];
    [jia setImage:[UIImage imageNamed:@"@2x_sp_13.png"] forState:UIControlStateNormal];
    [jia addTarget:self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
    jia.tag=indexPath.row+10000 ;
    
    
    
    shuru = [[UILabel alloc]initWithFrame:CGRectMake((width/3+5+width/3*2/3-15)+((width-width/3-width/3*2/3+5-70)/3-10), width/3/6*4+12, (width-width/3-width/3*2/3+5-70)/3-5,width/3/6)];
    //   下单的产品数量
    shuru.text = xiadanshuliang[indexPath.row];
    
    //shuru.delegate=self;
    [shuru setTag:indexPath.row+1000];
    shuru.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    shuru.textAlignment = NSTextAlignmentCenter;
    //shuru.borderStyle=UITextBorderStyleNone;
    //shuru.keyboardType = UIKeyboardTypeNumberPad;
    //键盘添加完成
    //[KeyboardToolBar registerKeyboardToolBar:shuru];
    
    UIButton *gengduo= [[UIButton alloc]initWithFrame:CGRectMake((width/3+5+width/3*2/3-15)+(width-width/3-width/3*2/3+5-70)+15,width/3/6*4,width-(width/3+5+width/3*2/3-15)-(width-width/3-width/3*2/3+5-70)-20,width/3/5)];
    
    [gengduo setImage:[UIImage imageNamed:@"@2x_sp_16.png"] forState:UIControlStateNormal];
    
    if ([xiaolv[indexPath.row] objectForKey:@"proName" ]==nil) {
        name1.text=@"";
    }else {
        name1.text = [NSString stringWithFormat:@"%@",[xiaolv[indexPath.row] objectForKey:@"proName" ]];
    }
    
    if([xiaolv[indexPath.row] objectForKey:@"proEnterprise" ]==nil){
        changjia1.text=@"";
    }else{
        changjia1.text = [NSString stringWithFormat:@"%@",[xiaolv[indexPath.row] objectForKey:@"proEnterprise" ]];
    }
    if ([xiaolv[indexPath.row] objectForKey:@"etalon" ]==nil) {
        guige1.text=@"";
    }else {
        guige1.text =[NSString stringWithFormat:@"%@",[xiaolv[indexPath.row] objectForKey:@"etalon" ]];
    }
    if ([xiaolv[indexPath.row] objectForKey:@"unit" ]==nil) {
        danwei1.text=@"";
    }else{
        danwei1.text = [NSString stringWithFormat:@"%@",[xiaolv[indexPath.row] objectForKey:@"unit" ]];
    }
    
    
    [cell.contentView addSubview:_imagr];
    
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:changjia];
    [cell.contentView addSubview:guige];
    [cell.contentView addSubview:danwei];
    [cell.contentView addSubview:shuliang];
    
    [cell.contentView addSubview:name1];
    [cell.contentView addSubview:changjia1];
    [cell.contentView addSubview:guige1];
    [cell.contentView addSubview:danwei1];
    
    [cell.contentView addSubview:tianjia];
    
    [cell.contentView addSubview:jia];
    [cell.contentView addSubview:jian];
    
    [cell.contentView addSubview:shuru];
    
    [cell.contentView addSubview:gengduo];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - 点击cell跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XiangqingViewController *xiangqing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xiangqing"];
    xiangqing.shangID=[NSString stringWithFormat:@"%@",[xiaolv[indexPath.row ] objectForKey:@"id"]];
    NSString * ij=[NSString stringWithFormat:@"%@",[xiaolv[indexPath.row] objectForKey:@"pics"]];
  
    NSArray*arr=[ij componentsSeparatedByString:@"|"];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:arr forKey:@"duoshao"];
    [self.navigationController pushViewController:xiangqing animated:YES];
   
}
#pragma mark - button点击事件
-(void)tianjia:(UIButton*)tt{
    //用户id
    NSString*businesspersonId=[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"];
    //接受客户数据
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    NSDictionary*kehuxinxi=[NSDictionary dictionaryWithContentsOfFile:pathkehu];
    //提取客户id
    NSString*kehuID=[NSString stringWithFormat:@"%@",[kehuxinxi objectForKey:@"id"]];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/priceByNum";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //数量
    NSString*acount=@"1";
    //商品id
    NSString*shangpinID= [ NSString stringWithFormat:@"%@",[xiaolv[tt.tag-2000] objectForKey:@"id"]];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",businesspersonId],@"businesspersonId",acount,@"acount",kehuID,@"customerId",shangpinID,@"productionsId", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try
        {
            if ([[responseObject objectForKey:@"code"] intValue]==0) {
                if ([[[responseObject objectForKey:@"data"]objectForKey:@"customerPrice"] intValue]==0) {
                    [WarningBox warningBoxModeText:@"该商品暂不出售" andView:self.view];
                }else{
                    
                    
                    
                    //userID    暂时不用改
                    NSString * userID5=@"0";
                    
                    //请求地址   地址不同 必须要改
                    NSString * url5 =@"/prod/stockNum";
                    
                    //时间戳
                    NSDate* dat5 = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval a5=[dat5 timeIntervalSince1970];
                    NSString *timeSp5 = [NSString stringWithFormat:@"%.0f",a5];
                    
                    
                    
                    //将上传对象转换为json格式字符串
                    AFHTTPRequestOperationManager *manager5=[AFHTTPRequestOperationManager manager];
                    manager5.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
                    SBJsonWriter* writer5=[[SBJsonWriter alloc] init];
                    //出入参数：
                    NSString*_shangID5=[NSString stringWithFormat:@"%@",[xiaolv[tt.tag-2000] objectForKey:@"id"]];
                    NSDictionary*datadic5=[NSDictionary dictionaryWithObjectsAndKeys:_shangID5,@"productionsId", nil];
                    
                    NSString*jsonstring5=[writer5 stringWithObject:datadic5];
                    
                    //获取签名
                    NSString*sign5= [lianjie postSign:url5 :userID5 :jsonstring5 :timeSp5 ];
                    
                    NSString *url15=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url5];
                    
                    //电泳借口需要上传的数据
                    NSDictionary*dic5=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring5,@"params",appkey, @"appkey",userID5,@"userid",sign5,@"sign",timeSp5,@"timestamp", nil];
                    
                    [manager GET:url15 parameters:dic5 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        @try
                        {
                            NSDictionary*data=[responseObject objectForKey:@"data"];
                            NSString* stockNum=[data objectForKey:@"stockNum"];
                            if ([stockNum intValue]-[xiadanshuliang[tt.tag-2000] intValue]<0) {
                                
                                
                                NSString*message=[NSString stringWithFormat:@"您选择了%@件商品，当前剩余库存为%@件",xiadanshuliang[tt.tag-2000],stockNum];
                                
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
                                
                                if([xiadanshuliang[tt.tag-2000] intValue]==0){
                                    [WarningBox warningBoxModeText:@"数量不能为空哟～" andView:self.view];
                                }else{
//                                    //找到当前cell
//                                    UITableViewCell *cell=[(UITableViewCell *)[tt superview]superview];
//                                    //找到当前值
//                                    NSIndexPath *index=[self.tableview indexPathForCell:cell];
//                                    NSString *zhi=[NSString stringWithFormat:@"%@",xiadanshuliang[index.row]];
//                                    if ((int)zhi >= 9999) {
//                                        NSLog(@"zhi**********************************%@",zhi);
//                                        [WarningBox warningBoxModeText:@"123456789123456789" andView:self.view];
//                                    }
//                                    else{
//                                    }
//                                    
                                    NSMutableDictionary*dd=[NSMutableDictionary dictionaryWithDictionary:xiaolv[tt.tag-2000]];
                                    [dd setObject:xiadanshuliang[tt.tag-2000] forKey:@"shuliang"];
                                    
                                    [WarningBox warningBoxModeText:@"添加成功~" andView:self.view];
                                    int qubaaoteman=0;
                                    for (int abcd=0; abcd < chuande.count; abcd++) {
                                        if ([[chuande[abcd] objectForKey:@"id"]isEqual:[dd objectForKey:@"id"]]) {
                                            qubaaoteman=1;
                                            [chuande replaceObjectAtIndex:abcd withObject:dd];
                                        }
                                    }
                                    if (qubaaoteman!=1) {
                                        [chuande addObject:dd];
                                    }
                            
                                }
                            }
                        }
                        @catch (NSException * e) {
                            
                            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
                            
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [WarningBox warningBoxHide:YES andView:self.view];
                        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
                        
                    }];
                }
            }
            
            
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
    
    
    
    
}
-(void)jia:(UIButton*)tt{
//找到当前cell
     UITableViewCell *cell=(UITableViewCell*)[[tt superview] superview ];
    
// 找到当前 没值 ?
    NSIndexPath *index=[self.tableview indexPathForCell:cell];

//计算的
    NSString *shuliang=[NSString stringWithFormat:@"%@", xiadanshuliang[index.row]];
   int shuliangInt=  [shuliang intValue];
        shuliang =[NSString stringWithFormat:@"%d", shuliangInt+1];
    xiadanshuliang[index.row]=shuliang;
//  刷新
    [self.tableview reloadData];
}

-(void)jian:(UIButton*)tt{
    //找到当前cell
    UITableViewCell *cell=(UITableViewCell*)[[tt superview] superview ];
    NSIndexPath *index=[self.tableview indexPathForCell:cell];
  //计算的
    NSString *shuliang=[NSString stringWithFormat:@"%@", xiadanshuliang[index.row]];
    int shuliangInt=  [shuliang intValue];
    if(shuliangInt==0){
        
    
        return;
    }
    else{
    
    shuliang =[NSString stringWithFormat:@"%d", shuliangInt-1];
    xiadanshuliang[index.row]=shuliang;
        
    }
    //  刷新
    [self.tableview reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)fanhui:(id)sender {
    
    // 放到返回上一页面
    XiadanViewController*memeda=[[XiadanViewController alloc] init];
    self.trendDelegate= memeda;
    [self.trendDelegate passTrendValue:chuande];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)diaoyong:(NSString*)zhao{
    xiaolv=[NSMutableArray array];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/productionsList";
    [WarningBox warningBoxModeIndeterminate:@"数据加载中..." andView:self.view];
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];

    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //出入参数：
    NSString *proName=[NSString stringWithFormat:@"%@",zhao];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"qtype",proName,@"proName",@"",@"proCatalog",@"1",@"pageNo",@"100",@"pageSize", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
             //[WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
        
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            NSDictionary*data=[responseObject valueForKey:@"data"];
            productionsList=[data objectForKey:@"productionsList"];
            count=[NSString stringWithFormat:@"%@",[data objectForKey:@"count"]];
            for (NSDictionary*dd in productionsList) {
                [xiaolv addObject:dd];
            }
            for (int i=0; i<xiaolv.count; i++) {
                [shuzi addObject:[NSString stringWithFormat:@"shuzi%d",i]];
                [jiahao addObject:[NSString stringWithFormat:@"jiahao%d",i]];
                //       下单数量默认为0
                [xiadanshuliang addObject:@"0"];
                
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
//手动添加下单数量
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
        //找到当前cell
        UITableViewCell *cell=(UITableViewCell*)[[textField superview] superview ];
        
        // 找到当前 没值 ?
        NSIndexPath *index=[self.tableview indexPathForCell:cell];
        
        if([string isEqualToString:@""]){
            
            NSString*yuanlai=[NSString stringWithFormat:@"%@",xiadanshuliang[index.row]];
            int x=[yuanlai intValue]/10;
            
            xiadanshuliang[index.row]=[NSString stringWithFormat:@"%d",x];
            
        }else {
            
            NSString*yuanlai=[NSString stringWithFormat:@"%@",xiadanshuliang[index.row]];
            int x=[yuanlai intValue]*10+[string intValue];
            
            xiadanshuliang[index.row]=[NSString stringWithFormat:@"%d",x];
            [self changePhone:textField];
        }
return YES;
  
    
}

@end
