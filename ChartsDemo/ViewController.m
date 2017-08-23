//
//  ViewController.m
//  ChartsDemo
//
//  Created by yxmac on 2017/8/15.
//  Copyright © 2017年 steven. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ChartView *charts = [[ChartView alloc] initWithNameArray:@[@"机器🐱",@"冰箱导热管",@"火车头",@"螺丝",@"起子扳手"] dataArray:@[@"1000",@"2000",@"1230",@"1450",@"2321"] chartsType: pieChart];
    
    
    charts.frame  =CGRectMake(0, 0, self.view.frame.size.width, 300);
    
    [charts showChartsAnimation:YES];
    
    
    
    [self.view addSubview:charts];
    
    ChartView *chartsBarts = [[ChartView alloc] initWithNameArray:@[@"机器🐱",@"冰箱导热管",@"火车头",@"导弹"] dataArray:@[@"1000",@"2000",@"1230",@"2100"] chartsType: barChart];
    
    chartsBarts.frame  =CGRectMake(0, 320, self.view.frame.size.width,200 );

    [chartsBarts showChartsAnimation:YES];
    
    [self.view addSubview:chartsBarts];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
