//
//  Utils.m
//  AppFinance
//
//  Created by wei on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AFUtils.h"

#import <CommonCrypto/CommonDigest.h>

static int _currentResolution = -1;
static NSMutableDictionary *muDicHeightData = nil;

@implementation AFUtils

////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 时间

+ (NSString *) unixTime:(NSString*) unixTime format:(NSString*) format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [unixTime longLongValue]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC+8"]];
    return [dateFormatter stringFromDate:date];
}


+ (NSString *) unixTime:(NSString*) unixTime{
    
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //NSDate *date = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [unixTime intValue]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    //NSInteger year = [dateComponents year];
    //NSInteger month = [dateComponents month];
    //NSInteger day = [dateComponents day];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    
    NSString *h = nil;
    NSString *m = nil;
    if (hour < 10) {
        h = [NSString stringWithFormat:@"0%i",(int)hour];
    } else {
        h = [NSString stringWithFormat:@"%i",(int)hour];
    }
    
    if (minute < 10) {
        m = [NSString stringWithFormat:@"0%i",(int)minute];
    } else {
        m = [NSString stringWithFormat:@"%i",(int)minute];
    }
    
    return [NSString stringWithFormat:@"%@:%@",h,m];
}



/**
 *  GetWeekForDate
 *  根据日期获取星期
 *
 *  @param NSString   strDate 日期(yyyy-MM-dd)
 *  @param NSInteger  type 类型(0 星期x 1 周x)
 *
 *  @return NSString / empty
 */
+ (NSString *) GetWeekForDate:(NSString *) strDate withType:(NSInteger)type{
    
    if (![strDate isEqualToString:@""]) {

        NSString *strPrefix = type == 1?@"周":@"星期";

        //时间格式化
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        //获取对应时间
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *cdate = [formatter dateFromString:strDate];
        
        //获取时间信息
        [formatter setDateFormat:@"yyyy-MM-dd EEEE HH:mm:ss a"];
        NSString *locationString=[formatter stringFromDate: cdate];
        
        NSArray *arrDate = [locationString componentsSeparatedByString:@" "];
        NSString *strWeek = [NSString stringWithFormat:@"%@",[arrDate objectAtIndex:1]];


        if ([strWeek isEqualToString:@"Sunday"])        return [NSString stringWithFormat:@"%@%@",strPrefix,@"日"];
        else if ([strWeek isEqualToString:@"Monday"])   return [NSString stringWithFormat:@"%@%@",strPrefix,@"一"];
        else if ([strWeek isEqualToString:@"Tuesday"])  return [NSString stringWithFormat:@"%@%@",strPrefix,@"二"];
        else if ([strWeek isEqualToString:@"Wednesday"])return [NSString stringWithFormat:@"%@%@",strPrefix,@"三"];
        else if ([strWeek isEqualToString:@"Thursday"]) return [NSString stringWithFormat:@"%@%@",strPrefix,@"四"];
        else if ([strWeek isEqualToString:@"Friday"])   return [NSString stringWithFormat:@"%@%@",strPrefix,@"五"];
        else if ([strWeek isEqualToString:@"Saturday"]) return [NSString stringWithFormat:@"%@%@",strPrefix,@"六"];
        else {
            if (type == 1) {
                strPrefix = [NSString stringWithFormat:@"%@%@",strPrefix,strWeek];
                strPrefix = [strPrefix stringByReplacingOccurrencesOfString:@"星期" withString:@""];

                return strPrefix;
            }
            else
               return [NSString stringWithFormat:@"%@%@",strPrefix,strWeek];
        }
    }
    else return @"";
}


/**
 *  GetMonthForDate
 *  根据日期获取月份
 *
 *  @param NSString   strDate 日期(yyyy-MM-dd)
 *  @param NSInteger  type 类型(1 五月 2 May)
 *
 *  @return NSString / empty
 */
+ (NSString *) GetMonthForDate:(NSString *) strDate withType:(NSInteger)type{

    if (![strDate isEqualToString:@""]) {

        NSString *strinfo = nil;

        //时间格式化
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        //获取对应时间
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *cdate = [formatter dateFromString:strDate];

        //获取时间信息
        [formatter setDateFormat:@"M"];
        strinfo = [formatter stringFromDate:cdate];

        switch ([strinfo integerValue]) {
            case 1:
                return [NSString stringWithFormat:@"%@",type == 1?@"一月":@"Jan"];
            case 2:
                return [NSString stringWithFormat:@"%@",type == 1?@"二月":@"Feb"];
            case 3:
                return [NSString stringWithFormat:@"%@",type == 1?@"三月":@"Mar"];
            case 4:
                return [NSString stringWithFormat:@"%@",type == 1?@"四月":@"Apr"];
            case 5:
                return [NSString stringWithFormat:@"%@",type == 1?@"五月":@"May"];
            case 6:
                return [NSString stringWithFormat:@"%@",type == 1?@"六月":@"Jun"];
            case 7:
                return [NSString stringWithFormat:@"%@",type == 1?@"七月":@"Jul"];
            case 8:
                return [NSString stringWithFormat:@"%@",type == 1?@"八月":@"Aug"];
            case 9:
                return [NSString stringWithFormat:@"%@",type == 1?@"九月":@"Sep"];
            case 10:
                return [NSString stringWithFormat:@"%@",type == 1?@"十月":@"Oct"];
            case 11:
                return [NSString stringWithFormat:@"%@",type == 1?@"十一月":@"Nov"];
            case 12:
                return [NSString stringWithFormat:@"%@",type == 1?@"十二月":@"Dec"];
            default:
                return strinfo;
        }
    }
    else return @"";
}




+ (int) unixTimeMinute:(NSString*) unixTime{
    
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //NSDate *date = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [unixTime intValue]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    //NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    return (int)minute;
}

+ (NSString *) unixTimeHand:(NSString*) unixTime{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [unixTime intValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) unixTimePoint:(NSString*) unixTime{
    
    //NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //NSDate *date = [NSDate date];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [unixTime intValue]];
    
    /*NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    //NSInteger hour = [dateComponents hour];
    //NSInteger minute = [dateComponents minute];
    //NSInteger second = [dateComponents second];
    */
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyMMdd"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //return [NSString stringWithFormat:@"%i%i%i",year,month,day];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) unixTimePointMin:(NSString*) unixTime{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [unixTime intValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 日时分
    [dateFormatter setDateFormat:@"ddHHmm"];
    //return [NSString stringWithFormat:@"%i%i%i",year,month,day];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) unixTimePointYYYYMMDDHHMM:(NSString*) unixTime{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [unixTime longLongValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 日时分
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC+8"]];

    return [dateFormatter stringFromDate:date];
}

+ (NSString*) stringToDate:(NSString *)_time withFormat:(NSString *)format{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

   [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *date = [formatter dateFromString:_time];

    [formatter setDateFormat:format];

    return [formatter stringFromDate:date];
}


+ (NSString*) stringToDate:(NSString *)_time{
    
    //Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec 
    //_time = [_time stringByReplacingOccurrencesOfString:@"+0800" withString:@"+0000"];
    if ([_time rangeOfString:@"Jan"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Jan" withString:@"01"];
    } else if ([_time rangeOfString:@"Feb"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Feb" withString:@"02"];
    } else if ([_time rangeOfString:@"Mar"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Mar" withString:@"03"];
    } else if ([_time rangeOfString:@"Apr"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Apr" withString:@"04"];
    } else if ([_time rangeOfString:@"May"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"May" withString:@"05"];
    } else if ([_time rangeOfString:@"Jun"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Jun" withString:@"06"];
    } else if ([_time rangeOfString:@"Jul"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Jul" withString:@"07"];
    } else if ([_time rangeOfString:@"Aug"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Aug" withString:@"08"];
    } else if ([_time rangeOfString:@"Sep"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Sep" withString:@"09"];
    } else if ([_time rangeOfString:@"Oct"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Oct" withString:@"10"];
    } else if ([_time rangeOfString:@"Nov"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Nov" withString:@"11"];
    } else if ([_time rangeOfString:@"Dec"].length > 0) {
        _time = [_time stringByReplacingOccurrencesOfString:@"Dec" withString:@"12"];
    }

    // ios 手机上 格式化 有 字符串的(如：Wed、May) 日期失败
    //Wed, 20 Jun 2012 21:53:33 +0800
    // 去掉 星期
    _time = [_time substringFromIndex:5];
    // NSLog(@"  _time 2 = %@",_time);
    
    //NSString *time = @"Sat, 26 May 2012 08:26:00 +0800";
    
    NSDateFormatter* df = nil;
    df = [[NSDateFormatter alloc] init];
    //[df setTimeStyle:NSDateFormatterFullStyle];
    //[df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"d LL yyyy HH:mm:ss Z"];
    //[df setDateFormat:@"EEE, d LLL Y H:m:s Z"];
    
    NSDate *convertedDate = [df dateFromString:_time];     
    /*
    NSLog(@"  NSdate = %@",convertedDate);
    NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
    //[df3 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    //NSLog(@"DATE FORMAT:%@", [df3 dateFromString:@"2008-12-29T00:27:42-0800"]);
    [df3 setDateFormat:@"EEE, d LL yyyy HH:mm:ss"];
    NSLog(@"DATE FORMAT 3: %@", [df3 dateFromString:@"Wed, 20 06 2012 23:08:00"]);
    */
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:convertedDate];
}


+(int)nowMinute{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //NSDate *date = [NSDate date];
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    NSInteger minute = [dateComponents minute];
    
    return minute;
}

+(NSString *)nowDataChangeMinToUnixTime:(int)_min{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //NSDate *date = [NSDate date];
    NSDate *date = [NSDate date];
    NSLog(@" date 1 = %@",date);
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    //NSInteger minute = [dateComponents minute];
    [dateComponents setMinute:_min];
    
    NSDate *_date2 = [dateComponents date];
    NSLog(@" date 2 = %@",date);
    double _doubleDate = [_date2 timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", _doubleDate];
}

+ (NSString *) dateStringAForNow{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    // 小写的"hh"，那么时间将会跟着系统设置变成12小时或者24小时制。大写的"HH"，则强制为24小时制
    [df setDateFormat:@"MM-dd HH:mm"];
    return [df stringFromDate:date];
}

+(long long int)localUnixTime{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int unixTime = (long long int)time;
    return unixTime;
}

// 2015-01-19 18:01:02  YYYY-MM-dd HH:mm:ss
// 2015/1/19 18:01:02  YYYY/MM/dd HH:mm:ss
+ (NSString *) dateStringNowForFormat:(NSString*)_format{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    // 小写的"hh"，那么时间将会跟着系统设置变成12小时或者24小时制。大写的"HH"，则强制为24小时制
    [df setDateFormat:_format];
    return [df stringFromDate:date];
}

+ (NSString *) unixTimeForNow:(NSString *)_strUnixTime formate:(NSString *)_formateString{

    NSString *strNewTime;
    int _spaceTime = (int)[AFUtils localUnixTime] - [_strUnixTime intValue];
    if(_spaceTime <= 60)
        strNewTime = @"1分钟内";
    else if(_spaceTime <= 60 * 60){
        _spaceTime = _spaceTime / 60 ;

        strNewTime = [NSString stringWithFormat:@"%d分钟前",_spaceTime];
    }
    else if(_spaceTime <= 60 * 60 * 24){
        _spaceTime = _spaceTime  / ( 60 * 60);
        strNewTime  = [NSString stringWithFormat:@"%d小时前",_spaceTime];
    }
    else
        strNewTime = [AFUtils unixTime:_strUnixTime format:_formateString];

    return strNewTime;
}

/**
 *  GetWeekForDate
 *  根据日期获取星期
 *
 *  @param NSString strDate 日期(yyyy-MM-dd)
 *
 *  @return NSString / empty
 */
+(NSString*) getWeekForDate:(NSString *) strDate{

    if (![strDate isEqualToString:@""]) {

        //时间格式化
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        //获取对应时间
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *cdate = [formatter dateFromString:strDate];

        //获取时间信息
        [formatter setDateFormat:@"yyyy-MM-dd EEEE HH:mm:ss a"];
        NSString *locationString=[formatter stringFromDate: cdate];

        NSArray *arrDate = [locationString componentsSeparatedByString:@" "];
        NSString *strWeek = [NSString stringWithFormat:@"%@",[arrDate objectAtIndex:1]];

        if ([strWeek isEqualToString:@"Sunday"])        return @"星期日";
        else if ([strWeek isEqualToString:@"Monday"])   return @"星期一";
        else if ([strWeek isEqualToString:@"Tuesday"])  return @"星期二";
        else if ([strWeek isEqualToString:@"Wednesday"])return @"星期三";
        else if ([strWeek isEqualToString:@"Thursday"]) return @"星期四";
        else if ([strWeek isEqualToString:@"Friday"])   return @"星期五";
        else if ([strWeek isEqualToString:@"Saturday"]) return @"星期六";
        else return strWeek;
    }
    else return @"";
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIDevice
////////////////////////////////////////////////////////////////////////////////
+ (UIDeviceResolution) currentResolution {
    
    if (_currentResolution > 0) {
        return _currentResolution;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            //NSLog(@" [[UIScreen mainScreen] respondsToSelector: @selector(scale)]  == YES");
            
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            
            if (result.height == 480) {
                _currentResolution = UIDevice_iPhone3;
            } else if(result.height == 960 ){
                _currentResolution = UIDevice_iPhone4;
            } else {
                _currentResolution = UIDevice_iPhone5;
            }
        } else{
            _currentResolution = UIDevice_iPhone3;
        }
    } else{
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            _currentResolution = UIDevice_iPad3;
        } else {
            _currentResolution = UIDevice_iPad2;
        }
    }
    
    return _currentResolution;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - MD5
////////////////////////////////////////////////////////////////////////////////
+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}




// -------- test ---------
// "yyyy-MM-dd hh:mm:ss" //12小时制
// "yyyy-MM-dd HH:mm:ss" //24小时制
-(void)test{
    
    // 获取 unix time
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date4 = (long long int)time;
    NSLog(@" date4 = %lld", date4);
    
    
    NSDate *date = [NSDate date];
    NSLog(@" date 1 = %@", date); // 直接打印 为 GTM + 0 时间
    
    // date to string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *lodate = [dateFormatter stringFromDate:date];  // 格式化之后为 本地时间
    NSLog(@" localDate 2 = %@", lodate);
    
    // string to date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *new_date = [formatter dateFromString:lodate];
    NSLog(@" new_date = %@", new_date);
    
    
    
     NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
     //        NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];//这是用来输出时区名称的
     //        for (int i = 0; i < [timeZoneNames count]; i++) {
     //            NSLog(@" timeZoneNames i = %@", [timeZoneNames objectAtIndex:i]);
     //        }
     //        NSLog(@"timeZoneNames is %@", timeZoneNames);
     NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//中国时间
     [calendar setTimeZone:timeZone];
    
     NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
     NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
     
     int hour = [dateComponents hour];
    
     NSLog(@" hour = %i", hour);
}

////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 颜色

// 这里的 RGB 为 【mac 软件 数码测试计】显示的原生值
+ (UIColor *) UIColorFromRed:(float) red green:(float) green blue:(float) blue  {
    float r = red/255.0;
    float g = green/255.0 ;
    float b = blue/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (UIColor *) UIColorFromRGB:(int) rgbValue alpha:(float) alphaValue {
    float r = ((float)((rgbValue & 0xFF0000) >> 16))/255.0;
    float g = ((float)((rgbValue & 0xFF00) >> 8))/255.0 ;
    float b = ((float)(rgbValue & 0xFF))/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:alphaValue];
}


////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 消息弹框
+ (void) alertMessage:(NSString *) inmsg{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:inmsg
                                                       delegate:nil
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

+(void)alertMessageNoButton:(NSString *) inmsg{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:inmsg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
   
   [self performSelector:@selector(dimissAlert:) withObject:alertView afterDelay:0.8];
}



+(void)dimissAlert:(UIAlertView * )alertView{
    if(alertView){

    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
    }
}



////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 宽度、高度计算
+(float)uiLabelHeight:(NSString*)_text withSize:(CGFloat) _size andWidth:(CGFloat) _width{

    //已计算的高度存起来，防止重复计算
    NSString *strKet = [NSString stringWithFormat:@"%@%f",_text,_size];

    muDicHeightData = muDicHeightData?muDicHeightData:[NSMutableDictionary dictionary];
    if ([[muDicHeightData allKeys] containsObject:strKet])
        return [muDicHeightData[strKet] floatValue];

    UIFont *font = [UIFont systemFontOfSize:_size];
    CGSize size = [_text sizeWithFont:font constrainedToSize:CGSizeMake(_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    float _h = size.height;

    [muDicHeightData setValue:[NSString stringWithFormat:@"%f",_h + 2] forKey:strKet];

    font = nil;
    strKet = nil;
    return _h + 2; // 现象:iPod5 iPhone4 等设备 需要多 + 2 个像素，不然会少显示一行, 原因暂时不清楚
}


+(float)get_width_for_string:(NSString*)title withSize:(CGFloat) size andWidth:(CGFloat) width{
    UIFont *font = [UIFont systemFontOfSize:size];
    CGSize cgsize = [title sizeWithFont:font constrainedToSize:CGSizeMake(width, 20) lineBreakMode:NSLineBreakByWordWrapping];
    float _w = cgsize.width;
    return _w;
}

+(float)uiLableRichTextHeight:(NSString *)_strContent Width:(CGFloat)_width{

    if ([_strContent isEqualToString:@""]) return 0.f;

    //已计算的高度存起来，防止重复计算
    muDicHeightData = muDicHeightData?muDicHeightData:[NSMutableDictionary dictionary];
    if ([[muDicHeightData allKeys] containsObject:_strContent])
        return [muDicHeightData[_strContent] floatValue];

    NSAttributedString *atrrString = [[NSAttributedString alloc] initWithData:[_strContent dataUsingEncoding:NSUnicodeStringEncoding]
                                                                      options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                           documentAttributes:nil
                                                                        error:nil];
    
    CGRect rectContent = [atrrString boundingRectWithSize:CGSizeMake(_width,CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  context:nil];

    atrrString = nil;
    float h = ceilf(rectContent.size.height);
    [muDicHeightData setValue:[NSString stringWithFormat:@"%f",h] forKey:_strContent];

    return h;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 缓存处理
////////////////////////////////////////////////////////////////////////////////

//根据路径返回目录或文件的大小
+ (double)sizeWithFilePath:(NSString *)path{
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];

    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];

    if (!exits) return 0;

    // 3.判断是否为文件夹
    if (dir) {
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [manger subpathsAtPath:path];

        BOOL dir = NO;
        int totalSize = 0;
        NSDictionary *attrs;
        NSString *fullsubpath;

        for (NSString *subpath in subpaths) {
            fullsubpath = [path stringByAppendingPathComponent:subpath];

            [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                attrs = [manger attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }

        return totalSize / (1024 * 1024.0);
    }
    // 文件
    else {
        NSDictionary *attrs = [manger attributesOfItemAtPath:path error:nil];

        return [attrs[NSFileSize] intValue] / (1024.0 * 1024.0);
    }
}

// 得到指定目录下的所有文件
+ (NSArray *)getAllFileNames:(NSString *)dirPath{
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath error:nil];
    return files;
}

// 删除指定目录或文件
+ (BOOL)clearCachesWithFilePath:(NSString *)path{
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    NSError * error;
    BOOL isclear = YES;
    if([mgr fileExistsAtPath:path]){
        isclear =  [mgr removeItemAtPath:path error:&error];
    }
    return isclear;
}

// 清空指定目录下文件
+ (BOOL)clearCachesFromDirectoryPath:(NSString *)dirPath{
    //获得全部文件数组
    NSArray *fileAry =  [AFUtils getAllFileNames:dirPath];

    //遍历数组
    BOOL flag = NO;

    for (NSString *fileName in fileAry) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        flag = [AFUtils clearCachesWithFilePath:filePath];

        if (!flag)
            break;
    }

    return flag;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 获取保存位数
////////////////////////////////////////////////////////////////////////////////
+ (NSInteger)getDecimal:(NSDictionary *)_dicData{

    if (_dicData && _dicData.count > 0) {
        if([[_dicData allKeys] containsObject:AF_K_MARKET_DECIMAL])
            return [_dicData[AF_K_MARKET_DECIMAL] integerValue];
        else if([[_dicData allKeys] containsObject:AF_K_MARKET_LAST]){

            //美元 保留两位
            NSString *str = [NSString stringWithFormat:@"%@",[[_dicData allKeys] containsObject:AF_K_MARKET_CODE]?_dicData[AF_K_MARKET_CODE]:_dicData[@"Symbol"]];
            if ([str isEqualToString:@"USD"] || [str isEqualToString:@"USDJPY"])
                return 2;

            str = [NSString stringWithFormat:@"%@",_dicData[AF_K_MARKET_LAST]];
            NSArray *arr = [str componentsSeparatedByString:@"."];

            NSInteger len = arr.count >= 2?[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]].length:2;

            str = nil;
            arr = nil;

            return len > 4?4:len < 2?2:len;
        }
        else
            return 4;
    }
    else  //默认
        return 4;
    
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 验证手机、邮箱、是否含有 Emoji表情 和 过滤 HTML
////////////////////////////////////////////////////////////////////////////////
//验证手机号
+ (BOOL) validateMobile:(NSString *)_strMobileNum{

    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,184,187,188
     * 联通：130,131,132,152,155,156,176,185,186
     * 电信：133,1349,153,177,180,181,189
     */
    NSString *strNum = @"^1(34[0-8]|47[0-9]|(3[5-9]|5[017-9]|8[23478])\\d)\\d{7}$"; //移动
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strNum];
    if ([regextest evaluateWithObject:_strMobileNum] == YES)
        return YES;

    strNum = @"^1(3[0-2]|5[256]|8[56]|76)\\d{8}$";                                  //联通
    regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strNum];
    if ([regextest evaluateWithObject:_strMobileNum] == YES)
        return YES;

    strNum = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";                              //电信
    regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strNum];
    if ([regextest evaluateWithObject:_strMobileNum] == YES)
        return YES;

    return NO;
}

//验证邮箱
+ (BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//用户名只能是字母、数字、中文或下划线
+ (BOOL)validateUserName:(NSString *)strUserName{

    NSPredicate *predUserName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[A-Za-z0-9_\u4e00-\u9fa5]+$"];
    return [predUserName evaluateWithObject:strUserName];
}

//过滤HTMl
+ (NSString *)flattenHTML:(NSString *)html {

    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];

    NSMutableArray *componentsToKeep = [NSMutableArray array];
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }

    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    plainText = [plainText stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return plainText;
}

//是否含有Emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string {
     __block BOOL returnValue = NO;
     [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
      ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

              const unichar hs = [substring characterAtIndex:0];
              // surrogate pair
              if (0xd800 <= hs && hs <= 0xdbff) {
                  if (substring.length > 1) {
                      const unichar ls = [substring characterAtIndex:1];
                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                      if (0x1d000 <= uc && uc <= 0x1f77f)
                              returnValue = YES;
                  }
              }
              else if (substring.length > 1) {
                  const unichar ls = [substring characterAtIndex:1];
                  if (ls == 0x20e3)
                          returnValue = YES;
              }
              else {
                  // non surrogate
                  if (0x2100 <= hs && hs <= 0x27ff)
                        returnValue = YES;
                  else if (0x2B05 <= hs && hs <= 0x2b07)
                        returnValue = YES;
                  else if (0x2934 <= hs && hs <= 0x2935)
                        returnValue = YES;
                  else if (0x3297 <= hs && hs <= 0x3299)
                        returnValue = YES;
                  else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                        returnValue = YES;
            }
        }];

     return returnValue;
}



////////////////////////////////////////////////////////
#pragma mark - 图片滤镜处理
////////////////////////////////////////////////////////
/**
 *  图片色彩滤镜处理
 *
 *  @param _inputImage 原始需要处理的图片
 *  @param _saturation 饱和度(0.f - 2.f)
 *  @param _brightness 亮  度(-1 - 1)
 *  @param _contrast   对比度(0.f - 2.f)
 *
 *  @return UIImage
 */
+(UIImage *)imageColorControlsFilterSet:(UIImage *)_inputImage andSaturation:(float)_saturation andBrightness:(float)_brightness withContrast:(float)_contrast{

    UIImage *outputImage = _inputImage;

    // [S] 滤镜处理
    @autoreleasepool {
        //创建图像上下文 CIContext
        CIContext *_context = [CIContext contextWithOptions:nil];

        //创建滤镜CIFiter
        CIFilter *_colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];

        //创建过滤源图片CIImage
        CIImage *_image = [CIImage imageWithCGImage:_inputImage.CGImage];
        [_colorControlsFilter setValue:_image forKey:kCIInputImageKey];

        // [S] 设置滤镜参数【可选】
        //调整饱和度(0.f - 2.f)
        [_colorControlsFilter setValue:[NSNumber numberWithFloat:_saturation] forKey:@"inputSaturation"];

        //调整亮度(-1.f - 1.f)
        [_colorControlsFilter setValue:[NSNumber numberWithFloat:_brightness] forKey:@"inputBrightness"];

        //对比度(0.f - 2.f)
        [_colorControlsFilter setValue:[NSNumber numberWithFloat:_contrast] forKey:@"inputContrast"];
        // [E] 设置滤镜参数【可选】

        //取得输出图片显示或保存
        _image = [_colorControlsFilter outputImage];
        CGImageRef temp = [_context createCGImage:_image fromRect:[_image extent]];
        outputImage = [UIImage imageWithCGImage:temp];

        //释放CGImage对象
        CGImageRelease(temp);

    }
    // [E] 滤镜处理
    
    return outputImage;
    
}

/**
 *  图片高斯模糊滤镜处理
 *
 *  @param _inputImage 原始需要处理的图片
 *  @param _radius     迷糊值(默认为 10)
 *
 *  @return UIImage
 */
+(UIImage *)imageGaussianBlurFilterWithImage:(UIImage *)_inputImage andRadius:(float)_radius{

    UIImage *outputImage = _inputImage;

    @autoreleasepool {
        //创建上下文
        CIContext *context = [CIContext contextWithOptions:nil];

        //创建滤镜(高斯模糊)
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];

        //创建过滤源图片
        CIImage *image = [[CIImage alloc] initWithCGImage:_inputImage.CGImage];
        [filter setValue:image forKey:kCIInputImageKey];

        //设置过滤参数
        [filter setValue:[NSNumber numberWithFloat:_radius] forKey:@"inputRadius"];

        //取得输出图片显示或保存
        image = [filter valueForKey:kCIOutputImageKey];
        CGImageRef temp = [context createCGImage:image fromRect:[image extent]];
        outputImage = [UIImage imageWithCGImage:temp];

        //释放
        CGImageRelease(temp);
    }

    return outputImage;
}

/**
 *  图片高斯模糊滤镜处理
 *
 *  @param _inputImage 原始需要处理的图片
 *  @param _radius     迷糊值(默认为 10)
 *
 *  @return UIImage
 */
+(UIImage *)imageGaussianBlurFilterWithUrl:(NSURL *)_imgUrl andRadius:(float)_radius{

    UIImage *outputImage;
    CIImage *image = [CIImage imageWithContentsOfURL:_imgUrl];

    //创建上下文
    CIContext *context = [CIContext contextWithOptions:nil];

    //创建滤镜(高斯模糊)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];

    //创建过滤源图片
    [filter setValue:image forKey:kCIInputImageKey];

    //设置过滤参数
    [filter setValue:[NSNumber numberWithFloat:_radius] forKey:@"inputRadius"];

    //取得输出图片显示或保存
    image = [filter valueForKey:kCIOutputImageKey];
    CGImageRef temp = [context createCGImage:image fromRect:[image extent]];
    outputImage = [UIImage imageWithCGImage:temp];

    //释放
    CGImageRelease(temp);
    
    return outputImage;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - URL地址编码、解码
////////////////////////////////////////////////////////////////////////////////
//编码 URLEncode
+(NSString*)encodeURLString:(NSString*)_unencodedString{

    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";

    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)_unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));

    return encodedString;
}

//解码 URLDEcode
+(NSString *)decodeURLString:(NSString*)_encodedString{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];

    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)_encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 热帖过滤换行
////////////////////////////////////////////////////////////////////////////////
+(NSString *)filterReTieData:(NSString *)_strReTie{

    NSString *strNew = [NSString stringWithString:_strReTie];

    strNew = [strNew stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];

    strNew = [strNew stringByReplacingOccurrencesOfString:@"<script>" withString:@""];

    strNew = [strNew stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"<p>        </p>" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"<p style=\"white-space: normal;\">       </p>" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"<p style=\"white-space: normal;\"><span style=\"white-space: nowrap;\"><br></span></p>" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"<p><br></p>" withString:@""];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"max-width: 100%;" withString:@""];

    return strNew;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 强制旋转屏幕
////////////////////////////////////////////////////////////////////////////////
+(void)orientationToPortrait:(UIInterfaceOrientation)orientation {

    /**
     * UIInterfaceOrientation 旋转方向：
     *      UIInterfaceOrientationPortrait       home键朝下
     *      UIInterfaceOrientationLandscapeRight home键朝右
     *      UIInterfaceOrientationLandscapeLeft  home键朝左
     */

    SEL selector = NSSelectorFromString(@"setOrientation:");

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];

    int val = orientation;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];

    invocation = nil;
    
}

@end
