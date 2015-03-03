//
//  TYPEID_Model.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "Do_Label_UIModel.h"
#import "doProperty.h"

@implementation Do_Label_UIModel

#pragma mark - 注册属性（--属性定义--）
/*
[self RegistProperty:[[doProperty alloc]init:@"属性名" :属性类型 :@"默认值" : BOOL:是否支持代码修改属性]];
 */
-(void)OnInit
{
    [super OnInit];
    //属性声明
    
    //text:获取或设置与此控件关联的文本
    //fontColor:前景色
    //fontSize:字体大小
    //fontStyle:字体风格
    //textAlign:字体对齐方式
    //autoSize:是否根据内容，自适应大小
    //maxWidth:最大的宽度
    //maxHeight:最大高度
    //maxLines:最多显示的行数
    
    [self RegistProperty:[[doProperty alloc] init:@"text" : String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"fontColor" : String :@"000000FF" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"fontSize" : Number :@"9" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"fontStyle" : String :@"normal" :NO]];
    
    [self RegistProperty:[[doProperty alloc] init:@"textAlign" : String :@"left" :YES]];
    [self RegistProperty:[[doProperty alloc] init:@"maxWidth" : Number :@"0" :YES]];
    [self RegistProperty:[[doProperty alloc] init:@"maxHeight" : Number :@"0" :YES]];
    [self RegistProperty:[[doProperty alloc] init:@"maxLines" :Number :@"3" :YES]];
}

@end
