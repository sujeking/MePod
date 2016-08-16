//
//  HXMacrosUtils.h
//  Pods
//
//  Created by ArthurWang on 16/6/13.
//
//

#ifndef HXMacrosUtils_h
#define HXMacrosUtils_h

#if     DEBUG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#       define breakpoint(e)  assert(e)//在调试模式下，如果程序进入不期望进入的分支，assert出来,如果在非调试模式下忽略
#else
#       define DLog(...)
#       define breakpoint(e)
#endif

#define RGB(r, g, b)        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define isNotNull(key) ((NSNull *)key != [NSNull null])
#define SET_NULLTONIL(TARGET, VAL) if(VAL != [NSNull null]) { TARGET = VAL; } else { TARGET = nil; }

#define LS(key)  NSLocalizedString(key, nil)

#define IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define HXS_LINE_WIDTH                  ([UIScreen mainScreen].scale >= 2 ? 0.5:1)
#define HXS_MAIN_COLOR                  UIColorFromRGB(0x08A9FA)
#define HXS_VIEWCONTROLLER_BG_COLOR     UIColorFromRGB(0xF5F6FB)
#define HXS_DORM_MAIN_COLOR             UIColorFromRGB(0xfd6059)
#define HXS_SELECT_VIEW_BG_COLOR        UIColorFromRGB(0xEDE9E4)
#define HXS_TEXT_COLOR                  UIColorFromRGB(0x736357)
#define HXS_TEXT_LIGHT_COLOR            UIColorFromRGB(0x363128)

#define HXS_TEXT_SELECT_COLOR             UIColorFromRGB(0x3E3531)
#define HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL UIColorFromRGB(0x666666)
#define HXS_BORDER_COLOR                  UIColorFromRGB(0xd1d2d2)
#define HXS_SEPARATION_LINE_COLOR         UIColorFromRGB(0xD1D2D2)
#define HXS_INFO_NOMARL_COLOR             UIColorFromRGB(0x999999)
#define HXS_SPECIAL_COLOR                 UIColorFromRGB(0xf9a502)

// APP 2.0
#define HXS_BUTTON_TEXT_AND_LINK_COLOR       UIColorFromRGB(0x54ADF9)
#define HXS_BUTTON_TEXT_AND_LINK_COLOR_ALPHA RGBA(84, 173, 249, 0.05)
#define HXS_BUTTON_PRESSED_DOWN_COLOR        UIColorFromRGB(0x4A90E2)
#define HXS_BUTTON_PRESSED_DOWN_COLOR_ALPHA  RGBA(74, 144, 226, 0.05)
#define HXS_BUTTON_BALANCE_IMPORTMENT_COLOR  UIColorFromRGB(0xFC6D41)
#define HXS_SEGMENT_TITLE_COLOR              UIColorFromRGB(0x333333)
#define HXS_TITLE_NOMARL_COLOR               UIColorFromRGB(0x666666)
#define HXS_PROMPT_TEXT_COLOR                UIColorFromRGB(0xCCCCCC)

// APP 3.0
#define HXS_COLOR_MASTER                    UIColorFromRGB(0x07A9FA)
#define HXS_COLOR_COMPLEMENTARY             UIColorFromRGB(0xF9A502)
#define HXS_COLOR_ACCENT                    UIColorFromRGB(0xF54642)
#define HXS_COLOR_BACKGROUND_MAIN           UIColorFromRGB(0xF4F5F6)
#define HXS_COLOR_BACKGROUND_MAIN2          UIColorFromRGB(0xFFFFFF)
#define HXS_COLOR_BACKGROUND_SECOND         UIColorFromRGB(0xE1FBFF)
#define HXS_COLOR_SEPARATION_STRONG         UIColorFromRGB(0xE1E2E3)
#define HXS_COLOR_SEPARATION_WEAK           UIColorFromRGB(0xF1F2F2)


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbValue & 0xFF))/255.0]

#define DIC_HAS_STRING(dic, key)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSString class]])

#define DIC_HAS_NUMBER(dic, key)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSNumber class]])

#define DIC_HAS_ARRAY(dic, key)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSArray class]])

#define DIC_HAS_DIC(dic, key)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSDictionary class]])

#define DIC_HAS_MEM(dic, key, className)  ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[className class]])

#define DIC_MEM_NOT_NULL(dic, key) ([dic objectForKey:key] && ![[dic objectForKey:key] isKindOfClass:[NSNull class]])

#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
#define IPAD_PORTRAIT (IPAD && ([UIDevice currentDevice].orientation == 1 || [UIDevice currentDevice].orientation == 2)
#define IPAD_LANDSCAPE (IPAD && ([UIDevice currentDevice].orientation == 3 || [UIDevice currentDevice].orientation == 4))

#define GLOBAL_NORMAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GLOBAL_LOW_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)

#define BEGIN_MAIN_THREAD dispatch_async(dispatch_get_main_queue(), ^(){
#define END_MAIN_THREAD   });

#define BEGIN_MAIN_THREAD_SYNC dispatch_async(dispatch_get_main_queue(), ^(){
#define END_MAIN_THREAD_SYNC   });

#define BEGIN_BACKGROUND_THREAD dispatch_async(GLOBAL_NORMAL_QUEUE, ^(){
#define END_BACKGROUND_THREAD   });

#define BEGIN_LOW_THREAD dispatch_async(GLOBAL_LOW_QUEUE, ^(){
#define END_LOW_THREAD   });


/******************** 快速的定义一个weakSelf 用于block里面  ***************/
#define WS(weakSelf)  __weak __typeof(self)weakSelf = self

/* 定义字体大小 */
#define TEXT_FONT(value) [UIFont systemFontOfSize:(value)];

#endif /* HXMacrosUtils_h */
