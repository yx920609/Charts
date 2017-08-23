//
//  ChartView.h
//  ChartsDemo
//
//  Created by yxmac on 2017/8/15.
//  Copyright © 2017年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ChartType) {
    pieChart = 0,
    barChart
    
};

@interface ChartView : UIView

- (instancetype)initWithNameArray:(NSArray *)nameSource
                        dataArray:(NSArray *)dataSource
                  chartsType:(ChartType)chartType;

- (void)showChartsAnimation:(BOOL)showAnimation;

@end
