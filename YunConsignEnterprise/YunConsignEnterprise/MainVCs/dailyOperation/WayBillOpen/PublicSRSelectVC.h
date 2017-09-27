//
//  PublicSRSelectVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicTableViewController.h"

typedef enum : NSUInteger {
    SRSelectType_Default = 0,
    SRSelectType_Sender,
    SRSelectType_Receiver,
} SRSelectType;

@interface PublicSRSelectVC : AppBasicTableViewController

@property (assign, nonatomic) SRSelectType type;

@end
