//
//  GerenViewController.m
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "GerenViewController.h"
#import "Color+Hex.h"
#import "XiugaiViewController.h"
#import "yonghuziliao.h"
@interface GerenViewController ()
{
    CGFloat width;
    CGFloat height;
    
    UITableViewCell *cell;
    
    UIButton *sanjiao;
    NSDictionary*yonghu;
    NSDictionary*zhanghao;
}
@property (weak, nonatomic) IBOutlet UILabel *ninhao;

@end

@implementation GerenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    yonghu=[yonghuziliao getUserInfo];
    zhanghao=[yonghuziliao getZiJinzhanghao];
    _ninhao.text=[NSString stringWithFormat:@"您好,%@",[NSString stringWithFormat:@"%@",[yonghu objectForKey:@"loginName"] ]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *diview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    diview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return diview;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }
    else if (indexPath.section == 1){
        return 110;
    }
    else if (indexPath.section == 2){
        return 40;
    }
    return 0;//cell高度
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *id1 =@"mycell";
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *la1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 60, 30)];
    la1.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
    la1.font = [UIFont systemFontOfSize:13];
    UILabel *la2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 60, 30)];
    la2.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
    la2.font = [UIFont systemFontOfSize:13];
    UILabel *la3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 60, 30)];
    la3.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
    la3.font = [UIFont systemFontOfSize:13];
    
    UILabel *la11 = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, width-80, 30)];
    la11.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
    la11.font = [UIFont systemFontOfSize:13];
    //la11.textAlignment = NSTextAlignmentCenter;
    UILabel *la22 = [[UILabel alloc]initWithFrame:CGRectMake(90, 45, width-80, 30)];
    la22.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
    la22.font = [UIFont systemFontOfSize:13];
    //la22.textAlignment = NSTextAlignmentCenter;
    UILabel *la33 = [[UILabel alloc]initWithFrame:CGRectMake(90, 80, width-80, 30)];
    la33.textColor = [UIColor colorWithHexString:@"969696" alpha:1];
    la33.font = [UIFont systemFontOfSize:13];
    //la33.textAlignment = NSTextAlignmentCenter;
    
    
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, width, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(0, 75, width, 1)];
    xian2.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    
    
    
    
    if (indexPath.section == 0) {
        la1.text = @"账号";
        la2.text = @"姓名";
        la3.text = @"手机号";
        
        la11.text = [NSString stringWithFormat:@"%@",[yonghu objectForKey:@"loginName"] ];
        la22.text =@"四川成都";
        la33.text = [NSString stringWithFormat:@"%@",[yonghu objectForKey:@"mobile"] ];
        
    }
    else if (indexPath.section == 1){
        la1.text = @"账户名称";
        la2.text = @"授信额度";
        la3.text = @"资金金额";
        
        la11.text = @"chengdu";
        la22.text = [NSString stringWithFormat:@"%@",[zhanghao objectForKey:@"creditFund"]];
        la33.text = @"100000000.00元";
        
    }
    else if(indexPath.section == 2){
        la1.text = @"修改密码";
        sanjiao = [[UIButton alloc]initWithFrame:CGRectMake(width-30,15, 11 , 15)];
        [sanjiao setBackgroundImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
        xian2.hidden=YES;
        
    }
    
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    
    
    
    [cell.contentView addSubview:la1];
    [cell.contentView addSubview:la2];
    [cell.contentView addSubview:la3];
    [cell.contentView addSubview:sanjiao];
    
    [cell.contentView addSubview:xian1];
    [cell.contentView addSubview:xian2];
    
    [cell.contentView addSubview:la11];
    [cell.contentView addSubview:la22];
    [cell.contentView addSubview:la33];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 2){
        
        XiugaiViewController*xiugai =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xiugai"];
        [self.navigationController pushViewController:xiugai animated:YES];
        
    }
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)fanhui:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

    
}
@end
