//
//  ZizunViewController.m
//  Yaosuda
//
//  Created by oracle on 15/12/4.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "ZizunViewController.h"

@interface ZizunViewController ()
{
    CGFloat width;
}
@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) UIPageControl *pageControl;
@property(strong,nonatomic) NSTimer *timer;

@end

@implementation ZizunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品资质";
    
    width = [UIScreen mainScreen].bounds.size.width;
    
    self.scrollView.delegate = self;
    
    [self lunbo];
}
-(void)lunbo{
//轮播
//创建scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, 250)];
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
//imag
    CGFloat imgW = width;
    CGFloat imgH = 300;
    CGFloat imgY = 0;
    
    for (int i =0 ; i< 4; i++) {
        UIImageView *image = [[UIImageView alloc] init];
        
        NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i+1];
        image.image = [UIImage imageNamed:imgName];
        CGFloat imgX = i * imgW;
        image.frame = CGRectMake(imgX, imgY, imgW, imgH);
        
        self.scrollView.pagingEnabled = YES;
        
        self.scrollView.delegate = self;
        
        [self.scrollView addSubview:image];
    }
    //创建计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dong) userInfo:nil repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}
//自动滚动图片
-(void)dong{
    
    NSInteger page = self.pageControl.currentPage;
    
    if (page == self.pageControl.numberOfPages - 1) {
        page = 0;
    }else{
        page ++;
    }
    CGFloat offsetX = page *self.scrollView.frame.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
//scrollview滚动方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX +(scrollView.frame.size.width * 0.5);
    
    int page = offsetX / scrollView.frame.size.width;
    
    self.pageControl.currentPage = page;
    
}
//scrollview即将开始拖拽方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止计时器
    [self.timer invalidate];
    //设置timer为nil
    self.timer = nil;
}
//scrollview拖拽完毕方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dong) userInfo:nil repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
@end