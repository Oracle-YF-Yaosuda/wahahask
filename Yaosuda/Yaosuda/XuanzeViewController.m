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


@interface XuanzeViewController ()<MJRefreshBaseViewDelegate,UITextFieldDelegate>
{   MJRefreshHeaderView*header;
    MJRefreshHeaderView*footer;
    NSMutableArray*jiahao;
    NSMutableArray*shuzi;
    CGFloat width;
    CGFloat height;
    UIButton *jian;
    UIButton *tianjia;
    UITextField *shuru;
    NSMutableArray*chuande;
    NSArray*productionsList;
    UIButton *jia ;
    int ye;
    
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
    [self xxx];
    [self setupre];
}
-(void)xxx{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/productionsList";
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    [WarningBox warningBoxModeIndeterminate:@"数据加载中..." andView:self.view];
    //出入参数：
    NSString*pageNo=[NSString stringWithFormat:@"%d",ye];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"qtype",@"",@"proName",@"",@"proCatalog",pageNo,@"pageNo",@"10",@"pageSize", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        
        
        //[WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
        
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            NSDictionary*data=[responseObject valueForKey:@"data"];
            productionsList=[data objectForKey:@"productionsList"];
            for (int i=0; i<productionsList.count; i++) {
                [shuzi addObject:[NSString stringWithFormat:@"shuzi%d",i]];
                [jiahao addObject:[NSString stringWithFormat:@"jiahao%d",i]];
                
                //       下单数量默认为0
                [xiadanshuliang addObject:@"0"];
                
            }
            
            
            
            [_tableview reloadData];
            
            
        }else{
            
            
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
        ye=1;
        [self xxx];
        [_tableview reloadData];
        [refr endRefreshing];
        
        
    }
    else{
        ye++;
        [self xxx];
        [_tableview reloadData];
        [refr endRefreshing];
    }}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return productionsList.count;
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
   
        
    NSString*tupian=[NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"pics"]];
        
   
        
    
    NSArray*arr=[tupian componentsSeparatedByString:@"|"];
    
    
    
    if (tupian.length<10) {
    
     _imagr.image=[UIImage imageNamed:@"1.jpg"];
    
    }
     else{
        NSString*lian=[NSString stringWithFormat:@"%@",service_host];
         NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",lian,arr[1]]];
         
         [_imagr sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"1.jpg"]];
     }
 
    
   
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, 0,width/3*2/3-15, width/3/6)];
    name.font= [UIFont systemFontOfSize:12];
    name.text = @"商品名称:";
    name.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
   
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15, 0, width-width/3-width/3*2/3+5, width/3/6)];
    name1.font= [UIFont systemFontOfSize:12];
    name1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
   

    
    UILabel *changjia = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, width/3/6+3, width/3*2/3-15, width/3/6)];
    changjia.font= [UIFont systemFontOfSize:12];
    changjia.text = @"生产厂家:";
    changjia.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
   
    UILabel *changjia1 = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15,width/3/6+3,  width-width/3-width/3*2/3+5, width/3/6)];
    changjia1.font= [UIFont systemFontOfSize:12];
    changjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    

    
    UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, width/3/6*2+6, width/3*2/3-15, width/3/6)];
    guige.font= [UIFont systemFontOfSize:12];
    guige.text = @"规       格:";
    guige.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
   
    UILabel *guige1 = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15, width/3/6*2+6,  width-width/3-width/3*2/3+5-70, width/3/6)];
    guige1.font= [UIFont systemFontOfSize:12];
    guige1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
   

    
    
    tianjia = [[UIButton alloc]initWithFrame:CGRectMake((width/3+5+width/3*2/3-15)+(width-width/3-width/3*2/3+5-70)+15, width/3/6*2+10, width-(width/3+5+width/3*2/3-15)-(width-width/3-width/3*2/3+5-70)-20, width/3/5)];
    [tianjia setTag:indexPath.row+2000];
    [tianjia setImage:[UIImage imageNamed:@"@2x_sp_07.png"] forState:UIControlStateNormal];
    [tianjia addTarget:self action:@selector(tianjia:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *danwei = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, width/3/6*3+9, width/3*2/3-15, width/3/6)];
    danwei.font= [UIFont systemFontOfSize:12];
    danwei.text = @"单       位:";
    danwei.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    
    UILabel *danwei1 = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5+width/3*2/3-15, width/3/6*3+9,  width-width/3-width/3*2/3+5-70, width/3/6)];
    danwei1.font= [UIFont systemFontOfSize:12];
    danwei1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    
    
    UILabel *shuliang = [[UILabel alloc]initWithFrame:CGRectMake(width/3+5, width/3/6*4+12, width/3*2/3-15, width/3/6)];
    shuliang.font= [UIFont systemFontOfSize:12];
    shuliang.text = @"下单数量:";
    shuliang.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
   
    
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
  
    
    
    shuru = [[UITextField alloc]initWithFrame:CGRectMake((width/3+5+width/3*2/3-15)+((width-width/3-width/3*2/3+5-70)/3-10), width/3/6*4+12, (width-width/3-width/3*2/3+5-70)/3-5,width/3/6)];
    

//   下单的产品数量
    shuru.text = xiadanshuliang[indexPath.row];
    shuru.delegate=self;
    [shuru setTag:indexPath.row+1000];
    shuru.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    shuru.textAlignment = NSTextAlignmentCenter;
    shuru.borderStyle=UITextBorderStyleNone;
    
    
    UIButton *gengduo= [[UIButton alloc]initWithFrame:CGRectMake((width/3+5+width/3*2/3-15)+(width-width/3-width/3*2/3+5-70)+15,width/3/6*4,width-(width/3+5+width/3*2/3-15)-(width-width/3-width/3*2/3+5-70)-20,width/3/5)];
   
    [gengduo setImage:[UIImage imageNamed:@"@2x_sp_16.png"] forState:UIControlStateNormal];
    
   
    name1.text = [NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"proName" ]];
    changjia1.text = [NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"proEnterprise" ]];
    guige1.text =[NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"etalon" ]];
    danwei1.text = [NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"unit" ]];
  
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
    xiangqing.shangID=[NSString stringWithFormat:@"%@",[productionsList[indexPath.row ] objectForKey:@"id"]];
    [self.navigationController pushViewController:xiangqing animated:YES];
   
}
#pragma mark - button点击事件
-(void)tianjia:(UIButton*)tt{
   
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/stockNum";
    
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
    NSString*_shangID=[NSString stringWithFormat:@"%@",[productionsList[tt.tag-2000] objectForKey:@"id"]];
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_shangID,@"productionsId", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [WarningBox warningBoxModeText:@"添加成功~" andView:self.view];
            NSMutableDictionary*dd=[NSMutableDictionary dictionaryWithDictionary:productionsList[tt.tag-2000]];
            [dd setObject:xiadanshuliang[tt.tag-2000] forKey:@"shuliang"];
            if([xiadanshuliang[tt.tag-2000] intValue]==0){
                [WarningBox warningBoxModeText:@"数量不能为空哟～" andView:self.view];
            }else{
                [chuande addObject:dd];
            }

        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        NSLog(@"%@",error);
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
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/productionsList";
    [WarningBox warningBoxModeIndeterminate:@"数据加载中..." andView:self.view];
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"qtype",zhao,@"proName",@"",@"proCatalog",@"1",@"pageNo",@"100",@"pageSize", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        
        //[WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
        
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            NSDictionary*data=[responseObject valueForKey:@"data"];
            productionsList=[data objectForKey:@"productionsList"];
            for (int i=0; i<productionsList.count; i++) {
                [shuzi addObject:[NSString stringWithFormat:@"shuzi%d",i]];
                [jiahao addObject:[NSString stringWithFormat:@"jiahao%d",i]];
                //       下单数量默认为0
                [xiadanshuliang addObject:@"0"];
                
            }
            
            [_tableview reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败～" andView:self.view];
        
    }];
    
}
//手动添加下单数量
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
 
    NSLog(@"%@",string);
    
    //找到当前cell
    UITableViewCell *cell=(UITableViewCell*)[[textField superview] superview ];
    
    // 找到当前 没值 ?
    NSIndexPath *index=[self.tableview indexPathForCell:cell];
//    NSLog(@"0000000--%@",textField.text);
    

    
    
    if([string isEqualToString:@""]){
        
        NSString*yuanlai=[NSString stringWithFormat:@"%@",xiadanshuliang[index.row]];
        int x=[yuanlai intValue]/10;
        
        xiadanshuliang[index.row]=[NSString stringWithFormat:@"%d",x];
        
        NSLog(@"%@",xiadanshuliang);
        
    }else {
        
        NSString*yuanlai=[NSString stringWithFormat:@"%@",xiadanshuliang[index.row]];
         int x=[yuanlai intValue]*10+[string intValue];
        
      
        xiadanshuliang[index.row]=[NSString stringWithFormat:@"%d",x];
        NSLog(@"%@",xiadanshuliang);
        
    }
    
    
    return YES;
}
@end
