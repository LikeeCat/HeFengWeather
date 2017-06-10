//
//  LoginViewController.h
//  HeWeather
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JxbLoginShowType) {
    JxbLoginShowType_NONE,
    JxbLoginShowType_USER,
    JxbLoginShowType_PASS
};

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@end

