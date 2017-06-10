//
//  JSONModel.h
//  HeWeather
//
//  Created by 樊树康 on 2016/12/10.
//  Copyright © 2016年 懒懒的猫鼬鼠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>



@interface CityModel : JSONModel

@property NSString * aqi;
@property NSString <Optional>* co;
@property NSString <Optional>* no2;
@property NSString <Optional>* o3;
@property NSString * pm10;
@property NSString * pm25;
@property NSString * qlty;
@property NSString <Optional>* so2;

@end


@interface AqiModel : JSONModel

@property CityModel * city;

@end


@interface UpdateModel : JSONModel

@property NSString * loc;
@property NSString * utc;

@end


@interface BasicModel : JSONModel

@property NSString * city;
@property NSString * cnty;
@property NSString  * id;
@property NSString * lat;
@property NSString * lon;
@property UpdateModel * update;

@end


@interface AstroModel : JSONModel

@property NSString * mr;
@property NSString * ms;
@property NSString * sr;
@property NSString * ss;

@end


@interface CondModel : JSONModel

@property NSString * code_d;
@property NSString * code_n;
@property NSString * txt_d;
@property NSString * txt_n;
@end


@interface TmpModel : JSONModel

@property NSString * max;
@property NSString * min;

@end

@interface WindModel : JSONModel

@property NSString * deg;
@property NSString * dir;
@property NSString * sc;
@property NSString * spd;

@end

@protocol DailyModel;
@interface DailyModel : JSONModel

@property AstroModel * astro;
@property CondModel * cond;
@property NSString * date;
@property NSString * hum;
@property NSString * pcpn;
@property NSString * pop;
@property NSString * pres;
@property TmpModel * tmp;
@property NSString * uv;
@property NSString * vis;
@property WindModel * wind;

@end


@interface HcondModel : JSONModel

@property NSString * code;
@property NSString * txt;

@end

@protocol HourlyModel;
@interface HourlyModel : JSONModel

@property HcondModel * cond;
@property NSString * date;
@property NSString * hum;
@property NSString * pop;
@property NSString * pres;
@property NSString * tmp;
@property WindModel * wind;

@end


@interface NowModel : JSONModel

@property HcondModel * cond;
@property NSString * fl;
@property NSString * hum;
@property NSString * pcpn;
@property NSString * pres;
@property NSString * tmp;
@property NSString * vis;
@property WindModel * wind;

@end

@interface  AirModel : JSONModel

@property NSString * brf;
@property NSString * txt;

@end

@interface  SuggestModel : JSONModel

@property AirModel <Optional> * air;
@property AirModel * comf;
@property AirModel * cw;
@property AirModel * drsg;
@property AirModel * flu;
@property AirModel * sport;
@property AirModel * trav;
@property AirModel * uv;

@end

@protocol HeWeatherModel;

@interface HeWeatherModel : JSONModel

@property AqiModel <Optional> * aqi;
@property BasicModel *basic;
@property NSMutableArray <DailyModel>* daily_forecast;
@property NSMutableArray <HourlyModel>* hourly_forecast;
@property NowModel * now;
@property NSString * status;
@property SuggestModel * suggestion;

@end


@interface Model : JSONModel
@property NSMutableArray <HeWeatherModel> * HeWeather5;

@end

















