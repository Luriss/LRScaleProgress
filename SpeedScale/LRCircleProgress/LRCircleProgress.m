//
//  LRCircleProgress.m
//  SpeedScale
//
//  Created by 1 on 2018/5/11.
//  Copyright © 2018年 luris. All rights reserved.
//

#import "LRCircleProgress.h"


// rgb颜色转换（16进制->10进制）
#define LRColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation LRCircleProgressStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _clockWise = YES;
        _progressLineWidth = 5.0f;
        _progressBgColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _progressColor = [UIColor colorWithRed:0.0/255.0 green:160.0/255.0 blue:255.0/255.0 alpha:1.0f];
        _dottedLineColor = [UIColor redColor];
        _dotteLineWidth = 2.0f;
        _dotteLineDashPattern = @[@2,@6];
        _animationInterval = 2.0f;
        _dottedHidden = NO;
        _progressType = LRCircleProgressTypeNomal;
        _bigScaleOffset = 8.0f;
        _progressLineCap = kCALineCapRound;
        _dotteOffset = 10.0f;
    }
    return self;
}

#pragma mark --- Setter & Getter

#pragma mark --- Draw Circle Setter
- (void)setArcCenter:(CGPoint)arcCenter
{
    _arcCenter = arcCenter;
}

- (void)setRadius:(CGFloat)radius
{
    if (radius > 1) {
        _radius = radius;
    }
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
}

- (void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle;
}


- (void)setClockWise:(BOOL)clockWise
{
    _clockWise = clockWise;
}

#pragma mark --- Progress Setter

- (void)setProgressColor:(UIColor *)progressColor
{
    if (progressColor) {
        _progressColor = progressColor;
    }
}


- (void)setProgressBgColor:(UIColor *)progressBgColor
{
    if (progressBgColor) {
        _progressBgColor = progressBgColor;
    }
}


- (void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    _progressLineWidth = progressLineWidth;
}

- (void)setProgressLineCap:(NSString *)progressLineCap
{
    if (progressLineCap.length > 0) {
        _progressLineCap = progressLineCap;
    }
}

- (void)setProgressLineDashPattern:(NSArray<NSNumber *> *)progressLineDashPattern
{
    NSAssert(progressLineDashPattern, @"must be not null value.");
    
    if (progressLineDashPattern.count > 0) {
        _progressLineDashPattern = progressLineDashPattern;
    }
}

- (void)setAnimationInterval:(NSTimeInterval)animationInterval
{
    _animationInterval = animationInterval;
}

#pragma mark --- DottedLine Setter

- (void)setDottedLineColor:(UIColor *)dottedLineColor
{
    if (dottedLineColor) {
        _dottedLineColor = dottedLineColor;
    }
}

- (void)setDotteLineWidth:(CGFloat)dotteLineWidth
{
    _dotteLineWidth = dotteLineWidth;
}

- (void)setDotteLineDashPattern:(NSArray<NSNumber *> *)dotteLineDashPattern
{
    NSAssert(dotteLineDashPattern, @"must be not null value.");
    if (dotteLineDashPattern.count > 0) {
        _dotteLineDashPattern = dotteLineDashPattern;
    }
}

- (void)setDottedHidden:(BOOL)dottedHidden
{
    _dottedHidden = dottedHidden;
}


- (void)setDotteOffset:(CGFloat)dotteOffset
{
    _dotteOffset = dotteOffset;
}


#pragma mark --- Scale Setter

- (void)setNumberOfSmallScale:(NSInteger)numberOfSmallScale
{
    _numberOfSmallScale = numberOfSmallScale;
}

- (void)setNumberOfTotalScale:(NSInteger)numberOfTotalScale
{
    _numberOfTotalScale = numberOfTotalScale;
}

- (void)setBigScaleOffset:(CGFloat)bigScaleOffset
{
    _bigScaleOffset = bigScaleOffset;
}

@end



@interface LRCircleProgress ()


@property(nonatomic, strong)LRCircleProgressStyle   *style;

@property (nonatomic, strong)CAShapeLayer       *progressLayer;         // 进度 ShapeLayer

@property (nonatomic, assign)CGFloat  targetProgress;      // 目标进度
@property (nonatomic, strong)NSTimer *progressTimer;       // 进度条动画计时器

@property (nonatomic, strong)NSMutableArray<CAShapeLayer *> *layerArray;  // 缓存仪表盘刻度layer

@end



@implementation LRCircleProgress



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.style = [[LRCircleProgressStyle alloc] init];
        [self addSublayers];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame config:(LRCircleProgressStyle *)style
{
    self = [super initWithFrame:frame];
    if (self) {
        if (style) {
            self.style = style;
        }
        else{
            self.style = [[LRCircleProgressStyle alloc] init];
        }
        
        [self addSublayers];
    }
    return self;
}

#pragma  mark --- Draw Layer
// 绘制圆形路径
- (void)addSublayers {
    
    if (!self.style.dottedHidden) {
        [self addDottedLineLayer];
    }
    
    if (self.style.progressType == LRCircleProgressTypeSpeedScale) {
        if (!_layerArray) {
            self.layerArray = [NSMutableArray arrayWithCapacity:self.style.numberOfTotalScale];
        }
        
        [self drawSpeedScale];
    }
    else{
        [self addNomalBgLayer];
        [self.layer addSublayer:self.progressLayer];
    }
}


- (void)addDottedLineLayer
{
    //  第一层浅白色的虚线圆弧
     CAShapeLayer *dottedLineLayer = [CAShapeLayer layer];
    dottedLineLayer.strokeColor = [self.style.dottedLineColor CGColor];
    dottedLineLayer.fillColor = [UIColor clearColor].CGColor;
    dottedLineLayer.lineWidth = self.style.dotteLineWidth;
    //线的宽度  每条线的间距
    dottedLineLayer.lineDashPattern  = self.style.dotteLineDashPattern;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.style.arcCenter radius:(self.style.radius - self.style.dotteOffset) startAngle:self.style.startAngle endAngle:self.style.endAngle clockwise:self.style.clockWise];
    dottedLineLayer.path = [path CGPath];
    
    [self.layer addSublayer:dottedLineLayer];

}


- (void)addNomalBgLayer
{
    //获取环形路径
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.fillColor = [[UIColor clearColor] CGColor];
    bgLayer.strokeColor = self.style.progressBgColor.CGColor; // path的渲染颜色
    bgLayer.opacity = 1.0f; //背景颜色的透明度
    bgLayer.lineCap = self.style.progressLineCap;//指定线的边缘是圆的
    bgLayer.lineWidth = self.style.progressLineWidth;//线的宽度
    bgLayer.lineDashPattern = self.style.progressLineDashPattern;

    bgLayer.path = [self createCyclePath];
    [self.layer addSublayer:bgLayer];
}



- (CGPathRef )createCyclePath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.style.arcCenter radius:self.style.radius startAngle:self.style.startAngle endAngle:self.style.endAngle clockwise:self.style.clockWise];
    return path.CGPath;
}


-(void)drawSpeedScale{
    
    // （结束角度 - 开始角度）/ 总刻度数
    CGFloat perAngle=(fabs(self.style.endAngle - self.style.startAngle))/self.style.numberOfTotalScale;
    //计算出每段弧线的起始角度和结束角度
    //我们画的弧线与内侧弧线是同一个圆心
    for (NSInteger i = 0; i<= self.style.numberOfTotalScale; i++) {
        
        CGFloat startAngel = (self.style.startAngle+ perAngle * i);
        CGFloat endAngel = startAngel + perAngle/5;
        
        if ((self.style.numberOfSmallScale != 0)&&(i % self.style.numberOfSmallScale) == 0) {
            UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:self.style.arcCenter radius:self.style.radius- self.style.bigScaleOffset startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *perLayer = [CAShapeLayer layer];
            perLayer.strokeColor = self.style.progressBgColor.CGColor;
            perLayer.lineWidth   = self.style.progressLineWidth + 20 ;
            perLayer.path = tickPath.CGPath;
            [self.layer addSublayer:perLayer];
            [self.layerArray addObject:perLayer];
        }
        else{
            UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:self.style.arcCenter radius:self.style.radius startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *perLayer = [CAShapeLayer layer];
            perLayer.strokeColor = self.style.progressBgColor.CGColor;
            perLayer.lineWidth   = self.style.progressLineWidth;
            perLayer.path = tickPath.CGPath;
            [self.layer addSublayer:perLayer];
            [self.layerArray addObject:perLayer];
        }
    }
}


#pragma mark --- Setter & Getter
- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = self.style.progressColor.CGColor;
        _progressLayer.opacity = 1;
        _progressLayer.lineCap = self.style.progressLineCap;
        _progressLayer.lineWidth = self.style.progressLineWidth;
        _progressLayer.lineDashPattern = self.style.progressLineDashPattern;
        _progressLayer.path = [self createCyclePath];
        _progressLayer.strokeEnd = 0.0f;
    }
    return _progressLayer;
}


- (void)setProgress:(CGFloat)progress
{
    if (progress > 1.0f){
        progress = 1.0f;
    }
    else if (progress < 0.0f){
        progress = 0.0f;
    }
    
    _targetProgress = progress;
    CGFloat increment = ((_targetProgress - _progress) * 0.05)/0.5;
    [self startProgressTimer:[NSNumber numberWithFloat:increment]];
}


#pragma mark --- Timer Method
- (void)startProgressTimer:(NSNumber *)increment
{
    if (!_progressTimer) {
        _progressTimer = [NSTimer timerWithTimeInterval:0.05
                                                 target:self
                                               selector:@selector(updateProgress:)
                                               userInfo:increment
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    }
}


- (void)stopProgressTimer
{
    if (_progressTimer && [_progressTimer isValid]){
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}


- (void)updateProgress:(NSTimer *)timer
{
    CGFloat increment = [timer.userInfo floatValue];
    
    _progress += increment;
    
    if ((increment < 0 && _progress <= _targetProgress) || (increment > 0 && _progress >= _targetProgress)){
        [self stopProgressTimer];
        _progress = _targetProgress;
    }
    
    if (self.style.progressType == LRCircleProgressTypeSpeedScale) {
        [self setSpeedScaleProgress];
    }
    else{
        _progressLayer.strokeEnd = _progress;
    }
}

- (void)setSpeedScaleProgress
{
    NSInteger progressScale = ceilf(self.style.numberOfTotalScale * _progress);

    if (progressScale > self.style.numberOfTotalScale) {
        return ;
    }
    
    for (NSInteger i = 0; i < self.style.numberOfTotalScale; i ++) {
        CAShapeLayer *layer = (CAShapeLayer *)[self.layerArray objectAtIndex:i];
        if (i < progressScale) {
            layer.strokeColor = self.style.progressColor.CGColor;
        }
        else{
            layer.strokeColor = self.style.progressBgColor.CGColor;
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
