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
@interface XuanzeViewController ()
{
    
    CGFloat width;
    CGFloat height;
    
    UITableViewCell *cell;
    
}
@end

@implementation XuanzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;//cell高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell2";
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UIImageView *imagr = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,115 , 115)];
    imagr.image = [UIImage imageNamed:@"9205.jpg"];
    
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(120, 5,60, 15)];
    name.font= [UIFont systemFontOfSize:12];
    name.text = @"商品名称:";
    name.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, width-180, 15)];
    name1.font= [UIFont systemFontOfSize:12];
    name1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];

    
    UILabel *changjia = [[UILabel alloc]initWithFrame:CGRectMake(120, 25, 60, 15)];
    changjia.font= [UIFont systemFontOfSize:12];
    changjia.text = @"生产厂家:";
    changjia.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UILabel *changjia1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 26, width-180, 15)];
    changjia1.font= [UIFont systemFontOfSize:12];
    changjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];

    
    
    
    
    UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(120, 45, 60, 15)];
    guige.font= [UIFont systemFontOfSize:12];
    guige.text = @"规       格:";
    guige.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UILabel *guige1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 45, 60, 15)];
    guige1.font= [UIFont systemFontOfSize:12];
    guige1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];

    
    
    UIButton *tianjia = [[UIButton alloc]initWithFrame:CGRectMake(width-60, 45, 50, 30)];
    [tianjia setImage:[UIImage imageNamed:@"@2x_sp_07.png"] forState:UIControlStateNormal];
    [tianjia addTarget:self action:@selector(tianjia) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *danwei = [[UILabel alloc]initWithFrame:CGRectMake(120, 65, 60, 15)];
    danwei.font= [UIFont systemFontOfSize:12];
    danwei.text = @"单       位:";
    danwei.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UILabel *danwei1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 65, 60, 15)];
    danwei1.font= [UIFont systemFontOfSize:12];
    danwei1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    
    
    
    
    
    UILabel *shuliang = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, 60, 15)];
    shuliang.font= [UIFont systemFontOfSize:12];
    shuliang.text = @"下单数量:";
    shuliang.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UIButton *jian = [[UIButton alloc]initWithFrame:CGRectMake(180, 87, 20, 20)];
    [jian setImage:[UIImage imageNamed:@"@2x_sp_11.png"] forState:UIControlStateNormal];
    [jian addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
    UIButton *jia = [[UIButton alloc]initWithFrame:CGRectMake(225, 87, 20, 20)];
    [jia setImage:[UIImage imageNamed:@"@2x_sp_13.png"] forState:UIControlStateNormal];
    [jia addTarget:self action:@selector(jia) forControlEvents:UIControlEventTouchUpInside];
    UITextField *shuru = [[UITextField alloc]initWithFrame:CGRectMake(201, 87, 23,20)];
    shuru.text = @"0";
    shuru.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    shuru.textAlignment = UITextAlignmentCenter;
    shuru.borderStyle=UITextBorderStyleNone;
    
    
    UIButton *gengduo = [[UIButton alloc]initWithFrame:CGRectMake(271, 87, 30, 20)];
    [gengduo setImage:[UIImage imageNamed:@"@2x_sp_16.png"] forState:UIControlStateNormal];
    [gengduo addTarget:self action:@selector(gengduo) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    name1.text = @"惠氏 善存 多维元素片";
    changjia1.text = @"惠氏制药有限公司";
    guige1.text = @"100片";
    danwei1.text = @"0.22kg";
    
    
    
    
    
    [cell.contentView addSubview:imagr];

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
    return cell;
}




#pragma mark - button点击事件

-(void)tianjia{
    
}
-(void)jia{
    
}
-(void)jian{
    
}
-(void)gengduo{
    
    XiangqingViewController *xiangqing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xiangqing"];
    [self.navigationController pushViewController:xiangqing animated:YES];

}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
