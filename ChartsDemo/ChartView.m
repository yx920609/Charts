//
//  ChartView.m
//  ChartsDemo
//
//  Created by yxmac on 2017/8/15.
//  Copyright © 2017年 steven. All rights reserved.
//

#import "ChartView.h"

#import "UIView+SDAutoLayout.h"

#define rgb(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])

@interface ChartView(){

}
@property (nonatomic ,strong) NSArray *m_nameSource;

@property (nonatomic ,strong) NSArray *m_dataSource;

@property (nonatomic ,assign) CGFloat startAngle;

@property (nonatomic ,assign) CGFloat endAngle;

@property (nonatomic ,assign) CGFloat total;

@property (nonatomic ,assign) ChartType type;

@property (nonatomic ,strong) NSMutableArray *m_pointData;

@property (nonatomic ,assign) CGPoint orign;

@property (nonatomic ,assign) BOOL showAnimation;

@property (nonatomic ,strong) NSArray *colorArrays;

@property (nonatomic ,assign) CGFloat maxNum;


@end

static CGFloat KStartX = 80;

static CGFloat KEndX = 80;

static CGFloat KStartY = 50;

//static CGFloat kEndY = 20;

@implementation ChartView

- (instancetype)initWithNameArray:(NSArray *)nameSource
                        dataArray:(NSArray *)dataSource
                       chartsType:(ChartType)chartType{
    
    if (self = [super init]) {
        
        self.m_nameSource = nameSource;
        
        self.m_dataSource = dataSource;
        
        self.type = chartType;

        _startAngle = 3/2.0 *M_PI;
        
        _endAngle = 0;
        
        NSArray *colorArray = @[rgb(74, 137, 221),rgb(218, 69, 83),rgb(235, 146, 62),rgb(57, 176, 110),rgb(85, 180, 233),rgb(91, 112, 232)];
        
        self.colorArrays = colorArray;
        
        if (chartType == pieChart) {
            
            for (id temp in dataSource) {
                _total += [temp floatValue];
            }
        }
        
        if (chartType == barChart) {
            for (id temp in dataSource) {
                if ([temp floatValue]>= _maxNum) {
                    _maxNum = [temp floatValue];
                }
            }
        }
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setNeedsDisplay];
        
        
    }
    return self;
}


- (void)showChartsAnimation:(BOOL)showAnimation {
    
    self.showAnimation = showAnimation;
    
    switch (self.type) {
        case 0:
        {
            
            [self createPieCharts];
        }
            break;
        case 1: {
            [self createBarCharts];
        }
            break;
            
        default:
            break;
    }

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}

/**
 生成标注
 */
- (void)createBiaozhu {
    if (!self.m_pointData.count) {
        return;
    }
    for (int index = 0 ;index < self.m_pointData.count ; index++) {
        
        CGPoint beginPoint = [self.m_pointData [index] CGPointValue];
        
        UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(beginPoint.x, beginPoint.y, 1, 1)];
        
        [self addSubview:testView];
        
        UILabel *nameLable = [UILabel new];
        
        [self addSubview:nameLable];

        if (beginPoint.x>=self.orign.x) {
            nameLable.sd_layout.leftSpaceToView(testView, 20);
            nameLable.sd_layout.rightEqualToView(self);
            nameLable.textAlignment = NSTextAlignmentLeft;
        }
        
        else {
            nameLable.sd_layout.rightSpaceToView(testView, 20);
            nameLable.sd_layout.leftEqualToView(self);
            nameLable.textAlignment = NSTextAlignmentRight;

        }
        
        if (beginPoint.y >= self.orign.y) {
            nameLable.sd_layout.topSpaceToView(testView, 3);

        }
        
        else {
            nameLable.sd_layout.bottomSpaceToView(testView, 3);

        }
        
        nameLable.sd_layout.heightIs(20);

        nameLable.font = [UIFont systemFontOfSize:15];
        
        nameLable.text = [NSString stringWithFormat:@"%@ %@个",self.m_nameSource[index],self.m_dataSource[index]];
        
        nameLable.textColor = self.colorArrays[index];
        
    }
    
    //生成底部标注
    
    UIView *firstView;
    
    for (int index = 0; index<self.m_nameSource.count; index++) {
        
        
        UIView *view = [UIView new];
        
        
        [self addSubview:view];
        
        if (!firstView) {
            view.sd_layout.leftEqualToView(self);
        }
        else {
            
            view.sd_layout.leftSpaceToView(firstView, 0);
        }
        
        view.sd_layout.heightIs(50);
        
        view.sd_layout.widthIs(self.bounds.size.width*1.0/self.m_nameSource.count);
        
        view.sd_layout.bottomSpaceToView(self, 10);
        
        firstView = view;
        
        UIView *titleView = [UIView new];
        
        [view addSubview:titleView];
        
        titleView.backgroundColor = self.colorArrays[index];
        
        titleView.sd_layout .bottomSpaceToView(view, 20);
        
        titleView.sd_layout.leftSpaceToView(view, 10);
        
       
        titleView.sd_layout.heightIs(20);
        
        titleView.sd_layout.widthIs(20);
        
        UILabel *titleLable = [UILabel new];
        
        
        titleLable.textColor = self.colorArrays[index];
        
        titleLable.text = self.m_nameSource[index];
        
        titleLable.numberOfLines = 2;
        
        [titleLable setFont:[UIFont systemFontOfSize:13]];
        
        [view addSubview:titleLable];
        
        titleLable.sd_layout.leftSpaceToView(titleView, 10);
        
        titleLable.sd_layout.rightSpaceToView(view, 5);
        
        titleLable.sd_layout.bottomSpaceToView(view, 10);
                
    }
    
}

/**
 生成饼图
 */
- (void)createPieCharts {
    CGPoint origin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2>130?130:self.bounds.size.height/2);
    
    self.orign = origin;
    
    for (int index = 0; index<self.m_dataSource.count; index++) {
        
        _endAngle = _startAngle+ [_m_dataSource[index] floatValue]*1.0/_total*M_PI*2 ;
        
        CGFloat middleAngle = (_startAngle+_endAngle)/2;
        
        UIBezierPath *middlePath = [UIBezierPath bezierPathWithArcCenter:origin radius:50 startAngle:_startAngle endAngle:middleAngle clockwise:YES];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        
        UIBezierPath *apath = [UIBezierPath bezierPathWithArcCenter:origin radius:50 startAngle:_startAngle endAngle:_endAngle clockwise:YES];
        
        maskLayer.lineWidth = 20;
        
        UIColor *lineColor = self.colorArrays[index];
        
        maskLayer.strokeColor = lineColor.CGColor;
        
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        
        maskLayer.path = apath.CGPath;
        
        maskLayer.strokeStart = 0.0f;
        
        maskLayer.strokeEnd = 0;
       //是否加动画
        if (self.showAnimation) {
            
            CABasicAnimation *caAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            
            caAnimation.duration = 1.5;
            
            caAnimation.fromValue = @(0.0f);
            
            caAnimation.toValue = @(1.0f);
            
            caAnimation.removedOnCompletion = NO;
            
            caAnimation.fillMode = kCAFillModeForwards;
            
            [maskLayer addAnimation:caAnimation forKey:@"caAnimation"];
        }
        
        else {
            maskLayer.strokeEnd = 1.0f;
        }

        [self.layer addSublayer:maskLayer];
        
        [self.m_pointData addObject:[NSValue valueWithCGPoint:middlePath.currentPoint]];
        
        [lineColor set];
        
        _startAngle = _endAngle;

    }

    [self createBiaozhu];

}

/**
 生成柱状图
 */
- (void)createBarCharts {
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    CGFloat totalHeight = self.frame.size.height-90;
    
    [linePath moveToPoint:CGPointMake(KStartX, 20)];
    
    [linePath addLineToPoint:CGPointMake(KStartX, self.frame.size.height-40)];
    
    [linePath addLineToPoint:CGPointMake(self.frame.size.width-KEndX, self.frame.size.height-40)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.path = linePath.CGPath;
    
    lineLayer.lineWidth = 1.0f;
    
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    lineLayer.strokeColor = [UIColor grayColor].CGColor;
    
    [self.layer addSublayer:lineLayer];
    
    for (int index = 0; index < self.m_dataSource.count; index++) {
        
        UIBezierPath *dataPath = [UIBezierPath bezierPath];
        
        [dataPath moveToPoint:CGPointMake(KStartX, KStartY+(totalHeight/self.m_dataSource.count)*index)];
   
        [dataPath addLineToPoint:CGPointMake(KStartX+(self.frame.size.width-KEndX-KEndX-20)*[self.m_dataSource[index] floatValue]/_maxNum,KStartY+(totalHeight/self.m_dataSource.count)*index)];
  
        NSValue *beginValue = [NSValue valueWithCGPoint:CGPointMake(KStartX, KStartY+(totalHeight/self.m_dataSource.count)*index)];
        
        NSValue *endValue = [NSValue valueWithCGPoint:CGPointMake(KStartX+(self.frame.size.width-KEndX-KEndX-20)*[self.m_dataSource[index] floatValue]/_maxNum,KStartY+(totalHeight/self.m_dataSource.count)*index)];
        
        NSDictionary *dic = @{@"beginPoint":beginValue,@"endPoint":endValue};
        
        [self.m_pointData addObject:dic];
        
        CAShapeLayer *dataLayer = [CAShapeLayer layer];
        
        dataLayer.path = dataPath.CGPath;
        
        dataLayer.lineWidth = 20;
        
        dataLayer.strokeStart = 0.f;
        
        dataLayer.strokeEnd = 0.f;
        
        UIColor *lineColor = self.colorArrays[index];
        
        dataLayer.strokeColor = lineColor.CGColor;
        
        if (self.showAnimation) {
            
            CABasicAnimation *caAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            
            caAnimation.duration = 0.75;
            
            caAnimation.fromValue = @(0.0f);
            
            caAnimation.toValue = @(1.0f);
            
            caAnimation.removedOnCompletion = NO;
            
            caAnimation.fillMode = kCAFillModeForwards;
            
            [dataLayer addAnimation:caAnimation forKey:@"caAnimation"];
        }
        
        else {
            dataLayer.strokeEnd = 1.0f;
        }
        

        
        [self.layer addSublayer:dataLayer];
        
    }
    
    [self createBarBiaozhu];
}

/**
 生成柱状标注
 */
- (void)createBarBiaozhu {
    
    for (NSDictionary *dic in self.m_pointData) {
        
        CGPoint beginPoint = [[dic objectForKey:@"beginPoint"] CGPointValue];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(beginPoint.x, beginPoint.y, 1, 1)];
        
        [self addSubview:view];
        
        UILabel *titleLable = [UILabel new];
        
        [self addSubview:titleLable];
        
        titleLable.textColor = self.colorArrays[[self.m_pointData indexOfObject:dic]];
        
        titleLable.text = self.m_nameSource[[self.m_pointData indexOfObject:dic]];
        
        titleLable.textAlignment = NSTextAlignmentRight;
        
        titleLable.font = [UIFont systemFontOfSize:13];
        
        titleLable.sd_layout.rightSpaceToView(view, 5);
        
        titleLable.sd_layout.leftSpaceToView(self, 5);
        
        titleLable.sd_layout.heightIs(20);
        
        titleLable.sd_layout.centerYEqualToView(view);
        
        CGPoint endPoint = [[dic objectForKey:@"endPoint"] CGPointValue];
        
        UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(endPoint.x+5, 0,self.frame.size.width-endPoint.x , 20)];
        
        numLable.centerY = endPoint.y;
        
        numLable.text = [NSString stringWithFormat:@"%@ 个",self.m_dataSource[[self.m_pointData indexOfObject:dic]]];
        
        numLable.textColor = self.colorArrays[[self.m_pointData indexOfObject:dic]];
        
        numLable.font = [UIFont systemFontOfSize:13];

        [self addSubview:numLable];
        
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    for (CALayer *layer in self.layer.sublayers) {
        
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
          
            CAShapeLayer *maskLayer = (CAShapeLayer *)layer;
           
            if (maskLayer.lineWidth == 1.0f) {
                continue;
            }
            
            maskLayer.lineWidth = 20.f;
            
            CGPathRef path = CGPathCreateCopyByStrokingPath(maskLayer.path,NULL,20,0,0,0);
            
            if (CGPathContainsPoint(path, NULL, point, NO)) {

                maskLayer.lineWidth =  25.0f;
                
            }
            
        }
    }
    
}

- (NSMutableArray *)m_pointData {
    if (!_m_pointData) {
        _m_pointData = [NSMutableArray array];
        
        
    }
    return _m_pointData;
}

@end
