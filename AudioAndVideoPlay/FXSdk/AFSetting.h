//
//  AFSetting.h
//  AppFinaceHT
//
//  Created by LionGlory on 13-8-21.
//  Copyright (c) 2013年 Lion. All rights reserved.
//

#import <Foundation/Foundation.h>


////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
#pragma mark - ========== iPhone iPhone5 页面 高度差 ==========
////////////////////////////////////////////////////////////////////////////////
#define AF_IPHONE5_H_OFFSET 88.0f;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - ========== 行情 ==========
////////////////////////////////////////////////////////////////////////////////
#define HTmmarket @"htmmarket"  //行情中心
#define Wenmarket @"wenmarket"  //邮币卡行情


// ****************************【S】 【汇通 用】 ******************************* //
#define AF_K_MARKET_UDP_HOST    @"htmmarketudp.fx678.com"
#define AF_K_MARKET_UDP_PORT 26001

#define AF_K_MARKET_TOKEN       @"1793ea9293b25f0992f497f5f469f92f"
#define AF_K_MARKET_MD5_KEY     @"htm_key_market_2099"

#define AF_K_MARKET_URL_LIST    @"http://htmmarket.fx678.com/list.php?excode=%@&time=%@&token=%@&key=%@"
//行情分时图接口
#define AF_K_MARKET_URL_TIME    @"%@/api/quote?symbol=%@&time=%@&befortime=1"
#define AF_K_MARKET_URL_TIME_FX678 @"http://htmmarket.fx678.com/time.php?excode=%@&code=%@&time=%@&token=%@&key=%@"

//行情K线接口
#define AF_K_MARKET_URL_KLINE   @"%@/api/quote?symbol=%@&time=%@&befortime=0"
#define AF_K_MARKET_URL_CUSTOM  @"http://htmmarket.fx678.com/custom.php?excode=custom&code=%@&time=%@&token=%@&key=%@"

#define AF_K_MARKET_URL_KLINE_FX678 @"http://htmmarket.fx678.com/kline.php?excode=%@&code=%@&type=%@&time=%@&token=%@&key=%@"
// ****************************【E】 【汇通 用】 ******************************* //

// ****************************【S】 【邮币卡 行情】 ******************************* //
#define AF_Bika_MARKET_UDP_HOST @"wenmarketudp.fx678.com"

#define AF_Bika_MARKET_TOKEN @"f1544d416244464c3e749396fd86ea8b"
#define AF_Bika_MARKET_MD5_KEY @"wen_key_market_6099"

#define AF_Bika_MARKET_URL_LIST @"http://wenmarket.fx678.com/list.php?excode=%@&time=%@&token=%@&key=%@"
#define AF_Bika_MARKET_URL_TIME @"http://wenmarket.fx678.com/time.php?excode=%@&code=%@&time=%@&token=%@&key=%@"
#define AF_Bika_MARKET_URL_KLINE @"http://wenmarket.fx678.com/kline.php?excode=%@&code=%@&type=%@&time=%@&token=%@&key=%@"
#define AF_Bika_MARKET_URL_CUSTOM @"http://wenmarket.fx678.com/custom.php?excode=custom&code=%@&time=%@&token=%@&key=%@"
// ****************************【E】 【邮币卡 行情】 ******************************* //


////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
#pragma mark - market kind key
////////////////////////////////////////////////////////////////////////////////
#define AF_MARKET_TYPE_KEY_STOCK 0                  //股票
#define AF_MARKET_TYPE_KEY_COMMODITY 1              //商品
#define AF_MARKET_TYPE_KEY_FOREX 2                  //外汇
#define AF_MARKET_TYPE_KEY_INDEX 3                  //股指


#define AF_K_MARKET_KEY_CUSTOM  @"CUSTOM"           //自选
#define AF_K_MARKET_KEY_WGJS  @"WGJS"               // 国际黄金
#define AF_K_MARKET_KEY_WH  @"WH"                   // 外汇


#define AF_K_MARKET_KEY_GJZS  @"GJZS"               // 全球股指
#define AF_K_MARKET_KEY_LME  @"LME"                 // LME金属
#define AF_K_MARKET_KEY_NYMEX  @"NYMEX"             // NYME原油
#define AF_K_MARKET_KEY_COMEX  @"COMEX"             // COMEX期金
#define AF_K_MARKET_KEY_IPE  @"IPE"                 // IPE原油
#define AF_K_MARKET_KEY_NYBOT  @"NYBOT"             // 纽约期货

#define AF_K_MARKET_KEY_SGE  @"SGE"                 // 上海黄金
#define AF_K_MARKET_KEY_SHFE  @"SHFE"               // 上海期货
#define AF_K_MARKET_KEY_YRDCE  @"YRDCE"             // 长商所
#define AF_K_MARKET_KEY_TJPME  @"TJPME"             // 津贵所
#define AF_K_MARKET_KEY_PMEC  @"PMEC"               // 广贵所
#define AF_K_MARKET_KEY_TMRE  @"TMRE"               // 天矿所
#define AF_K_MARKET_KEY_HBOT  @"HBOT"               // 新华大宗
#define AF_K_MARKET_KEY_DYYCE  @"DYYCE"             // 大圆银泰
#define AF_K_MARKET_KEY_BJBCE  @"BJBCE"             // 北商所
#define AF_K_MARKET_KEY_SZPEC  @"SZPEC"             // 深石油
#define AF_K_MARKET_KEY_BPEX  @"BPEX"               // 北石油
#define AF_K_MARKET_KEY_XMPEX  @"XMPEX"             // 厦石油
#define AF_K_MARKET_KEY_CCDPT  @"CCDPT"             // 甬交所
#define AF_K_MARKET_KEY_HNCEC  @"HNCEC"             // 海南大宗
#define AF_K_MARKET_KEY_JZMEX  @"JZMEX"             // 江阴周庄
#define AF_K_MARKET_KEY_QDGJ  @"QDGJ"               // 青岛国金
#define AF_K_MARKET_KEY_HXCE  @"HXCE"               // 海西所
#define AF_K_MARKET_KEY_HFCE  @"HFCE"               // 兰溪汇丰
#define AF_K_MARKET_KEY_HJ    @"HJ"                 // 汇金所
#define AF_K_MARKET_KEY_SJCTM  @"SJCTM"             // 上海金山
#define AF_K_MARKET_KEY_SHXME  @"SHXME"             // 陕金所
#define AF_K_MARKET_KEY_JZCEC  @"JZCEC"             //青岛九州
#define AF_K_MARKET_KEY_QILUCE  @"QILUCE"           //齐鲁所
#define AF_K_MARKET_KEY_DZCE  @"DZCE"               //电交所
#define AF_K_MARKET_KEY_BLJYZX  @"BLJYZX"           //保利商品
#define AF_K_MARKET_KEY_DLPMEC  @"DLPMEC"           //大交所
#define AF_K_MARKET_KEY_BECCT  @"BECCT"             //北文青铜
#define AF_K_MARKET_KEY_NCCE  @"NCCE"               //东盟交易所
#define AF_K_MARKET_KEY_PGOLD @"PGOLD"              //纸黄金



#define AF_K_MARKET_KEY_CUSTOM_NAME  @"自选"         // 自选
#define AF_K_MARKET_KEY_WGJS_NAME  @"黄金"           // 国际黄金
#define AF_K_MARKET_KEY_WH_NAME  @"外汇"             // 外汇
#define AF_K_MARKET_KEY_GJZS_NAME  @"股指"           // 全球股指
#define AF_K_MARKET_KEY_LME_NAME  @"LME"            // 伦敦金
#define AF_K_MARKET_KEY_NYMEX_NAME  @"NYMEX"        // NYME原油
#define AF_K_MARKET_KEY_COMEX_NAME  @"COMEX"        // COMEX期金
#define AF_K_MARKET_KEY_IPE_NAME  @"IPE"            // IPE原油
#define AF_K_MARKET_KEY_NYBOT_NAME  @"纽约期货"      // 纽约期货

#define AF_K_MARKET_KEY_SGE_NAME  @"上海黄金"              // 上海黄金
#define AF_K_MARKET_KEY_SHFE_NAME  @"上海期货"             // 上海期货
#define AF_K_MARKET_KEY_YRDCE_NAME  @"长商所"              // 长商所AF_K_MARKET_KEY_YRDCE
#define AF_K_MARKET_KEY_TJPME_NAME  @"津贵所"             // 津贵所
#define AF_K_MARKET_KEY_PMEC_NAME  @"广贵所"              // 广贵所
#define AF_K_MARKET_KEY_TMRE_NAME  @"天矿所"              // 天矿所
#define AF_K_MARKET_KEY_HBOT_NAME  @"新华大宗"            // 新华大宗
#define AF_K_MARKET_KEY_DYYCE_NAME  @"大圆银泰"           // 大圆银泰
#define AF_K_MARKET_KEY_BJBCE_NAME  @"北商所"             // 北商所
#define AF_K_MARKET_KEY_SZPEC_NAME  @"深油所"             // 深石油
#define AF_K_MARKET_KEY_BPEX_NAME  @"北油所"              // 北石油
#define AF_K_MARKET_KEY_XMPEX_NAME  @"厦石油"             // 厦石油
#define AF_K_MARKET_KEY_CCDPT_NAME  @"甬交所"             // 甬交所
#define AF_K_MARKET_KEY_HNCEC_NAME  @"海南大宗"           // 海南大宗
#define AF_K_MARKET_KEY_JZMEX_NAME  @"江阴周庄"           // 江阴周庄
#define AF_K_MARKET_KEY_QDGJ_NAME  @"青岛国金"            // 青岛国金
#define AF_K_MARKET_KEY_HXCE_NAME  @"海西所"              // 海西所
#define AF_K_MARKET_KEY_HFCE_NAME  @"兰溪汇丰"            // 兰溪汇丰
#define AF_K_MARKET_KEY_HJ_NAME  @"汇金所"                // 汇金所
#define AF_K_MARKET_KEY_SJCTM_NAME  @"上海金山"           // 上海金山
#define AF_K_MARKET_KEY_SHXME_NAME  @"陕金所"             // 陕金所
#define AF_K_MARKET_KEY_JZCEC_NAME  @"九州商品"           //青岛九州
#define AF_K_MARKET_KEY_QILUCE_NAME  @"齐鲁所"            //齐鲁所
#define AF_K_MARKET_KEY_DZCE_NAME  @"电交所"              //电交所
#define AF_K_MARKET_KEY_BLJYZX_NAME  @"保利商品"          //保利商品
#define AF_K_MARKET_KEY_DLPMEC_NAME  @"大交所"            //大交所
#define AF_K_MARKET_KEY_BECCT_NAME  @"北文青铜"           //北文青铜
#define AF_K_MARKET_KEY_NCCE_NAME  @"东盟所"             //东盟交易所
#define AF_K_MARKET_KEY_PGOLD_NAME @"纸黄金"              //纸黄金


// 邮币卡行情
#define AF_K_MARKET_KEY_WJYBK  @"WJYBK"               //福丽特
#define AF_K_MARKET_KEY_JSCAEE  @"JSCAEE"             //江苏
#define AF_K_MARKET_KEY_NJSCAE  @"NJSCAE"             //南京
#define AF_K_MARKET_KEY_CNSCEE  @"CNSCEE"             //南方
#define AF_K_MARKET_KEY_HUAXIACAE  @"HUAXIACAE"       //华夏
#define AF_K_MARKET_KEY_HBCPRE  @"HBCPRE"             //华中
#define AF_K_MARKET_KEY_ZNYPJY  @"ZNYPJY"             //中南
#define AF_K_MARKET_KEY_JINMAJIA  @"JINMAJIA"         //金马甲
#define AF_K_MARKET_KEY_LNDDWJS  @"LNDDWJS"           //辽宁当代


#define AF_K_MARKET_KEY_WJYBK_NAME  @"福丽特"            // 福丽特
#define AF_K_MARKET_KEY_JSCAEE_NAME  @"江苏"            // 江苏
#define AF_K_MARKET_KEY_NJSCAE_NAME  @"南京"            // 南京
#define AF_K_MARKET_KEY_CNSCEE_NAME  @"南方"            // 南方
#define AF_K_MARKET_KEY_HUAXIACAE_NAME  @"华夏"            // 华夏
#define AF_K_MARKET_KEY_HBCPRE_NAME  @"华中"            // 华中
#define AF_K_MARKET_KEY_ZNYPJY_NAME  @"中南"            // 中南
#define AF_K_MARKET_KEY_JINMAJIA_NAME  @"金马甲"            // 金马甲
#define AF_K_MARKET_KEY_LNDDWJS_NAME  @"辽宁当代"            // 辽宁当代


////////////////////////////////////////////////////////////////////////////////
#pragma mark - market filed
////////////////////////////////////////////////////////////////////////////////
#define AF_K_MARKET_NAME @"Name"
#define AF_K_MARKET_CODE @"Code"
#define AF_K_MARKET_LAST @"Last"
#define AF_K_MARKET_OPEN @"Open"
#define AF_K_MARKET_HIGH @"High"
#define AF_K_MARKET_LOW @"Low"
#define AF_K_MARKET_CLOSE @"Close"
#define AF_K_MARKET_SELL @"Sell"
#define AF_K_MARKET_LASTCLOSE @"LastClose"
#define AF_K_MARKET_QUOTETIME @"QuoteTime"
#define AF_K_MARKET_DECIMAL @"Decimal"
#define AF_K_MARKET_VOLUME @"Volume"             //成交量
#define AF_K_MARKET_DRAW @"Draw"
#define AF_K_MARKET_EXCODE @"Excode"

//股票专有
#define AF_K_MARKET_TRANSACTION_VOLUME @"Transactionvolume"   //成交量(股)
#define AF_K_MARKET_RATE @"Rate"           //市盈率TTM
#define AF_K_MARKET_TOTAL @"Total"         //总市值
#define AF_K_MARKET_TURNOVER @"Turnover"   //换手率

#define AF_K_MARKET_DATE @"Date"
#define AF_K_MARKET_UPDATETIME @"UpdateTime"
#define AF_K_MARKET_AVERAGE @"Average"
#define AF_K_MARKET_STATUS @"Status"

////////////////////////////////////////////////////////////////////////////////
// Market Time Use
#define AF_K_MARKET_TIME_MAX_POINT @"K_MARKET_TIME_MAX_POINT"      // 分时图 绘制 的 最多 点数
#define AF_K_MARKET_TIME_ADD_MINUTE @"K_MARKET_TIME_ADD_MINUTE"    // 分时图 多少分钟增加一个点
#define AF_K_MARKET_TIME_LEFT @"K_MARKET_TIME_LEFT"                // 分时图 左 时间
#define AF_K_MARKET_TIME_CENTER @"K_MARKET_TIME_CENTER"            // 分时图 中 时间
#define AF_K_MARKET_TIME_RIGHT @"K_MARKET_TIME_RIGHT"              // 分时图 右 时间

////////////////////////////////////////////////////////////////////////////////
#pragma mark - KLINE TYPE
////////////////////////////////////////////////////////////////////////////////
#define AF_K_MARKET_KLINE_TYPE_1D @"D"
#define AF_K_MARKET_KLINE_TYPE_1W @"W"
#define AF_K_MARKET_KLINE_TYPE_5M @"5"
#define AF_K_MARKET_KLINE_TYPE_15M @"15"
#define AF_K_MARKET_KLINE_TYPE_30M @"30"
#define AF_K_MARKET_KLINE_TYPE_60M @"60"
#define AF_K_MARKET_KLINE_TYPE_MONTH @"M"

#define AF_K_MARKET_KLINE_TYPE_NAME_1D @"日线"
#define AF_K_MARKET_KLINE_TYPE_NAME_1W @"周线"
#define AF_K_MARKET_KLINE_TYPE_NAME_5M @"5分"
#define AF_K_MARKET_KLINE_TYPE_NAME_15M @"15分"
#define AF_K_MARKET_KLINE_TYPE_NAME_30M @"30分"
#define AF_K_MARKET_KLINE_TYPE_NAME_60M @"60分"
#define AF_K_MARKET_KLINE_TYPE_NAME_5D @"5日"
#define AF_K_MARKET_KLINE_TYPE_NAME_MONTH @"月线"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - kPI TYPE
////////////////////////////////////////////////////////////////////////////////
// 0: MACD平滑异同平均线
// 1: VOL成交量
// 2: RSI强弱指标
// 3: BOLL布林线
// 4: KDJ随机指标
// 5: OBV能量潮
// 6: CCI顺势
// 7: PSY心里线
#define AF_K_MARKET_KPI_TYPE_NAME_MACD @"MACD"
#define AF_K_MARKET_KPI_TYPE_NAME_VOL @"VOL"
#define AF_K_MARKET_KPI_TYPE_NAME_RSI @"RSI"
#define AF_K_MARKET_KPI_TYPE_NAME_BOLL @"BOLL"
#define AF_K_MARKET_KPI_TYPE_NAME_KDJ @"KDJ"
#define AF_K_MARKET_KPI_TYPE_NAME_OBV @"OBV"
#define AF_K_MARKET_KPI_TYPE_NAME_CCI @"CCI"
#define AF_K_MARKET_KPI_TYPE_NAME_PSY @"PSY"


////////////////////////////////////////////////////////////////////////////////
#pragma mark - 绘图参数
////////////////////////////////////////////////////////////////////////////////
#define AF_K_MARKET_KLINE_DRAW_COUNT_DEFAULT 44        // 默认绘制点数
#define AF_K_MARKET_KLINE_DRAW_COUNT_STEP 22           // 绘制点数步长
#define AF_K_MARKET_KLINE_DRAW_COUNT_MAX 88            // 绘制最大点数
//#define AF_K_MARKET_KLINE_MIN_WIDTH 6


// 绘图颜色 红涨、绿跌 颜色设置
#define AF_K_QUARTZ_KLINE_UP_CGCOLOR [[AFUtils UIColorFromRGB:0xf05857 alpha:1.0] CGColor]      // 上涨颜色
#define AF_K_QUARTZ_KLINE_DOWN_CGCOLOR [[AFUtils UIColorFromRGB:0x86c839 alpha:1.0] CGColor]    // 下跌颜色

#define AF_K_QUARTZ_KLINE_UP_COLOR [AFUtils UIColorFromRGB:0xf05857 alpha:1.0]        // 上涨颜色
#define AF_K_QUARTZ_KLINE_DOWN_COLOR [AFUtils UIColorFromRGB:0x86c839 alpha:1.0]      // 下跌颜色
#define AF_K_QUARTZ_KLINE_NO_CHANGE_COLOR [AFUtils UIColorFromRGB:0xffffff alpha:1.0] // 白平颜色

// 十字光标 线 类型
#define AF_K_MARKET_FINGER_VIEW_TYPE_TIME 1
#define AF_K_MARKET_FINGER_VIEW_TYPE_KLINE 2

// 绘图颜色 外边框颜色
#define AF_K_QUARTZ_DRAW_BORDER_CGCOLOR [[AFUtils UIColorFromRGB:0x333235 alpha:1] CGColor]

// 绘图颜色 内边框颜色
#define AF_K_QUARTZ_DRAW_BORDER_CGCOLOR_daush [[AFUtils UIColorFromRGB:0x333235 alpha:.45f] CGColor]

//分时图顶部边框色
#define AF_K_QUARTZ_DRAW_TOP_CGCOLOR [AFUtils UIColorFromRGB:0xf9c80a alpha:1.f]


////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - ========== 订阅栏目 ==========
//所有一级栏目
#define K_APP_DIN_YUE_PARENT_COLUMNS_ARRAY @"app_din_yue_parent_columns_array"

//所有二级栏目
#define K_APP_DIN_YUE_CHILD_COLUMNS_ARRAY @"app_din_yue_child_columns_array"

//所有订阅栏目
#define AF_K_NEWS_DING_YUE_COLUMNS_URL @"%@/api/fnewkeywordsorttitle/1"

// 获取新闻列表
#define AF_K_NEWS_LIST_URL @"%@/api/keywordnewsl?parentIds=%@&page=%lD&pageSize=%lD"

// 获取新闻详情
#define AF_K_NEWS_CONTENT_URL @"%@/HtNews/Index?newsid=%@&r=%@"

// 财经联盟
#define AF_K_UNION_NEWS_CONTENT_URL @"%@/FinancialUnion/Index?articleid=%@&r=%@"

// 获取头条详情
#define AF_K_TOP_NEWS_CONTENT_URL @"%@/fx678/top_detail.php?s=%@&oid=%@&nid=%@&time=%@&key=%@"

// 首页用的 重要财经
#define AF_K_NEWS_URL_CALENDAR_IMP @"http://m.fx678.com/Calendar_imp.asp"

// www.otcbeta.com 新闻
#define AF_K_OTCBETA_NEWS_LIST_URL @"%@/otcbeta/news.php?s=%@&oid=%@&nc=%@&nid=%@&time=%@&key=%@"

// www.otcbeta.com 新闻详情
#define AF_K_OTCBETA_NEWS_CONTENT_URL @"%@/otcbeta/detail.php?s=%@&oid=%@&nid=%@&time=%@&key=%@"

////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
#pragma mark - 财经日历

// 返回 JSON 格式数据
#define AF_K_CALENDAR_URL @"%@/w/calendar.php?s=%@&date=%@&time=%@&key=%@"

#pragma mark - 美国数据
#define AF_K_AMERICANDATA_URL @"%@/w/usadata.php?s=%@&time=%@&key=%@"

#pragma mark - 央行动态
#define AF_K_CENTRALBANK_URL @"%@/w/worldbank.php?s=%@&time=%@&key=%@"

#pragma mark - 各国数据
#define AF_K_COUNTDATA_URL @"%@/w/countrydata.php?s=%@&time=%@&key=%@"

#pragma mark - 财经事件
#define AF_K_FINANCIALAFFAIRS_URL  @"%@/w/calendar_forecast.php?s=%@&type=%@&date=%@&time=%@&key=%@"
////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////


#pragma mark - ========== 交易所新闻公告 ==========
// 行情中获取新闻列表 htmdatanet.fx678.com
#define AF_K_EXCHANGE_NEWS_LIST_URL @"%@/exchange/news.php?s=%@&excode=%@&code=%@&nc=%@&nid=%@&time=%@&key=%@"//正式

// 行情中获取新闻详情
#define AF_K_EXCHANGE_NEWS_CONTENT_URL @"%@/exchange/detail.php?s=%@&oid=%@&nid=%@&time=%@&key=%@"//正式

//邮币卡公告
#define AF_K_WEN_NOTICE_LIST_URL @"%@/content/wen/news.php?s=%@&oid=%@&cid=%@&last=%@&time=%@&key=%@"//正式

// 邮币卡详情
#define AF_K_WEN_NOTICE_CONTENT_URL @"%@/content/wen/detail.php?s=%@&oid=%@&nid=%@&time=%@&key=%@"//正式

#pragma mark - htmdata.fx678.com
#define AF_K_HTMDATA_SOCIETY_FEEDBACK_FEEDBACK @"http://htmdata.fx678.com/15/m/feedback/feedback.php"





@interface AFSetting : NSObject

// KLine设置还原
+(void)AF_SET_KLINE_DEFAULT;

// K线图 绘制条数
+(int)AF_DRAW_COUNT;
// ++ 绘制条数 加加
+(BOOL)AF_DRAW_COUNT_PLUS;
// -- 绘制条数 减减
+(BOOL)AF_DRAW_COUNT_MINUS;

// 绘图坐标
+(float)QUARTZ_TIME_W;
+(float)QUARTZ_TIME_H;

+(float)QUARTZ_VOLUME_W;
+(float)QUARTZ_VOLUME_H;

+(float)QUARTZ_KLINE_W;
+(float)QUARTZ_KLINE_H;

+(float)QUARTZ_KPI_W;
+(float)QUARTZ_KPI_H;

+(void)VerticalScreenLoad;
+(void)ConstantScreenLoad;
+(void)optionScreenLoad;

@end
