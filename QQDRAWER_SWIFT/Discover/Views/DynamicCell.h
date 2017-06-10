//
//  DynamicCell.h
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "和风天气-Swift.h"

#define nameColor       RGBColor(50, 85, 140, 1.0)  //名字颜色
#define customGrayColor RGBColor(175, 180, 200, 1.0)  //灰色
#define kFaceWidth      45   //头像视图的宽、高
#define kOptionHeight   30   //操作视图的高度
#define kPadding        10  //视图之间的间距

@class Dynamic;
@interface DynamicCell : UITableViewCell
/** 朋友圈信息实体 */
@property (nonatomic, retain) UILabel       *praiseLabel;
@property (nonatomic, retain) UILabel       *nameLabel;

@property (nonatomic,strong)   DiscoverTable      *dynamic;
@property (nonatomic,strong) NSIndexPath * index;
+ (DynamicCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath*) indexPath selected:(BOOL)selected;

+ (CGFloat)heightOfCellWithModel:(DiscoverTable *)dynamic;

@end
