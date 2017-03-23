//
//  TargetsInfoModel.h
//  BuildAndUploadIpa
//
//  Created by chengyakun11 on 2016/10/26.
//  Copyright © 2016年 fudianshu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetsInfoModel : NSObject


@property(nonatomic,copy) NSString  *cfbundleDisplayName;
@property(nonatomic,copy) NSString  *schemesName;
@property(nonatomic,copy) NSString  *cfbundleShortVersionString;//版本号
@property(nonatomic,copy) NSString  *cfbundleVersion;//build
@property(nonatomic,assign) BOOL  isPackFlag;//是不是已经打包

@property(nonatomic,copy) NSString *mobileprovisionPath;
@property(nonatomic,copy) NSString *mobileprovisionRealName;

@property(nonatomic,copy) NSString *ipaPath;


@end
