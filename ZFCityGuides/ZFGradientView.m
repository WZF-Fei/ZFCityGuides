//
//  ZFGradientView.m
//  ZFCityGuides
//
//  Created by macOne on 16/2/16.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "ZFGradientView.h"

@interface ZFGradientView ()

@property (nonatomic,strong) UILabel *lowTemperatureLabel;

@property (nonatomic,strong) UILabel *highTemperatureLabel;

@property (nonatomic,strong) CAGradientLayer *gradientLayer;

@property (nonatomic,strong) NSArray *temperatureArray;

@property (nonatomic,strong) NSArray *colorsArray;

@property (nonatomic,assign) int minIndex;

@property (nonatomic,assign) int maxIndex;

@end

@implementation ZFGradientView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
        self.digitAnimated = YES;
    }
    
    return self;
}

-(void)initSubViews{
    
//    _lowTemperature = 39;
//    _highTemperature = 67;
    
//    UIColor *lowTemperatureTextColor = [self GetColorMinNumber:_lowTemperature];
//    UIColor *highTemperatureTextColor = [self GetColorMaxNumber:_highTemperature];
    
    static const CGFloat labelWidth = 80.0f;
    _lowTemperatureLabel = [UILabel new];
    _lowTemperatureLabel.text = [NSString stringWithFormat:@"%.f°",_lowTemperature];
    _lowTemperatureLabel.frame = CGRectMake(0, 0, labelWidth, 25);
    _lowTemperatureLabel.font = [UIFont fontWithName:BodyFontName size:30.0f];
    _lowTemperatureLabel.textColor = self.colorsArray[0];
    _lowTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lowTemperatureLabel];
    
   
    UILabel *beforeMothLabel = [UILabel new];
    beforeMothLabel.text = @"1月";
    beforeMothLabel.textColor = [UIColor grayColor];
    beforeMothLabel.font = [UIFont fontWithName:BodyFontName size:10.0f];
    beforeMothLabel.textAlignment = NSTextAlignmentCenter;
    beforeMothLabel.frame = CGRectMake(-5, CGRectGetMaxY(_lowTemperatureLabel.frame) + 5, labelWidth, 10);
    [self addSubview:beforeMothLabel];
    
    _highTemperatureLabel = [UILabel new];
    _highTemperatureLabel.text = [NSString stringWithFormat:@"%.f°",_highTemperature];;
    _highTemperatureLabel.frame = CGRectMake(self.frame.size.width - labelWidth - 20, 0, labelWidth, 25);
    _highTemperatureLabel.font = [UIFont fontWithName:BodyFontName size:30.0f];
    _highTemperatureLabel.textColor = self.colorsArray[0];
    _highTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_highTemperatureLabel];
    
    
    UILabel *nearestMothLabel = [UILabel new];
    nearestMothLabel.text = @"7月";
    nearestMothLabel.textColor = [UIColor grayColor];
    nearestMothLabel.font = [UIFont fontWithName:BodyFontName size:10.0f];
    nearestMothLabel.textAlignment = NSTextAlignmentCenter;
    nearestMothLabel.frame = CGRectMake(CGRectGetMinX(_highTemperatureLabel.frame) -5, CGRectGetMaxY(_highTemperatureLabel.frame)+ 5, labelWidth, 10);
    [self addSubview:nearestMothLabel];
    
    

    _gradientLayer =  [CAGradientLayer layer];
    _gradientLayer.cornerRadius = 12.5;
    [_gradientLayer setLocations:@[@0,@1.0]];
    _gradientLayer.frame = CGRectMake(CGRectGetMaxX(_lowTemperatureLabel.frame), 5/2.0 , CGRectGetMinX(_highTemperatureLabel.frame) - CGRectGetMaxX(_lowTemperatureLabel.frame), 25);
 
    [_gradientLayer setColors:@[(id)[self.colorsArray[0] CGColor],(id)[self.colorsArray[0] CGColor]]];
    [_gradientLayer setStartPoint:CGPointMake(0, 0)];
    [_gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.layer addSublayer:_gradientLayer];
    
//    [self updateGradientWithLowData:0 highData:0];
    
    
}

#pragma mark - private method
#pragma mark -获取最小值的颜色值
-(UIColor *)GetColorMinNumber:(CGFloat)number{
    

    UIColor *color = nil;
    for (int i = 0; i < self.temperatureArray.count; i++) {
        if (i + 1 >= self.temperatureArray.count) {
           
            _minIndex = i -1;
            color = [self colorForIndex:i -1 withNumeber:number];
            return color;
            
        }
        if ([self.temperatureArray[i] floatValue] <= number && [self.temperatureArray[i+1] floatValue] >= number) {
            
            _minIndex = i;
            color = [self colorForIndex:i withNumeber:number];
            return color;

        }
    }
    return color;
}
#pragma mark -获取最大值的颜色值
-(UIColor *)GetColorMaxNumber:(CGFloat)number{
    
    UIColor *color = nil;
    for (int i = 0; i < self.temperatureArray.count; i++) {
        if (i + 1 >= self.temperatureArray.count) {
            NSLog(@"最后一个颜色");
            _maxIndex = i;
            color = [self colorForIndex:i -1 withNumeber:number];
            return color;
            
        }
        if ([self.temperatureArray[i] floatValue] <= number && [self.temperatureArray[i+1] floatValue] >= number) {
            
            _maxIndex = i + 1;
            color = [self colorForIndex:i withNumeber:number];
            return color;
            
        }
    }
    return color;
}

-(UIColor *)colorForIndex:(NSInteger)index withNumeber:(CGFloat)number{
    
    UIColor *color = nil;
    static const int N = 24;
    
    UIColor *prevColor = self.colorsArray[index];
    UIColor *nextColor = self.colorsArray[index+1];
    const CGFloat *components1 = CGColorGetComponents(prevColor.CGColor);
    const CGFloat *components2 = CGColorGetComponents(nextColor.CGColor);
    
    CGFloat red = (components2[0] - components1[0]) * (number - [self.temperatureArray[index] floatValue])/N + components1[0];
    CGFloat green = (components2[1] - components1[1]) * (number - [self.temperatureArray[index] floatValue])/N + components1[1];
    CGFloat blue = (components2[2] - components1[2]) * (number - [self.temperatureArray[index] floatValue])/N + components1[2];
    
    color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    return color;
}

#pragma mark - 动态更新渐变颜色
-(void)updateGradientWithLowData:(CGFloat)lowData highData:(CGFloat)highData{
    
    UIColor *lowTemperatureTextColor = [self GetColorMinNumber:lowData];
    UIColor *highTemperatureTextColor = [self GetColorMaxNumber:highData];
    
    _lowTemperatureLabel.textColor = lowTemperatureTextColor;
    _highTemperatureLabel.textColor = highTemperatureTextColor;
    
    NSMutableArray *colors = [NSMutableArray array];
    
    
    for (int i = _minIndex; i < _maxIndex +1; i++) {
        
        if (i == _minIndex) {
            [colors addObject:(id)[lowTemperatureTextColor CGColor]];
            continue;
        }
        
        if (i == _maxIndex) {
            [colors addObject:(id)[highTemperatureTextColor CGColor]];
            continue;
        }
        [colors addObject:(id)[self.colorsArray[i] CGColor]];
    }
    
    NSMutableArray *locations = [NSMutableArray array];
    
    for (int j = 0; j < colors.count; j ++) {
        
        
        [locations addObject:@(1.0 /(colors.count -1) * j) ];
    }
    
//    NSLog(@"colors:%@",colors);
    
    //colors 数组小于等于1时，无法生成渐变颜色
    if (colors.count <= 1) {
        [colors insertObject:(id)[self.colorsArray[0] CGColor] atIndex:0];
    }

    [_gradientLayer setLocations:locations];
    [_gradientLayer setColors:colors];
}

#pragma mark - 动态更新label数字
-(void)animatedForLabel:(UILabel *)label forKey:(NSString *)key fromValue:(CGFloat)fromValue toValue:(CGFloat) toValue{
    
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:key initializer:^(POPMutableAnimatableProperty *prop) {
        
        prop.readBlock = ^(id obj, CGFloat values[]) {
            
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *string = nil;
         
            string = [NSString stringWithFormat:@"%.f°",values[0]];
     
            
            label.text = string;
            
            if ([key isEqualToString:@"low"]) {
                
                [self updateGradientWithLowData:values[0] highData:_highTemperature];

                
            }
            else if ([key isEqualToString:@"high"]){
                

                [self updateGradientWithLowData:_lowTemperature highData:values[0]];

                if (!values[0]) {
                    _lowTemperatureLabel.textColor = self.colorsArray[0];
                }
            }
            
        };
        
        //            prop.threshold = 0.1;
    }];
    
    POPBasicAnimation *anBasic = [POPBasicAnimation easeInEaseOutAnimation];   //动画属性
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(fromValue);   //从0开始
    anBasic.toValue = @(toValue);  //
    anBasic.duration = 1.5;    //持续时间
    anBasic.beginTime = CACurrentMediaTime() + 0.1;    //延迟0.1秒开始
    [label pop_addAnimation:anBasic forKey:key];
}
#pragma mark - getter
-(NSArray *)colorsArray{
    
    if (!_colorsArray) {
        _colorsArray = [NSArray new];
    }
    
    _colorsArray = @[kUIColorFromRGB(0x99CCFF),
                     kUIColorFromRGB(0x3366FF),
                     kUIColorFromRGB(0x6633FF),
                     kUIColorFromRGB(0xCC33FF),
                     kUIColorFromRGB(0xFF33CC),
                     kUIColorFromRGB(0xFF3366)];
    
    return _colorsArray;
}

-(NSArray *)temperatureArray{
    
    if (!_temperatureArray) {
        _temperatureArray = [NSArray new];
    }
    static const CGFloat maxTemperature = 120.0;
    
    static const CGFloat N = 5;
    _temperatureArray = @[@0,@(maxTemperature/N * 1), @(maxTemperature/N * 2),@(maxTemperature/N * 3),@(maxTemperature/N * 4),@(maxTemperature/N * 5)];
    
    return _temperatureArray;
}

-(void)setLowTemperature:(CGFloat)lowTemperature{
    
    _lowTemperature = lowTemperature;
    [self animatedForLabel:_lowTemperatureLabel forKey:@"low" fromValue:0 toValue:lowTemperature];

}

-(void)setHighTemperature:(CGFloat)highTemperature{
    
    _highTemperature = highTemperature;
    [self animatedForLabel:_highTemperatureLabel forKey:@"high" fromValue:0 toValue:highTemperature];

}

#pragma mark - view动画
-(void)increaseNumber:(BOOL)bIncreased animated:(BOOL)animated{
    
    if (!animated) {
        return;
    }
    
    if (!bIncreased) {
    
        [self animatedForLabel:_lowTemperatureLabel forKey:@"low" fromValue:_lowTemperature toValue:0];
        [self animatedForLabel:_highTemperatureLabel forKey:@"high" fromValue:_highTemperature toValue:0];

    }
    else{
        [self animatedForLabel:_lowTemperatureLabel forKey:@"low" fromValue:0 toValue:_lowTemperature];
        [self animatedForLabel:_highTemperatureLabel forKey:@"high" fromValue:0 toValue:_highTemperature];

    }
}

@end
