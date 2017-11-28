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
@property (strong, nonatomic) NSObject *detailData;
@property (strong, nonatomic) NSObject *toSaveData;

@property (strong, nonatomic) NSMutableSet *numberKeyBoardTypeSet;
@property (strong, nonatomic) NSMutableSet *selectorSet;

- (void)setupNav;
- (void)saveButtonAction;
- (void)initializeData;
- (void)pullDetailData;
- (void)pushUpdateData;
- (void)saveDataSuccess;
- (void)pullDataDictionaryFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath;
- (void)pullCityArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath;

@end
