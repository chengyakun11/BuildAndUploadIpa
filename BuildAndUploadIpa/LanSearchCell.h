//
//  LanSearchCell.h
//  BuildAndUploadIpa
//
//  Created by chengyakun11 on 2016/10/24.
//  Copyright © 2016年 fudianshu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TargetsInfoModel.h"

@interface LanSearchCell : NSTableCellView

@property (strong) NSTextField *newdeviceText;
@property (strong) NSTextField *channelDvrText;

@property (strong) NSButton *checkButton;
@property (strong) NSButton *packageBtn;
@property (strong) NSButton *uploadBtn;

-(void)layoutWithNewDevice:(TargetsInfoModel *)model;

@end
