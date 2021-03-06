//
//  LoginViewController.m
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "LoginViewController.h"

#import "BlockActionSheet.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *zoneButton;
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
    
    BOOL is_4s_or_earlier = screen_height < 568.0;
    CGFloat m_edge = is_4s_or_earlier ? kEdgeSmall : kEdgeHuge;
    
    _zoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _zoneButton.frame = CGRectMake(0, headerView.bottom + m_edge, screen_width * 560.0 / 720.0, 40);
    _zoneButton.centerX = 0.5 * screen_width;
    _zoneButton.backgroundColor =[UIColor clearColor];
    [_zoneButton setTitleColor:baseTextColor forState:UIControlStateNormal];
    [_zoneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_zoneButton setTitle:@"请选择服务器" forState:UIControlStateNormal];
    [AppPublic roundCornerRadius:_zoneButton cornerRadius:kButtonCornerRadius];
    _zoneButton.layer.borderColor = baseSeparatorColor.CGColor;
    _zoneButton.layer.borderWidth = 1.0;
    
    [_zoneButton addTarget:self action:@selector(zoneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zoneButton];
    
    float inputHeight = 56;
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.zoneButton.bottom + (is_4s_or_earlier ? 0 : kEdge), self.zoneButton.width, inputHeight * 2 + kEdge)];
    inputView.centerX = 0.5 * screen_width;
    [self.view addSubview:inputView];
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(kEdge, 0, inputView.width - 2 * kEdge, inputHeight)];
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.font = [UIFont systemFontOfSize:14.0];
    self.usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [inputView addSubview:self.usernameTextField];
    [self addTextField:self.usernameTextField imageName:@"login_icon_phone"];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:self.usernameTextField.frame];
    self.passwordTextField.bottom = inputView.height;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:14.0];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [inputView addSubview:self.passwordTextField];
    [self addTextField:self.passwordTextField imageName:@"login_icon_password"];
    
    [inputView addSubview:NewSeparatorLine(CGRectMake(0, self.usernameTextField.bottom - appSeparaterLineSize, inputView.width, appSeparaterLineSize))];
    [inputView addSubview:NewSeparatorLine(CGRectMake(0, self.passwordTextField.bottom - appSeparaterLineSize, inputView.width, appSeparaterLineSize))];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(inputView.left, inputView.bottom + m_edge, inputView.width, 40);
    loginButton.backgroundColor =[UIColor clearColor];
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:baseTextColor forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [AppPublic roundCornerRadius:loginButton cornerRadius:kButtonCornerRadius];
    loginButton.layer.borderColor = baseSeparatorColor.CGColor;
    loginButton.layer.borderWidth = 1.0;
    
    [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.usernameTextField.text = [ud objectForKey:kUserName];
    
    [self downloadServerFileFunction];
    [self updateZoneButtonTitle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)addTextField:(UITextField *)textField imageName:(NSString *)imageName {
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

- (void)loginButtonAction {
    [self.view endEditing:YES];
    if (self.usernameTextField.text.length == 0) {
        [self doShowHintFunction:@"请输入用户名"];
    }
    else if (self.passwordTextField.text.length < kPasswordLengthMin) {
        [self doShowHintFunction:@"请输入正确的密码"];
    }
    else if (![AppPublic getInstance].selectedServer) {
        [self doShowHintFunction:@"服务器地址错误"];
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

- (void)zoneButtonAction {
    NSArray *dataArray = [AppPublic getInstance].serverArray;
    if (dataArray.count) {
        NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary *m_data in dataArray) {
            [m_array addObject:m_data[@"server_name"]];
        }
        QKWEAKSELF;
        BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
            if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                [[AppPublic getInstance] saveSeverWithData:dataArray[buttonIndex - 1]];
                [weakself updateZoneButtonTitle];
            }
        } otherButtonTitlesArray:m_array];
        [sheet showInView:self.view];
    }
    else {
        [self downloadServerFileFunction];
    }
}

- (void)updateZoneButtonTitle {
    if ([AppPublic getInstance].selectedServer) {
        [self.zoneButton setTitle:[AppPublic getInstance].selectedServer[@"server_name"] forState:UIControlStateNormal];
    }
    else {
        [self.zoneButton setTitle:@"请选择服务器" forState:UIControlStateNormal];
    }
}

- (void)downloadServerFileFunction {
    [self doShowHudFunction];
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] downLoadFileWithOperations:nil withSavaPath:[AppPublic getInstance].serverCachePath withUrlString:@"http://d.yunlaila.com.cn/server.json" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            [[AppPublic getInstance] updateServeData];
            [self updateZoneButtonTitle];
        }
        else {
//            [self doShowHintFunction:@"服务器地址错误"];
        }
        
    } withDownLoadProgress:^(float progress) {
        
    }];
}

@end
