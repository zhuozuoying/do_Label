//
//  TYPEID_View.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoExt_Label_IView.h"
#import "DoExt_Label_UIModel.h"
#import "doIUIModuleView.h"

@interface DoExt_Label_View : UILabel<DoExt_Label_IView,doIUIModuleView>
//可根据具体实现替换UIView
{
    @private
    __weak DoExt_Label_UIModel *_model;
}

@end
