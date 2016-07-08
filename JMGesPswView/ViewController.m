//
//  ViewController.m
//  JMGesPswView
//
//  Created by CHENG DE LUO on 16/7/7.
//  Copyright © 2016年 CHENG DE LUO. All rights reserved.
//

#import "ViewController.h"
#import "GesPSWView.h"
@interface ViewController ()<GesPSWViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *loginLabel;
@property (strong, nonatomic) IBOutlet UILabel *outputLabel;
@property (strong, nonatomic) GesPSWView * gesPSWView;
@property (assign, nonatomic) BOOL isLogin ;
@property (strong, nonatomic) NSString * truePassword;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //初始化view
    [self initView];
}
//初始化view
-(void)initView{
    self.truePassword = @"248659";
}
-(void)initGesPswView{
    self.gesPSWView = [[GesPSWView alloc]initWithFrame:CGRectMake(0, 0, 282,282)];
    self.gesPSWView.delegate = self;
}
//设置模式
- (IBAction)setPswAction:(id)sender {
    if (self.gesPSWView) {
        [self.gesPSWView hiddenView];
    }
    self.loginLabel.text = @"第一次输出密码是:";
    self.outputLabel.text = @"第二次输出密码是:";
       self.isLogin = NO;
    [self initGesPswView];
    [self.gesPSWView showInView:self.contentView type:setGesType];
}
//登录模式
- (IBAction)loginAction:(id)sender {
    if (self.gesPSWView) {
        [self.gesPSWView hiddenView];
    }
    self.loginLabel.text = [NSString stringWithFormat:@"登录密码是：%@",self.truePassword];
    self.outputLabel.text = @"手势密码输出是：";

    self.isLogin = YES;
    [self initGesPswView];
    [self.gesPSWView showInView:self.contentView type:loginGesType];
}

#pragma  mark - GesPSWViewDelegate
//完成时回调密码
-(void)GesPSWView:(GesPSWView *)gesPSWView getPSW:(NSString *)psw{
    if (self.isLogin == YES) {
        self.outputLabel.text = [NSString stringWithFormat:@"手势密码输出是：%@",psw];
        if ([psw isEqualToString:self.truePassword]) {
            self.tipsLabel.text = @"登录成功";
            self.tipsLabel.textColor = [UIColor blackColor];
        }else{
            self.tipsLabel.text = @"密码错误，请重新输入";
            [self shakeLabel:self.tipsLabel];
            self.tipsLabel.textColor = [UIColor redColor];
        }
    }else{
        self.tipsLabel.text = @"设置密码成功";
        self.tipsLabel.textColor = [UIColor blackColor];
        self.outputLabel.text = [NSString stringWithFormat:@"第二次输出密码是:%@",psw];
    }
}
//位数不够时回调
-(void)notEnoughLengthGesPSWView:(GesPSWView *)gesPSWView{
    self.tipsLabel.text = @"密码位数不足";
    [self shakeLabel:self.tipsLabel];
    self.tipsLabel.textColor = [UIColor redColor];
}
//第二次输入不一致回调
-(void)errorSecondGesPSWGesPSWView:(GesPSWView *)gesPSWView secondPSW:(NSString *)secondPSW{
    self.tipsLabel.text = @"前后密码不一致，请重新输入";
    [self shakeLabel:self.tipsLabel];
    self.tipsLabel.textColor = [UIColor redColor];
    self.outputLabel.text = [NSString stringWithFormat:@"第二次输出密码是:%@",secondPSW];

}
//第一次输完密码后的回调
-(void)firstPSWOVerGesPSWGesPSWView:(GesPSWView *)gesPSWView firstPSW:(NSString *)firstPSW{
    self.loginLabel.text = [NSString stringWithFormat:@"第一次输出密码是:%@",firstPSW];
}
//标签抖动
-(void)shakeLabel:(UIView *)labelView
{
    // 获取到当前的View
    CALayer * viewLayer = labelView.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 5, position.y);
    CGPoint y = CGPointMake(position.x - 5, position.y);
    // 设置动画
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.06];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}
@end
