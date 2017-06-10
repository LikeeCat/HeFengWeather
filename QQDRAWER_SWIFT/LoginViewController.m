//  LoginViewController.m
//  和风天气
//
//  Created by 樊树康 on 2016/10/6.
//  Copyright © 2017年 懒懒的猫鼬鼠. All rights reserved.
//
#import "MyViewController.h"
#import "LoginViewController.h"
#import "和风天气-Swift.h"
#define mainSize    [UIScreen mainScreen].bounds.size

#define offsetLeftHand      60

#define rectLeftHand        CGRectMake(61-offsetLeftHand, 90, 40, 65)
#define rectLeftHandGone    CGRectMake(mainSize.width / 2 - 100, vLogin.frame.origin.y - 22, 40, 40)

#define rectRightHand       CGRectMake(imgLogin.frame.size.width / 2 + 60, 90, 40, 65)
#define rectRightHandGone   CGRectMake(mainSize.width / 2 + 62, vLogin.frame.origin.y - 22, 40, 40)

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField* txtUser;
    UITextField* txtPwd;
    
    UIImageView* imgLeftHand;
    UIImageView* imgRightHand;
    
    UIImageView* imgLeftHandGone;
    UIImageView* imgRightHandGone;
    
    JxbLoginShowType showType;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"splash_image_blue_bg01_640x960.jpg"]];
    UIImageView* imgLogin = [[UIImageView alloc] initWithFrame:CGRectMake(mainSize.width / 2 - 211 / 2, mainSize.height *0.1, 211, 109)];
    imgLogin.image = [UIImage imageNamed:@"owl-login"];
    imgLogin.layer.masksToBounds = YES;
    [self.view addSubview:imgLogin];
    
    imgLeftHand = [[UIImageView alloc] initWithFrame:rectLeftHand];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:rectRightHand];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];

    UIView* vLogin = [[UIView alloc] initWithFrame:CGRectMake(15, imgLogin.frame.origin.y + 0.89* imgLogin.frame.size.height, mainSize.width - 30, mainSize.height *0.3)];
    vLogin.backgroundColor = [UIColor  whiteColor];
    vLogin.alpha = 0.7;
    [self.view addSubview:vLogin];
    
    imgLeftHandGone = [[UIImageView alloc] initWithFrame:rectLeftHandGone];
    imgLeftHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgLeftHandGone];
    
    imgRightHandGone = [[UIImageView alloc] initWithFrame:rectRightHandGone];
    imgRightHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgRightHandGone];
    
    txtUser = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, vLogin.frame.size.width - 60, 44)];
    txtUser.delegate = self;
    txtUser.layer.cornerRadius = 5;
    txtUser.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtUser.layer.borderWidth = 0.5;
    txtUser.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    txtUser.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [txtUser.leftView addSubview:imgUser];
    [vLogin addSubview:txtUser];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(30, 90, vLogin.frame.size.width - 60, 44)];
    txtPwd.delegate = self;
    txtPwd.layer.cornerRadius = 5;
    txtPwd.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtPwd.layer.borderWidth = 0.5;
    txtPwd.secureTextEntry = YES;
    txtPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    txtPwd.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [txtPwd.leftView addSubview:imgPwd];
    [vLogin addSubview:txtPwd];

    UIButton * login = [[UIButton alloc]initWithFrame:CGRectMake(txtPwd.frame.origin.x+15,vLogin.frame.origin.y + vLogin.frame.size.height + 20, txtPwd.frame.size.width, txtPwd.frame.size.height)];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    login.layer.cornerRadius = 5;
    login.layer.borderColor = [[UIColor whiteColor] CGColor];
    login.layer.borderWidth = 0.5;
    [self.view addSubview:login];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
   
    //忘记密码
    UIButton * forgerPwd = [[UIButton alloc]initWithFrame:CGRectMake(mainSize.width - 100 ,login.frame.origin.y + 50, 100, 30)];
    [forgerPwd addTarget:self action:@selector(forgetpassword) forControlEvents:UIControlEventTouchUpInside];
    
    [forgerPwd setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgerPwd.titleLabel.font = [UIFont systemFontOfSize: 10.0];
    forgerPwd.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:forgerPwd];
    
    //注册按钮
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(login.frame.origin.x,login.frame.origin.y + 50 , login.frame.size.width-30, 30)];
    [registerBtn setTitle:@"还没有账号，点击注册吧" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    
    registerBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:forgerPwd];
    
    [registerBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    
    
    
}

#pragma mark - register
- (void)registerUser{
    RegisterViewController * vc = [[RegisterViewController alloc]init];
    
    [self presentViewController:vc animated:true completion:^{
        
    }];
}
- (void)login{
    if ([txtUser.text isEqualToString:@""] || [txtPwd.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
    NSString * name = txtUser.text;
    [UserTable queryUserNameAndPasswordWithName:name complete:^(NSString * result) {
        if ([result isEqualToString:@"error"] || [result isEqualToString:txtPwd.text] == NO) {
            [self showAlert];
        }else{
            MyViewController * vc = [[MyViewController alloc]init];
            vc.userName = name;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"loginUser"];

            [self.navigationController pushViewController:vc animated:YES];
            [self.navigationController setViewControllers:[NSArray arrayWithObject:vc]] ;
        }

    }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)forgetpassword{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请联系管理员进行解锁：155XXXXXXXX" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:txtUser]) {
        if (showType != JxbLoginShowType_PASS)
        {
            showType = JxbLoginShowType_USER;
            return;
        }
        showType = JxbLoginShowType_USER;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - offsetLeftHand, imgLeftHand.frame.origin.y + 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48, imgRightHand.frame.origin.y + 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - 70, imgLeftHandGone.frame.origin.y, 40, 40);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + 30, imgRightHandGone.frame.origin.y, 40, 40);
         
            
        } completion:^(BOOL b) {
        }];

    }
    else if ([textField isEqual:txtPwd]) {
        if (showType == JxbLoginShowType_PASS)
        {
            showType = JxbLoginShowType_PASS;
            return;
        }
        showType = JxbLoginShowType_PASS;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + offsetLeftHand, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);

        } completion:^(BOOL b) {
        }];
    }
}



@end
