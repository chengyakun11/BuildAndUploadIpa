//
//  LanSearchCell.m
//  BuildAndUploadIpa
//
//  Created by chengyakun11 on 2016/10/24.
//  Copyright © 2016年 fudianshu. All rights reserved.
//

#import "LanSearchCell.h"


@implementation LanSearchCell

-(void)layoutWithNewDevice:(TargetsInfoModel *)model
{
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    _checkButton = [[NSButton alloc]initWithFrame:NSMakeRect(10, 30, 40, 20)];
    [_checkButton setButtonType:NSButtonTypeSwitch];
    _checkButton.state = NSOnState;
    [_checkButton setTitle:@""];
    [_checkButton setBezelStyle:0];
    [self addSubview:_checkButton];
    
    //layout bottom -> top
    //channelDvr
    self.channelDvrText = [[NSTextField alloc]initWithFrame:NSMakeRect(_checkButton.frame.origin.x+_checkButton.frame.size.width, 0, 500-_checkButton.frame.origin.x-_checkButton.frame.size.width, 40)];
    [self.channelDvrText setFont:[NSFont systemFontOfSize:14]];
    [self.channelDvrText setBackgroundColor:[NSColor clearColor]];
    [self.channelDvrText setAlignment:NSTextAlignmentLeft];
    [self.channelDvrText setAutoresizesSubviews:YES];
    [self.channelDvrText setEditable:NO];
    [self.channelDvrText setSelectable:NO];
    [self.channelDvrText setStringValue:[NSString stringWithFormat:@"version:%@  build:%@  mobileprovision:%@",model.cfbundleShortVersionString,model.cfbundleVersion,model.mobileprovisionPath]];
    [self.channelDvrText setBezeled:NO];
    [self.channelDvrText setTextColor:[NSColor grayColor]];
    [self addSubview:self.channelDvrText];
    
    //newdevice
    self.newdeviceText = [[NSTextField alloc]initWithFrame:NSMakeRect(_checkButton.frame.origin.x+_checkButton.frame.size.width, 40,500-_checkButton.frame.origin.x-_checkButton.frame.size.width, 40)];
    [self.newdeviceText setFont:[NSFont systemFontOfSize:15.0f]];
    [self.newdeviceText setBackgroundColor:[NSColor clearColor]];
    [self.newdeviceText setAlignment:NSTextAlignmentLeft];
    [self.newdeviceText setAutoresizesSubviews:YES];
    [self.newdeviceText setEditable:NO];
    [self.newdeviceText setSelectable:NO];
    [self.newdeviceText setStringValue:[NSString stringWithFormat:@"%@  %@",model.cfbundleDisplayName,model.schemesName]];
    [self.newdeviceText setBezeled:NO];
    [self addSubview:self.newdeviceText];
    
    
    //打包
    _packageBtn = [[NSButton alloc]initWithFrame:NSMakeRect(self.channelDvrText.frame.origin.x+self.channelDvrText.frame.size.width+10, 45, 80, 30)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    NSMutableAttributedString *attrTitle = nil;
    if(model.isPackFlag ==YES){
        attrTitle = [[NSMutableAttributedString alloc] initWithString:@"已经打包(点击重新打包)"];
    }else{
        attrTitle = [[NSMutableAttributedString alloc] initWithString:@"打包"];
    }
    NSRange range = NSMakeRange(0, [attrTitle length]);
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:range];
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [attrTitle fixAttributesInRange:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:15.0] range:range];
    [self.packageBtn setAttributedTitle:attrTitle];
    [self addSubview:self.packageBtn];
    //上传
    _uploadBtn = [[NSButton alloc]initWithFrame:NSMakeRect(self.packageBtn.frame.origin.x,5, 80, 30)];
    NSMutableParagraphStyle *uploadStyle = [[NSMutableParagraphStyle alloc] init];
    [uploadStyle setAlignment:NSTextAlignmentCenter];
    NSMutableAttributedString *uploadAttrTitle = [[NSMutableAttributedString alloc] initWithString:@"上传"];
    NSRange uploadRange = NSMakeRange(0, [uploadAttrTitle length]);
    [uploadAttrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:uploadRange];
    [uploadAttrTitle addAttribute:NSParagraphStyleAttributeName value:uploadStyle range:uploadRange];
    [uploadAttrTitle fixAttributesInRange:uploadRange];
    [uploadAttrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:15.0] range:uploadRange];
    [self.uploadBtn setAttributedTitle:uploadAttrTitle];
    [self addSubview:self.uploadBtn];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
