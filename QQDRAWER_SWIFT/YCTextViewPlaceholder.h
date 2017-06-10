//
//  UITextViewPlaceholder.h
//  carlive
//
//  Created by CY on 15/4/29.
//  Copyright (c) 2015年 LINYC. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface YCTextViewPlaceholder : UITextView<UITextViewDelegate>
@property (nonatomic,copy) IBInspectable NSString *placeholder;
@property (nonatomic,assign) BOOL hidePlaceholderView;
@end
