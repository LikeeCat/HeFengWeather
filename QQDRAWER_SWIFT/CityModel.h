//
//  CityModel.h
//  和风天气
//
//  Created by 樊树康 on 17/3/13.
//  Copyright © 2017年 BlackSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
@protocol  CitylistModel;
@interface CitylistModel : JSONModel

@property NSString * id ;
@property NSString * cityEn;
@property NSString * cityZh;
@property NSString * countryCode;
@property NSString * countryEn;
@property NSString * countryZh;
@property NSString * provinceEn;
@property NSString * provinceZh;
@property NSString * leaderEn;
@property NSString * leaderZh;
@property NSString * lat;
@property NSString * lon;

@end



@interface AllCityModel : JSONModel
@property NSMutableArray <CitylistModel> * cityList;
@end
