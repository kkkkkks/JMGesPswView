//
//  GesPSWView.h
//  HBB_BuyerProject
//
//  Created by CHENG DE LUO on 16/6/3.
//  Copyright © 2016年 CHENG DE LUO. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @author gjm
 */
//手势密码类型
typedef enum {
    loginGesType = 1,     //登录手势密码的时候
    setGesType ,          //设置手势密码的时候
}gesType;

@class GesPSWView;

@protocol GesPSWViewDelegate <NSObject>

@optional
//完成时回调密码
-(void)GesPSWView:(GesPSWView *)gesPSWView getPSW:(NSString *)psw;
//位数不够时回调
-(void)notEnoughLengthGesPSWView:(GesPSWView *)gesPSWView;
//第二次输入不一致回调
-(void)errorSecondGesPSWGesPSWView:(GesPSWView *)gesPSWView secondPSW:(NSString *)secondPSW;
//第一次输完密码后的回调
-(void)firstPSWOVerGesPSWGesPSWView:(GesPSWView *)gesPSWView firstPSW:(NSString *)firstPSW;
@end


@interface GesPSWView : UIView
@property (nonatomic,assign)id <GesPSWViewDelegate> delegate;    //代理
@property (assign,nonatomic) NSInteger minPoint;    //最少的密码位数
@property (assign, nonatomic) BOOL ifSecondPsw;      //是否是第二次输入

//初始化（视图默认大小282 X 282
-(instancetype)initWithFrame:(CGRect)frame;
//视图出现
-(void)showInView:(UIView *)view type:(gesType)type;
//视图消失
-(void)hiddenView;
@end
