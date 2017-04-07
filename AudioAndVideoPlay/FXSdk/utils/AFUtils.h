//
//  Utils.h
//  AppFinance
//
//  Created by wei on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_UTILS_UIColorFromRGB(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define K_UTILS_UIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


// 2015-01-19 18:01:02  YYYY-MM-dd HH:mm:ss
// 2015/1/19 18:01:02  YYYY/MM/dd HH:mm:ss
#define AF_UTILS_DATA_FORMAT_1 @"YYYY-MM-dd HH:mm:ss"


enum {
    UIDevice_iPhone3                = 1,    // iPhone 1,3,3GS Standard Resolution   (320x480px)
    UIDevice_iPhone4                = 2,    // iPhone 4,4S High Resolution          (640x960px)
    UIDevice_iPhone5                = 3,    // iPhone 5 High Resolution             (640x1136px)
    UIDevice_iPad2                  = 4,    // iPad 1,2 Standard Resolution         (1024x768px)
    UIDevice_iPad3                  = 5     // iPad 3,4 High Resolution             (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;


@interface AFUtils : NSObject

////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 时间
+ (NSString *) unixTime:(NSString*) unixTime format:(NSString*) format;
+ (NSString *) unixTime:(NSString*) unixTime;
+ (NSString *) unixTimeHand:(NSString*) unixTime;
+ (NSString *) unixTimePoint:(NSString*) unixTime;
+ (NSString *) unixTimePointMin:(NSString*) unixTime;
+ (NSString *) unixTimePointYYYYMMDDHHMM:(NSString*) unixTime;
+ (NSString *) unixTimeForNow:(NSString *)_strUnixTime formate:(NSString *)_formateString;

+ (int) unixTimeMinute:(NSString*) unixTime;

+ (NSString*) stringToDate:(NSString *)_time;

+ (NSString*) stringToDate:(NSString *)_time withFormat:(NSString *)format;

+ (int)nowMinute;

+ (NSString *)nowDataChangeMinToUnixTime:(int)_min;

+ (NSString *) dateStringAForNow;
+ (long long int)localUnixTime;
+ (NSString *) dateStringNowForFormat:(NSString*)_format;

/**
 *  GetWeekForDate
 *  根据日期获取星期
 *
 *  @param NSString strDate 日期(yyyy-MM-dd)
 *
 *  @return NSString / empty
 */
/**
 *  GetWeekForDate
 *  根据日期获取星期
 *
 *  @param NSString   strDate 日期(yyyy-MM-dd)
 *  @param NSInteger  type 类型(0 星期x 1 周x)
 *
 *  @return NSString / empty
 */
+ (NSString *) GetWeekForDate:(NSString *) strDate withType:(NSInteger)type;

/**
 *  GetMonthForDate
 *  根据日期获取月份
 *
 *  @param NSString   strDate 日期(yyyy-MM-dd)
 *  @param NSInteger  type 类型(1 五月 2 May)
 *
 *  @return NSString / empty
 */
+ (NSString *) GetMonthForDate:(NSString *) strDate withType:(NSInteger)type;

#pragma mark - UIDevice
+ (UIDeviceResolution) currentResolution;
#pragma mark - MD5
+(NSString *)md5:(NSString *)str;

    
////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 颜色
+ (UIColor *) UIColorFromRed:(float) red green:(float) green blue:(float) blue;
+ (UIColor *) UIColorFromRGB:(int) rgbValue alpha:(float) alphaValue;


////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 消息弹框
+ (void) alertMessage:(NSString *) inmsg;
+(void)  alertMessageNoButton:(NSString *) inmsg;


////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 高度、宽度计算
+(float)uiLabelHeight:(NSString*)_text withSize:(CGFloat) _size andWidth:(CGFloat) _width;

+(float)get_width_for_string:(NSString*)title withSize:(CGFloat) size andWidth:(CGFloat) width;

+(float)uiLableRichTextHeight:(NSString *)_strContent Width:(CGFloat)_width;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 缓存处理
////////////////////////////////////////////////////////////////////////////////

// 根据路径返回目录或文件的大小
+ (double)sizeWithFilePath:(NSString *)path;

// 得到指定目录下的所有文件
+ (NSArray *)getAllFileNames:(NSString *)dirPath;

// 删除指定目录或文件
+ (BOOL)clearCachesWithFilePath:(NSString *)path;

// 清空指定目录下文件
+ (BOOL)clearCachesFromDirectoryPath:(NSString *)dirPath;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 获取保存位数
////////////////////////////////////////////////////////////////////////////////
+ (NSInteger)getDecimal:(NSDictionary *)_dicDat;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 验证手机、邮箱
////////////////////////////////////////////////////////////////////////////////
//验证手机号
+ (BOOL) validateMobile:(NSString *)_strMobileNum;

//验证邮箱
+ (BOOL)validateEmail:(NSString *)email;

//用户名只能是字母、数字、中文或下划线
+ (BOOL)validateUserName:(NSString *)strUserName;

//过滤HTML
+ (NSString *)flattenHTML:(NSString *)html;

//是否含有Emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;


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
+(UIImage *)imageColorControlsFilterSet:(UIImage *)_inputImage andSaturation:(float)_saturation andBrightness:(float)_brightness withContrast:(float)_contrast;

/**
 *  图片高斯模糊滤镜处理
 *
 *  @param _inputImage 原始需要处理的图片
 *  @param _radius     迷糊值(默认为 10)
 *
 *  @return UIImage
 */
+(UIImage *)imageGaussianBlurFilterWithImage:(UIImage *)_inputImage andRadius:(float)_radius;

/**
 *  图片高斯模糊滤镜处理
 *
 *  @param _inputImage 原始需要处理的图片
 *  @param _radius     迷糊值(默认为 10)
 *
 *  @return UIImage
 */
+(UIImage *)imageGaussianBlurFilterWithUrl:(NSURL *)_imgUrl andRadius:(float)_radius;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - URL地址编码、解码
////////////////////////////////////////////////////////////////////////////////
//编码 URLEncode
+(NSString*)encodeURLString:(NSString*)_unencodedString;

//解码 URLDEcode
+(NSString *)decodeURLString:(NSString*)_encodedString;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 热帖过滤换行
////////////////////////////////////////////////////////////////////////////////
+(NSString *)filterReTieData:(NSString *)_strReTie;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 强制旋转屏幕
////////////////////////////////////////////////////////////////////////////////
+(void)orientationToPortrait:(UIInterfaceOrientation)orientation;

@end
