//
//  PublicSaveVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicShowTableVC.h"

@interface PublicSaveVC : PublicShowTableVC

@property (copy, nonatomic) NSObject *baseData;
@property (strong, nonatomic) NSObject *toSaveData;

@property (strong, nonatomic) NSSet *numberKeyBoardTypeSet;
@property (strong, nonatomic) NSSet *selectorSet;

- (void)setupNav;
- (void)goBack;
- (void)saveButtonAction;
- (void)initializeData;
- (void)pullDetailData;
- (void)pushUpdateData;
- (void)saveDataSuccess;

@end
