//
//  TYPEID_View.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "Do_Label_UIView.h"

#import "doInvokeResult.h"
#import "doUIModuleHelper.h"
#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"

@implementation Do_Label_View
{
    NSString *_myFontStyle;
}

#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象
- (void) LoadView: (doUIModule *) _doUIModule
{
    _model = (typeof(_model)) _doUIModule;
    self.numberOfLines = [[_model GetProperty:@"maxLines"].DefaultValue intValue];
    self.textColor = [UIColor blackColor];
}
//销毁所有的全局对象
- (void) OnDispose
{
    _model = nil;
    //自定义的全局属性
}
//实现布局
- (void) OnRedraw
{
    //实现布局相关的修改
    
    //重新调整视图的x,y,w,h
    [doUIModuleHelper OnRedraw:_model];
}

#pragma mark - TYPEID_IView协议方法（必须）
#pragma mark - Changed_属性
/*
 如果在Model及父类中注册过 "属性"，可用这种方法获取
 NSString *属性名 = [(doUIModule *)_model GetPropertyValue:@"属性名"];
 
 获取属性最初的默认值
 NSString *属性名 = [(doUIModule *)_model GetProperty:@"属性名"].DefaultValue;
 */
- (void)change_text:(NSString *)text
{
    [self setText:text];
    if(_myFontStyle)
        [self change_fontStyle:_myFontStyle];
    [self myAutoSize];
}
- (void)change_fontColor:(NSString *)fontColor
{
    UIColor *color = [doUIModuleHelper GetColorFromString:fontColor :[UIColor blackColor]];
    [self setTextColor:color];
}
- (void)change_fontStyle:(NSString *)fontStyle
{
    _myFontStyle = [NSString stringWithFormat:@"%@",fontStyle];
    NSRange range = {0,[self.text length]};
    NSMutableAttributedString *str = [self.attributedText mutableCopy];
    [str removeAttribute:NSUnderlineStyleAttributeName range:range];
    self.attributedText = str;
    
    NSInteger size = [[_model GetPropertyValue:@"fontSize"] intValue];
    if(size <= 0)
        size = [[_model GetProperty:@"fontSize"].DefaultValue intValue];
    if([fontStyle isEqualToString:@"normal"])
        [self setFont:[UIFont systemFontOfSize:size]];
    else if([fontStyle isEqualToString:@"bold"])
        [self setFont:[UIFont boldSystemFontOfSize:size]];
    else if([fontStyle isEqualToString:@"italic"])
        [self setFont:[UIFont italicSystemFontOfSize:size]];
    else if([fontStyle isEqualToString:@"underline"])
    {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:self.text];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        self.attributedText = content;
    }
}
- (void)change_fontSize:(NSString *)fontSize
{
    UIFont *font = self.font;
    if(!font)
        font = [UIFont systemFontOfSize:[[_model GetProperty:@"fontSize"].DefaultValue intValue]];
    font = [font fontWithSize:[fontSize intValue]];
    self.font = font;
    [self myAutoSize];
}
- (void)change_textAlign:(NSString *)textAlign
{
    if([textAlign isEqualToString:@"left"])
        [self setTextAlignment:NSTextAlignmentLeft];
    else if([textAlign isEqualToString:@"center"])
        [self setTextAlignment:NSTextAlignmentCenter];
    else if([textAlign isEqualToString:@"right"])
        [self setTextAlignment:NSTextAlignmentRight];
}
- (void)change_maxWidth:(NSString *)maxWidth
{
    if([maxWidth floatValue] > 0)
    {
        CGSize size = [self autoSize:CGFLOAT_MAX :_model.RealHeight];
        CGFloat w;
        if([maxWidth floatValue] >= size.width)
            w = size.width;
        else
            w = [maxWidth floatValue];
        [_model SetPropertyValue:@"width" :[NSString stringWithFormat:@"%f",w/_model.XZoom]];
        [self OnRedraw];
    }
}
- (void)change_maxHeight:(NSString *)maxHeight
{
    if([maxHeight floatValue] > 0)
    {
        CGSize size = [self autoSize:_model.RealWidth :CGFLOAT_MAX];
        CGFloat h;
        if([maxHeight floatValue] >= size.height)
            h = size.height;
        else
            h = [maxHeight floatValue];
        [_model SetPropertyValue:@"height" :[NSString stringWithFormat:@"%f",h/_model.YZoom]];
        [self OnRedraw];
    }
}
- (void)change_maxLines:(NSString *)maxLines
{
    NSInteger number = [maxLines integerValue];
    if(number < 0)
        number = [[_model GetProperty:@"maxLines"].DefaultValue intValue];
    self.numberOfLines = number;
    [self myAutoSize];
}

#pragma mark - private
- (void)myAutoSize
{
    [self change_maxWidth:[_model GetPropertyValue:@"maxWidth"]];
    [self change_maxHeight:[_model GetPropertyValue:@"maxHeight"]];
}

- (CGSize)autoSize:(CGFloat)wight :(CGFloat)height
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
    CGSize mySize = [self.text boundingRectWithSize:CGSizeMake(wight, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return mySize;
}

#pragma mark - doIUIModuleView协议方法（必须）<大部分情况不需修改>
- (BOOL) OnPropertiesChanging: (NSMutableDictionary *) _changedValues
{
    //属性改变时,返回NO，将不会执行Changed方法
    return YES;
}
- (void) OnPropertiesChanged: (NSMutableDictionary*) _changedValues
{
    //_model的属性进行修改，同时调用self的对应的属性方法，修改视图
    [doUIModuleHelper HandleViewProperChanged: self :_model : _changedValues ];
}
- (BOOL) InvokeSyncMethod: (NSString *) _methodName : (doJsonNode *)_dicParas :(id<doIScriptEngine>)_scriptEngine : (doInvokeResult *) _invokeResult
{
    //同步消息
    return [doScriptEngineHelper InvokeSyncSelector:self : _methodName :_dicParas :_scriptEngine :_invokeResult];
}
- (BOOL) InvokeAsyncMethod: (NSString *) _methodName : (doJsonNode *) _dicParas :(id<doIScriptEngine>) _scriptEngine : (NSString *) _callbackFuncName
{
    //异步消息
    return [doScriptEngineHelper InvokeASyncSelector:self : _methodName :_dicParas :_scriptEngine: _callbackFuncName];
}
- (doUIModule *) GetModel
{
    //获取model对象
    return _model;
}

@end
