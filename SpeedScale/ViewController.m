//
//  ViewController.m
//  SpeedScale
//
//  Created by 1 on 2018/5/11.
//  Copyright © 2018年 luris. All rights reserved.
//

#import "ViewController.h"
#import "LRCircleProgress.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    sleep(3);
    
    [self test1];
    [self test2];
    [self test3];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)test1
{
    CGRect rect = CGRectMake(20, 50, 300, 180);

    LRCircleProgressStyle *style = [[LRCircleProgressStyle alloc] init];
    style.arcCenter = CGPointMake(rect.size.width * 0.5, rect.size.height);
    style.radius = rect.size.width*0.5 - 10;
    style.startAngle = M_PI;
    style.endAngle = M_PI *0.005;
    style.clockWise = YES;
//    style.progressLineDashPattern = @[@2,@11];
    style.dotteLineDashPattern = @[@2,@5];
    style.progressType = LRCircleProgressTypeSpeedScale;
    style.numberOfTotalScale = 40;
    style.numberOfSmallScale = 10;
    style.progressColor = [UIColor redColor];
    LRCircleProgress *speedScale = [[LRCircleProgress alloc] initWithFrame:rect config:style];
    speedScale.backgroundColor = [UIColor cyanColor];
    [speedScale setProgress:0.1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [speedScale setProgress:0.8];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [speedScale setProgress:0.4];
        });
    });
    [self.view addSubview:speedScale];
}

- (void)test2
{
    CGRect rect = CGRectMake(20, 280, 300, 180);
    
    LRCircleProgressStyle *style = [[LRCircleProgressStyle alloc] init];
    style.arcCenter = CGPointMake(rect.size.width * 0.5, rect.size.height);
    style.radius = rect.size.width*0.5 - 10;
    style.startAngle = M_PI;
    style.endAngle = 0;
    style.clockWise = YES;
//    style.progressLineDashPattern = @[@2,@11];
    style.dotteLineDashPattern = @[@2,@5];
    style.progressType = LRCircleProgressTypeNomal;
    LRCircleProgress *speedScale = [[LRCircleProgress alloc] initWithFrame:rect config:style];
    speedScale.backgroundColor = [UIColor cyanColor];
    [speedScale setProgress:0.1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [speedScale setProgress:0.8];
    });
    [self.view addSubview:speedScale];
}

- (void)test3
{
    CGRect rect = CGRectMake(20, 500, 300, 180);
    
    LRCircleProgressStyle *style = [[LRCircleProgressStyle alloc] init];
    style.arcCenter = CGPointMake(rect.size.width * 0.5, rect.size.height);
    style.radius = rect.size.width*0.5 - 10;
    style.startAngle = M_PI;
    style.endAngle = 0;
    style.clockWise = YES;
    style.progressLineDashPattern = @[@2,@13];
    style.dotteLineDashPattern = @[@2,@5];
    style.progressType = LRCircleProgressTypeNomal;
    LRCircleProgress *speedScale = [[LRCircleProgress alloc] initWithFrame:rect config:style];
    speedScale.backgroundColor = [UIColor cyanColor];
    [speedScale setProgress:0.1];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [speedScale setProgress:0.8];
    });
    [self.view addSubview:speedScale];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
