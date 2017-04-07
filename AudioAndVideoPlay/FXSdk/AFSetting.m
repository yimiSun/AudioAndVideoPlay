//
//  AFSetting.m
//  AppFinaceHT
//
//  Created by LionGlory on 13-8-21.
//  Copyright (c) 2013年 Lion. All rights reserved.
//

#import "AFSetting.h"

#import "AFUtils.h"

// 默认绘制的条数
static int DRAW_COUNT = 44;

// 分时图 绘图尺寸
static int QUARTZ_TIME_W = 240.0f;
static int QUARTZ_TIME_H = 230.0f;

// 成交量 绘图尺寸
static int QUARTZ_VOLUME_W = 319.0f;
static int QUARTZ_VOLUME_H = 57.0f;

// K线图 绘图尺寸
static int QUARTZ_KLINE_W = 240.0f;
static int QUARTZ_KLINE_H = 200.0f;

// 指标 绘图尺寸
static int QUARTZ_KPI_W = 240.0f;
static int QUARTZ_KPI_H = 45.0f;

static int QUARTZ_IPHONE5_H_OFFSET = 88.0f;

@implementation AFSetting

+ (void)load{
    NSLog(@" ****** AFSetting load ****** ");
}

//竖屏
+(void)VerticalScreenLoad{
     QUARTZ_TIME_W = 240.0f;
     QUARTZ_TIME_H = 230.0f;
    
     QUARTZ_VOLUME_W = 260.0f;
     QUARTZ_VOLUME_H = 57.0f;
    
     QUARTZ_KLINE_W = 240.0f;
     QUARTZ_KLINE_H = 200.0f;
    
     QUARTZ_KPI_W = 240.0f;
     QUARTZ_KPI_H = 45.0f;

     if([AFUtils currentResolution] != UIDevice_iPhone5){
        QUARTZ_TIME_H  -= QUARTZ_IPHONE5_H_OFFSET;
        QUARTZ_KLINE_H -= 50.0f;
     }
}

//二元期权
+(void)optionScreenLoad{
    QUARTZ_TIME_W = 270.0f;
    QUARTZ_TIME_H = 224.0f; // 212.0f;
    
    QUARTZ_VOLUME_W = 270.0f;
    QUARTZ_VOLUME_H = 60.0f;
    
    QUARTZ_KLINE_W = 270.0f;
    QUARTZ_KLINE_H = 212.0f; // 200.0f;
    
    QUARTZ_KPI_W = 270.0f;
    QUARTZ_KPI_H = 52.0f;
    if ([AFUtils currentResolution] == UIDevice_iPhone5) {
        
        QUARTZ_VOLUME_H = QUARTZ_VOLUME_H + QUARTZ_IPHONE5_H_OFFSET;
        QUARTZ_KPI_H = QUARTZ_KPI_H + QUARTZ_IPHONE5_H_OFFSET;
        
    }
}

+(void)ConstantScreenLoad{
    QUARTZ_TIME_W = 412.0f;
    QUARTZ_TIME_H = 230.0f;
    
    QUARTZ_VOLUME_W = 412.0f;
    QUARTZ_VOLUME_H = 67.0f;
    
    QUARTZ_KLINE_W = 412.0f;
    QUARTZ_KLINE_H = 178.0f;
    QUARTZ_KPI_W = 412.0f;
    QUARTZ_KPI_H = 65.0f;
    
    if ([AFUtils currentResolution] == UIDevice_iPhone5) {

        QUARTZ_TIME_W = QUARTZ_TIME_W + QUARTZ_IPHONE5_H_OFFSET;
        QUARTZ_VOLUME_W = QUARTZ_VOLUME_W + QUARTZ_IPHONE5_H_OFFSET;
        QUARTZ_KLINE_W = QUARTZ_KLINE_W + QUARTZ_IPHONE5_H_OFFSET;
        QUARTZ_KPI_W = QUARTZ_KPI_W + QUARTZ_IPHONE5_H_OFFSET;

    }
    
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - 绘图条数
////////////////////////////////////////////////////////////////////////////////
// 设置还原
+(void)AF_SET_KLINE_DEFAULT{
    DRAW_COUNT = 44;
}

// K线图 绘制条数
+(int)AF_DRAW_COUNT{
    return DRAW_COUNT;
}

// ++ 绘制条数 加加
+(BOOL)AF_DRAW_COUNT_PLUS{
    BOOL isPlus = NO;
    if (DRAW_COUNT < AF_K_MARKET_KLINE_DRAW_COUNT_MAX) {
        DRAW_COUNT+= AF_K_MARKET_KLINE_DRAW_COUNT_STEP;
        isPlus = YES;
    }
    NSLog(@" AF_DRAW_COUNT_PLUS DRAW_COUNT = %i", DRAW_COUNT);
    return isPlus;
}

// -- 绘制条数 减减
+(BOOL)AF_DRAW_COUNT_MINUS{
    BOOL isMinus = NO;
    if (DRAW_COUNT > AF_K_MARKET_KLINE_DRAW_COUNT_STEP) {
        DRAW_COUNT -= AF_K_MARKET_KLINE_DRAW_COUNT_STEP;
        isMinus = YES;
    }
    NSLog(@" AF_DRAW_COUNT_PLUS DRAW_COUNT = %i", DRAW_COUNT);
    return isMinus;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - 绘图坐标
////////////////////////////////////////////////////////////////////////////////
+(float)QUARTZ_TIME_W{
    return QUARTZ_TIME_W;
}

+(float)QUARTZ_TIME_H{
    return QUARTZ_TIME_H;
}

+(float)QUARTZ_VOLUME_W{
    return QUARTZ_VOLUME_W;
}

+(float)QUARTZ_VOLUME_H{
    return QUARTZ_VOLUME_H;
}

+(float)QUARTZ_KLINE_W{
    return QUARTZ_KLINE_W;
}

+(float)QUARTZ_KLINE_H{
    return QUARTZ_KLINE_H;
}

+(float)QUARTZ_KPI_W{
    return QUARTZ_KPI_W;
}

+(float)QUARTZ_KPI_H{
    return QUARTZ_KPI_H;
}


@end
