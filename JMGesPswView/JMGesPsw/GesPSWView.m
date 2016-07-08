//
//  GesPSWView.m
//  HBB_BuyerProject
//
//  Created by CHENG DE LUO on 16/6/3.
//  Copyright © 2016年 CHENG DE LUO. All rights reserved.
//

#import "GesPSWView.h"
#define minPSWLength 4    //最少的点数
#define lineSpace 33   //行列间距
#define roundD 64.2    //圆直径
#define orginSpace 10  //按钮距离View的距离
#define drawLineWidth 1    //线宽度
#define defaultRect CGRectMake(0, 0, 282, 282)   //默认frame
@interface GesPSWView ()
@property (strong, nonatomic) NSMutableArray *selectBtnArr;   //被选中按钮
@property (assign, nonatomic) CGPoint currentPoint;      //目前的点
@property (assign, nonatomic) gesType type;          //手势密码类型
@property (strong, nonatomic) NSString * firstPSW;    //首次手势密码
@property (strong, nonatomic) NSString * secondPSW;    //第二次手势密码
@property (strong, nonatomic) NSMutableArray * totalBtnArr;    //所有按钮数组
@end

@implementation GesPSWView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        
    }
    return self;
}
//初始化视图
-(void)initView
{
    _selectBtnArr = [[NSMutableArray alloc]initWithCapacity:0];
    _totalBtnArr = [[NSMutableArray alloc]init];
    self.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < 9; i ++) {
        int row = i/3;
        int list = i%3;
        float interval = lineSpace;
        float radius = roundD;
        //初始化按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(list*(interval+radius)+orginSpace, row*(interval+radius)+orginSpace, radius, radius)];
        btn.userInteractionEnabled = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"login_circlegray_default"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_circlered_default"] forState:UIControlStateSelected];
        [self addSubview:btn];
        btn.tag = i + 1;
        [_totalBtnArr addObject:btn];
    }

}
//画线
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path;
    if (_selectBtnArr.count == 0) {
        return;
    }
    path = [UIBezierPath bezierPath];
    path.lineWidth = drawLineWidth;
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound;
    [[UIColor colorWithRed:247/255.0 green:77/255.0 blue:97/255.0 alpha:1]set];
    for (int i = 0; i < _selectBtnArr.count; i ++) {
        UIButton *btn = _selectBtnArr[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_currentPoint];
    [path stroke];
}
//手指开始移动
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * oneTouch = [touches anyObject];
    CGPoint point = [oneTouch locationInView:self];
    for (UIButton * oneBtn in self.subviews) {
        if (CGRectContainsPoint(oneBtn.frame, point)) {
            oneBtn.selected = YES;
            if (![_selectBtnArr containsObject:oneBtn]) {
                [_selectBtnArr addObject:oneBtn];
            }
        }
    }
}
//手指移动时候
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch = [touches anyObject];
    CGPoint point = [oneTouch locationInView:self];
    _currentPoint = point;
    for (UIButton *oneBtn in self.subviews) {
        if (CGRectContainsPoint(oneBtn.frame, point)) {
            oneBtn.selected = YES;
            if (![_selectBtnArr containsObject:oneBtn]) {
                [_selectBtnArr addObject:oneBtn];
                [self calDirect];
            }
        }
    }
    [self setNeedsDisplay];
}
//箭头方向
-(void)calDirect
{
    NSUInteger count = _selectBtnArr.count;
    
    if(_selectBtnArr==nil || count<=1)
    {
        return;
    }
    //取出最后一个对象
    UIButton *buttonOne = _selectBtnArr.lastObject;
    
    //倒数第二个
    UIButton *buttonTwo =_selectBtnArr[count -2];
    
    //计算倒数第二个的位置
    CGFloat last_1_x = buttonOne.frame.origin.x;
    CGFloat last_1_y = buttonOne.frame.origin.y;
    CGFloat last_2_x = buttonTwo.frame.origin.x;
    CGFloat last_2_y = buttonTwo.frame.origin.y;
    
    //倒数第一个itemView相对倒数第二个itemView来说
    //正上
    if(last_2_x == last_1_x && last_2_y > last_1_y) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    //正左
    if(last_2_y == last_1_y && last_2_x > last_1_x) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*0.5);

    }
    
    //正下
    if(last_2_x == last_1_x && last_2_y < last_1_y) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);

    }
    
    //正右
    if(last_2_y == last_1_y && last_2_x < last_1_x) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*1.5);

    }
    
    //左上
    if(last_2_x > last_1_x && last_2_y > last_1_y) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*0.75);

    }
    //非45度左上(y距离为1个linespace)
    if(last_2_x > last_1_x && last_2_y > last_1_y && last_2_x-last_1_x >= (2*(roundD+lineSpace)-10)&&(last_2_x-last_1_x==last_2_y-last_1_y)==NO) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*0.65);
        
    }
    //非45度左上(y距离为2个linespace)
    if(last_2_x > last_1_x && last_2_y > last_1_y && last_2_y-last_1_y >= (2*(roundD+lineSpace)-10)&&(last_2_x-last_1_x==last_2_y-last_1_y)==NO) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*0.85);
        
    }
    //右上
    if(last_2_x < last_1_x && last_2_y > last_1_y) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*1.25);

    }
    //非45度右上(y距离为1个linespace)
    if(last_2_x < last_1_x && last_2_y > last_1_y && last_1_x-last_2_x >= (2*(roundD+lineSpace)-10)&&(last_1_x-last_2_x==last_2_y-last_1_y)==NO) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*1.35);
        
    }
    //非45度右上(y距离为2个linespace)
    if(last_2_x < last_1_x && last_2_y > last_1_y && last_2_y-last_1_y >= (2*(roundD+lineSpace)-10)&&(last_1_x-last_2_x==last_2_y-last_1_y)==NO) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*1.15);
        
    }
    //左下
    if(last_2_x > last_1_x && last_2_y < last_1_y) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*0.25);

    }
    //非45度左下(y距离为1个linespace)
    if(last_2_x > last_1_x && last_2_y < last_1_y && last_2_x-last_1_x >= (2*(roundD+lineSpace)-10) &&(last_2_x-last_1_x==last_1_y-last_2_y)==NO) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*0.35);
        
    }
    //非45度左下(y距离为2个linespace)
    if(last_2_x > last_1_x && last_2_y < last_1_y && last_1_y-last_2_y >= (2*(roundD+lineSpace)-10) &&(last_2_x-last_1_x==last_1_y-last_2_y)==NO) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*0.15);
        
    }
    //右下
    if(last_2_x < last_1_x && last_2_y < last_1_y) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*1.75);
    }
    //非45%右下(y距离为1个linespace)
    if(last_2_x < last_1_x && last_2_y < last_1_y && last_1_x-last_2_x >= (2*(roundD+lineSpace)-10)&&(last_1_x-last_2_x==last_1_y-last_2_y)==NO) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*1.65);
    }
    //非45%右下(y距离为2个linespace)
    if(last_2_x < last_1_x && last_2_y < last_1_y && last_1_y-last_2_y >= (2*(roundD+lineSpace)-10)&&(last_1_x-last_2_x==last_1_y-last_2_y)==NO) {
        [buttonTwo setImage:[UIImage imageNamed:@"login_triangle_default"] forState:UIControlStateNormal];
        buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        buttonTwo.transform = CGAffineTransformMakeRotation(M_PI*1.85);
    }
}
//手松开
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取结果
    NSMutableString *result = [[NSMutableString alloc]initWithCapacity:0];
    for (int i = 0; i < _selectBtnArr.count; i ++) {
        UIButton *btn = (UIButton *)_selectBtnArr[i];
        [result appendFormat:@"%d",(int)btn.tag];
    }
    
    UIButton *lastBtn = [_selectBtnArr lastObject];
    _currentPoint = lastBtn.center;
    //当是登录的时候
    if(self.type == loginGesType){
        if(result.length !=0 ){
            //视图恢复原样
            [self resetView];
      if (self.delegate && [self.delegate respondsToSelector:@selector(GesPSWView:getPSW:)]) {
        [self.delegate GesPSWView:self getPSW:result];
      }
        }
    }else{//当时设置手势密码的时候
        //如果是第一次
        if (self.ifSecondPsw == NO) {
            if (result.length != 0) {
            //长度不够指定长度时
              if (result.length < self.minPoint) {
                  //视图恢复原样
                  [self resetView];
                if (self.delegate && [self.delegate respondsToSelector:@selector(notEnoughLengthGesPSWView:)]) {
                    [self.delegate notEnoughLengthGesPSWView:self];
                }
             }else{
                self.firstPSW = result;
                self.ifSecondPsw = YES;
                 //视图恢复原样
                 [self resetView];
                if (self.delegate && [self.delegate respondsToSelector:@selector(firstPSWOVerGesPSWGesPSWView:firstPSW:)]) {
                    [self.delegate firstPSWOVerGesPSWGesPSWView:self firstPSW:self.firstPSW];
                }
              }
            }
        }else{//是第二次输入
            if (result.length != 0) {
            //如果第一次和第二次输入相同
              if ([result isEqualToString:self.firstPSW]) {
                self.secondPSW = result;
                if (self.delegate && [self.delegate respondsToSelector:@selector(GesPSWView:getPSW:)]) {
                    [self.delegate GesPSWView:self getPSW:result];
                }
              }else{
                  //视图恢复原样
                  [self resetView];
                if (self.delegate && [self.delegate respondsToSelector:@selector(errorSecondGesPSWGesPSWView:secondPSW:)]) {
                    [self.delegate errorSecondGesPSWGesPSWView:self secondPSW:result];
                }
              }
            }
        }
    }


}
//视图恢复原样
- (void)resetView
{

    [self removeAllSubviews];
    for (int i = 0; i < 9; i ++) {
        int row = i/3;
        int list = i%3;
        float interval = lineSpace;
        float radius = roundD;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(list*(interval+radius)+orginSpace, row*(interval+radius)+orginSpace, radius, radius)];
        btn.userInteractionEnabled = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"login_circlegray_default"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_circlered_default"] forState:UIControlStateSelected];
        [self addSubview:btn];
        btn.tag = i + 1;
    }
    [_selectBtnArr removeAllObjects];
    [self setNeedsDisplay];
}
//展示
-(void)showInView:(UIView *)view type:(gesType)type
{
    if (self.minPoint) {
    }
    else{
        self.minPoint = minPSWLength;
    }
    self.type = type;
    [view addSubview:self];
}
//隐藏
-(void)hiddenView
{
    [self removeFromSuperview];
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}
@end
