//
//  LoginViewController.m
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width * 588.0 / 720.0)];
    headerView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"login_bg"].CGImage);
    [self.view addSubview:headerView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TYBANG_s"]];
    logoView.top = 40 * headerView.height / 294;
    logoView.right = headerView.width - 32;
    [headerView addSubview:logoView];

    UILabel *nameLabel = NewLabel(CGRectMake(0, 0, 200, 20), [UIColor whiteColor], nil, NSTextAlignmentCenter);
    nameLabel.text = @"托运邦";
    [AppPublic adjustLabelWidth:nameLabel];
    [AppPublic adjustLabelHeight:nameLabel];
    nameLabel.centerX = logoView.centerX;
    nameLabel.top = logoView.bottom + kEdge;
    [headerView addSubview:nameLabel];
    
    UIFont *noteFont = [AppPublic appFontOfSize:appLabelFontSize];
    UILabel *noteLabel = NewLabel(CGRectMake(0, 0, 20, 200), [UIColor whiteColor], noteFont, NSTextAlignmentCenter);
    noteLabel.width = 1.5 * [AppPublic textSizeWithString:@"托" font:noteFont constantHeight:noteLabel.height].width;
    noteLabel.top = nameLabel.bottom + 24;
    noteLabel.centerX = nameLabel.centerX;
    noteLabel.numberOfLines = 0;
    noteLabel.text = @"您身边的物流管家";
    [AppPublic adjustLabelHeight:noteLabel];
    noteLabel.height += (2 * kEdge);
    noteLabel.layer.borderWidth = 1.0;
    noteLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    [headerView addSubview:noteLabel];
    if (noteLabel.bottom > headerView.height - kEdgeSmall) {
        noteLabel.bottom = headerView.height - kEdgeSmall;
    }
    
    float inputHeight = 56;
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.bottom + kEdgeBig, screen_width * 560.0 / 720.0, inputHeight * 2 + kEdgeBig)];
    inputView.centerX = 0.5 * screen_width;
    [self.view addSubview:inputView];
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(kEdge, 0, inputView.width - 2 * kEdge, inputHeight)];
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.font = [UIFont systemFontOfSize:14.0];
    self.usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [inputView addSubview:self.usernameTextField];
    [self addTextField:self.usernameTextField imageName:@"login_icon_phone"];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(kEdge, inputHeight + kEdgeBig, inputView.width - 2 * kEdge, inputHeight)];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:14.0];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [inputView addSubview:self.passwordTextField];
    [self addTextField:self.passwordTextField imageName:@"login_icon_password"];
    
    [inputView addSubview:NewSeparatorLine(CGRectMake(0, self.usernameTextField.bottom - appSeparaterLineSize, inputView.width, appSeparaterLineSize))];
    [inputView addSubview:NewSeparatorLine(CGRectMake(0, self.passwordTextField.bottom - appSeparaterLineSize, inputView.width, appSeparaterLineSize))];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(inputView.left, inputView.bottom + 40, inputView.width, 40);
    loginButton.backgroundColor =[UIColor clearColor];
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:baseTextColor forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [AppPublic roundCornerRadius:loginButton cornerRadius:kButtonCornerRadius];
    loginButton.layer.borderColor = baseSeparatorColor.CGColor;
    loginButton.layer.borderWidth = 1.0;
    
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.usernameTextField.text = [ud objectForKey:kUserName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)addTextField:(UITextField *)textField imageName:(NSString *)imageName{
    textField.delegate = self;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, textField.height)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.centerY = 0.5 * leftView.height;
    imageView.image = [UIImage imageNamed:imageName];
    [leftView addSubview:imageView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)loginAction{
    [self.view endEditing:YES];
    
    if (self.usernameTextField.text.length == 0) {
        [self showHint:@"请输入用户名"];
    }
    else if (self.passwordTextField.text.length < kPasswordLengthMin) {
        [self showHint:@"请输入正确的密码"];
    }
    else {
        [self doShowHudFunction];
        
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] loginWithID:self.usernameTextField.text Password:self.passwordTextField.text completion:^(id responseBody, NSError *error){
            [weakself doHideHudFunction];
            if (error) {
                [weakself showHint:error.userInfo[@"message"]];
            }
        }];
    }
}

#pragma textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger length = kInputLengthMax;
    if ([textField isEqual:self.usernameTextField]) {
        length = kPhoneNumberLength;
    }
    else if ([textField isEqual:self.passwordTextField]) {
        length = kPasswordLengthMax;
    }
    return range.location < length;
}

@end
