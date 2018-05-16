//
//  LRCircleProgress.h
//  SpeedScale
//
//  Created by 1 on 2018/5/11.
//  Copyright © 2018年 luris. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 圆弧进度条类型

 - LRCircleProgressTypeNomal: 传统类型 实心
 - LRCircleProgressTypeScale: 刻度进度条
 - LRCircleProgressTypeSpeedScale: 类似速度仪表盘的刻度
 */
typedef NS_ENUM(NSInteger, LRCircleProgressType) {
    LRCircleProgressTypeNomal       = 0,
    LRCircleProgressTypeScale,
    LRCircleProgressTypeSpeedScale,
};



@interface LRCircleProgressStyle :NSObject
/************************************ 画圆必须设置的属性 ************************************/

/**
 圆心
 */
@property(nonatomic, assign)CGPoint arcCenter;


/**
 半径
 */
@property(nonatomic, assign)CGFloat radius;


/**
 起始位置
 */
@property(nonatomic, assign)CGFloat startAngle;


/**
 结束位置
 */
@property(nonatomic, assign)CGFloat endAngle;


/**
 
 */
@property(nonatomic, assign)BOOL clockWise;

/*********************************** 画圆必须设置的属性 *************************************/


/**
 进度 线宽
 default is 5.0f.
 */
@property(nonatomic, assign)CGFloat progressLineWidth;


/**
 进度 背景色
 default is 0xa52222.
 */
@property(nonatomic, strong)UIColor *progressBgColor;


/**
 进度 颜色
 default is greenColor.
 */
@property(nonatomic, strong)UIColor *progressColor;



/**
 指进度条定边缘样式
 default is kCALineCapRound.
 */
@property(nonatomic, copy)NSString *progressLineCap;

/**
 设置进度 为刻度模式
 刻度线的长度  每条线的间距
 default is @[@2,@6].
 */
@property(nonatomic, copy) NSArray<NSNumber *> *progressLineDashPattern;


/**
  进度条 模式
 default is LRCircleProgressTypeNomal.
 */
@property(nonatomic, assign)LRCircleProgressType  progressType;


/**
 动画时间
 defalut is 2s.
 */
@property(nonatomic, assign)NSTimeInterval animationInterval;


/**
 内圈虚线颜色
 default is redColor.
 */
@property(nonatomic, strong)UIColor *dottedLineColor;


/**
 内圈虚线线宽
 default is 2.0f.
 */
@property(nonatomic, assign)CGFloat dotteLineWidth;


/**
 内圈虚线与进度条之间的距离
 default is 10.0f.
 */
@property(nonatomic, assign)CGFloat dotteOffset;

/**
 内圈虚线长度  每条线的间距
 default is @[@2,@6].
 */
@property(nonatomic, copy) NSArray<NSNumber *> *dotteLineDashPattern;


/**
 是否隐藏内圈虚线
 defalut is NO.
 */
@property(nonatomic, assign)BOOL dottedHidden;



/*********************************** 画速度表盘进度必须设置的属性 *************************************/

/**
 ⚠️⚠️⚠️ progressType = LRCircleProgressTypeSpeedScale ⚠️⚠️⚠️
 */


/**
 总刻度个数
 defalut is 0.
 */
@property(nonatomic, assign)NSInteger  numberOfTotalScale;

/**
 两大刻度之前的小刻度个数
 defalut is 0.
 */

@property(nonatomic, assign)NSInteger  numberOfSmallScale;


/**
 大刻度，在设置时，会比小刻度伸出来一截，可设置此值来讲刻度对齐
 defalut is 8.
 */
@property(nonatomic, assign)CGFloat  bigScaleOffset;

/*********************************** 画速度表盘进度必须设置的属性 *************************************/


@end



@interface LRCircleProgress : UIView



/**
 初始化刻度盘
 
 @param frame 尺寸
 @param style 样式
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame config:(LRCircleProgressStyle *)style;

// 进度
@property(nonatomic, assign)CGFloat progress;


@end
