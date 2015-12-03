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
@interface GerenViewController ()
{
    CGFloat width;
    CGFloat height;
    
    UITableViewCell *cell;
    
    UIButton *sanjiao;
}

@end

@implementation GerenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }
    else if (indexPath.section == 1){
        return 110;
    }
    else if (indexPath.section == 2){
        return 35;
    }
    return 0;//cell高度
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *id1 =@"mycell";
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    UILabel *la1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    la1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    la1.font = [UIFont systemFontOfSize:13];
    UILabel *la2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 60, 30)];
    la2.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    la2.font = [UIFont systemFontOfSize:13];
    UILabel *la3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 60, 30)];
    la3.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    la3.font = [UIFont systemFontOfSize:13];
    
    UILabel *la11 = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, width-80, 30)];
    la11.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    la11.font = [UIFont systemFontOfSize:13];
    la11.textAlignment = UITextAlignmentCenter;
    UILabel *la22 = [[UILabel alloc]initWithFrame:CGRectMake(70, 45, width-80, 30)];
    la22.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    la22.font = [UIFont systemFontOfSize:13];
    la22.textAlignment = UITextAlignmentCenter;
    UILabel *la33 = [[UILabel alloc]initWithFrame:CGRectMake(70, 80, width-80, 30)];
    la33.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    la33.font = [UIFont systemFontOfSize:13];
    la33.textAlignment = UITextAlignmentCenter;

    
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, width, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(0, 75, width, 1)];
    xian2.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    
    
    
    
    if (indexPath.section == 0) {
        la1.text = @"账       号:";
        la2.text = @"姓       名:";
        la3.text = @"手  机  号:";
        
        la11.text = @"18345559961";
        la22.text = @"索坤";
        la33.text = @"18345559961";

    }
    else if (indexPath.section == 1){
        la1.text = @"账户名称:";
        la2.text = @"授信额度:";
        la3.text = @"资金金额:";
        
        la11.text = @"sk19920518";
        la22.text = @"10000.00元";
        la33.text = @"100000000.00元";
       
    }
    else if(indexPath.section == 2){
        la1.text = @"修改密码";
        sanjiao = [[UIButton alloc]initWithFrame:CGRectMake(width-30,20, 10 , 10)];
        [sanjiao setBackgroundImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];

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


@end
