//
//  HXAppDeviceHelper.m
//  store
//
//  Created by chsasaw on 14-10-13.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXAppDeviceHelper.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netdb.h>
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <AdSupport/AdSupport.h>
#import "SSKeychain.h"
#import "HXAppConfig.h"

static SCNetworkReachabilityRef defaultRouteReachability;

@implementation HXAppDeviceHelper

+ (BOOL)isDeviceIPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL)isDeviceIPhone {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)deviceHasRetinaScreen {
    return ([UIScreen mainScreen].scale == 2.0f);
}

+ (CGFloat)iosVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

/*
 Platforms
 
 iFPGA ->        ??
 
 iPhone1,1 ->    iPhone 1G, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/AT&T, N89
 iPhone3,2 ->    iPhone 4/Other Carrier?, ??
 iPhone3,3 ->    iPhone 4/Verizon, TBD
 iPhone4,1 ->    (iPhone 4S/GSM), TBD
 iPhone4,2 ->    (iPhone 4S/CDMA), TBD
 iPhone4,3 ->    (iPhone 4S/???)
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 
 iPod1,1   ->    iPod touch 1G, N45
 iPod2,1   ->    iPod touch 2G, N72
 iPod2,2   ->    Unknown, ??
 iPod3,1   ->    iPod touch 3G, N18
 iPod4,1   ->    iPod touch 4G, N80
 
 // Thanks NSForge
 iPad1,1   ->    iPad 1G, WiFi and 3G, K48
 iPad2,1   ->    iPad 2G, WiFi, K93
 iPad2,2   ->    iPad 2G, GSM 3G, K94
 iPad2,3   ->    iPad 2G, CDMA 3G, K95
 iPad3,1   ->    (iPad 3G, WiFi)
 iPad3,2   ->    (iPad 3G, GSM)
 iPad3,3   ->    (iPad 3G, CDMA)
 iPad4,1   ->    (iPad 4G, WiFi)
 iPad4,2   ->    (iPad 4G, GSM)
 iPad4,3   ->    (iPad 4G, CDMA)
 
 AppleTV2,1 ->   AppleTV 2, K66
 AppleTV3,1 ->   AppleTV 3, ??
 
 i386, x86_64 -> iPhone Simulator
 */


#pragma mark sysctlbyname utils
+ (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+ (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
+ (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
+ (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

+ (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

+ (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
 */

+ (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

+ (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
+ (HXDeviceModel) modelType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return HXDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return HXDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return HXDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return HXDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return HXDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return HXDevice4SiPhone;
    if ([platform isEqualToString:@"iPhone5,1"])      return HXDevice5iPhone;
    if ([platform isEqualToString:@"iPhone5,2"])      return HXDevice5iPhone;
    if ([platform isEqualToString:@"iPhone5,3"])      return HXDevice5CiPhone;
    if ([platform isEqualToString:@"iPhone5,4"])      return HXDevice5CiPhone;
    if ([platform hasPrefix:@"iPhone6"])            return HXDevice5SiPhone;
    if ([platform isEqualToString:@"iPhone7,2"])      return HXDevice6iPhone;
    if ([platform isEqualToString:@"iPhone7,1"])      return HXDevice6PlusiPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return HXDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return HXDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return HXDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return HXDevice4GiPod;
    if ([platform hasPrefix:@"iPod5"])              return HXDevice5GiPod;
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return HXDevice1GiPad;
    if ([platform isEqualToString:@"iPad2,1"])      return HXDevice2GiPad;
    if ([platform isEqualToString:@"iPad2,2"])      return HXDevice2GiPad;
    if ([platform isEqualToString:@"iPad2,3"])      return HXDevice2GiPad;
    if ([platform isEqualToString:@"iPad2,4"])      return HXDevice2GiPad;
    if ([platform isEqualToString:@"iPad3,1"])      return HXDevice3GiPad;
    if ([platform isEqualToString:@"iPad3,2"])      return HXDevice3GiPad;
    if ([platform isEqualToString:@"iPad3,3"])      return HXDevice3GiPad;
    if ([platform isEqualToString:@"iPad3,4"])      return HXDevice4GiPad;
    if ([platform isEqualToString:@"iPad3,5"])      return HXDevice4GiPad;
    if ([platform isEqualToString:@"iPad3,6"])      return HXDevice4GiPad;
    if ([platform isEqualToString:@"iPad2,5"])      return HXDeviceMiniPad;
    if ([platform isEqualToString:@"iPad2,6"])      return HXDeviceMiniPad;
    if ([platform isEqualToString:@"iPad2,7"])      return HXDeviceMiniPad;
    if ([platform isEqualToString:@"iPad4,1"])      return HXDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,2"])      return HXDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,4"])      return HXDeviceMiniPad2G;
    if ([platform isEqualToString:@"iPad4,5"])      return HXDeviceMiniPad2G;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return HXDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return HXDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return HXDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return HXDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return HXDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return HXDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) < 768;
        return smallerScreen ? HXDeviceSimulatoriPhone : HXDeviceSimulatoriPad;
    }
    
    return HXDeviceUnknown;
}
+ (NSString *)modelTypeString {
    HXDeviceModel deviceModel = [HXAppDeviceHelper modelType];
    NSString *deviceModelString = @"Unknown";
    switch (deviceModel) {
        case HXDeviceSimulator:
            deviceModelString = @"iOS Simulator";
            break;
        case HXDeviceSimulatoriPhone:
            deviceModelString = @"iPhone Simulator";
            break;
        case HXDeviceSimulatoriPad:
            deviceModelString = @"iPad Simulator";
            break;
        case HXDeviceSimulatorAppleTV:
            deviceModelString = @"AppleTV Simulator";
            break;
        case HXDevice1GiPhone:
            deviceModelString = @"iPhone 1G";
            break;
        case HXDevice3GiPhone:
            deviceModelString = @"iPhone 3G";
            break;
        case HXDevice3GSiPhone:
            deviceModelString = @"iPhone 3GS";
            break;
        case HXDevice4iPhone:
            deviceModelString = @"iPhone 4";
            break;
        case HXDevice4SiPhone:
            deviceModelString = @"iPhone 4S";
            break;
        case HXDevice5iPhone:
            deviceModelString = @"iPhone 5";
            break;
        case HXDevice5CiPhone:
            deviceModelString = @"iPhone 5C";
            break;
        case HXDevice5SiPhone:
            deviceModelString = @"iPhone 5S";
            break;
        case HXDevice1GiPod:
            deviceModelString = @"iPod 1G";
            break;
        case HXDevice2GiPod:
            deviceModelString = @"iPod 2G";
            break;
        case HXDevice3GiPod:
            deviceModelString = @"iPod 3G";
            break;
        case HXDevice4GiPod:
            deviceModelString = @"iPod 4G";
            break;
        case HXDevice5GiPod:
            deviceModelString = @"iPod 5G";
            break;
        case HXDevice1GiPad:
            deviceModelString = @"iPad 1G";
            break;
        case HXDevice2GiPad:
            deviceModelString = @"iPad 2G";
            break;
        case HXDevice3GiPad:
            deviceModelString = @"iPad 3G";
            break;
        case HXDevice4GiPad:
            deviceModelString = @"iPad 4G";
            break;
        case HXDeviceMiniPad:
            deviceModelString = @"iPad Mini";
            break;
        case HXDeviceiPadAir:
            deviceModelString = @"iPad Air";
            break;
        case HXDeviceMiniPad2G:
            deviceModelString = @"iPad Mini 2G";
            break;
        case HXDevice6iPhone:
            deviceModelString = @"iPhone 6";
            break;
        case HXDevice6PlusiPhone:
            deviceModelString = @"iPhone 6 Plus";
            break;
        default:
            deviceModelString = [self platform];
            break;
    }
    
    return deviceModelString;
}
+ (NSString *)modelString {
    return [self platform];
}

+ (HXDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return HXDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return HXDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return HXDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return HXDeviceFamilyAppleTV;
    
    return HXDeviceFamilyUnknown;
}

+ (BOOL)isInternetConnectionAvailable {
    if (!defaultRouteReachability) {
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    }
    SCNetworkReachabilityFlags flags;
    BOOL gotFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    if (!gotFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
    if (!isReachable)
        return NO;
    BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
        noConnectionRequired = YES;
    }
    if (!noConnectionRequired)
        return NO;
    
    if (flags & kSCNetworkReachabilityFlagsIsDirect) {
        // The connection is to an ad-hoc WiFi network, so Internet access is not available.
        return NO;
    } else {
        return YES;
    }
}

+ (NSString *)uniqueDeviceIdentifier{
    NSString * identifier = [SSKeychain passwordForService:[HXAppConfig sharedInstance].appName account:@"uniqueDeviceIdentifier"];
    if(identifier) {
        return identifier;
    }else {
        identifier = [NSString stringWithFormat:@"o%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        [SSKeychain setPassword:identifier forService:[HXAppConfig sharedInstance].appName account:@"uniqueDeviceIdentifier"];
        
        return identifier;
    }
}

+ (NSString *)currentLocaleId {
    NSString *str = [[NSLocale currentLocale] localeIdentifier];
    if ([str rangeOfString:@"@"].location != NSNotFound) {
        return [str substringToIndex:[str rangeOfString:@"@"].location];
    } else {
        return str;
    }
}

+ (CGSize)currentScreenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)isScreen480Height
{
    return (fabs(MAX([HXAppDeviceHelper currentScreenSize].width, [HXAppDeviceHelper currentScreenSize].height) - 480) < 0.001);
}

+ (BOOL)isScreen568Height {
    return (fabs(MAX([HXAppDeviceHelper currentScreenSize].width, [HXAppDeviceHelper currentScreenSize].height) - 568) < 0.001);
}
+ (BOOL)isScreenMoreThanOrEqualTo568Height {
    return (MAX([HXAppDeviceHelper currentScreenSize].width, [HXAppDeviceHelper currentScreenSize].height) - 568 >= 0);
}

+ (BOOL)isScreen667Height {
    return (fabs(MAX([HXAppDeviceHelper currentScreenSize].width, [HXAppDeviceHelper currentScreenSize].height) - 667) < 0.001);
}

+ (BOOL)isScreen736Height {
    return (fabs(MAX([HXAppDeviceHelper currentScreenSize].width, [HXAppDeviceHelper currentScreenSize].height) - 736) < 0.001);
}

+ (BOOL)isIPhone5 {
    HXDeviceModel model = [self modelType];
    return (model == HXDevice5iPhone) || (model == HXDevice5CiPhone) || (model == HXDevice5SiPhone);
}

+ (BOOL)isIPhone6 {
    return [self modelType] == HXDevice6iPhone;
}

+ (BOOL)isIPhone6Plus {
    return [self modelType] == HXDevice6PlusiPhone;
}

+ (BOOL)canBlur {
    if(NSStringFromClass([UIVisualEffectView class]) && UIDevice.currentDevice.systemVersion.floatValue >= 8.0 && !UIAccessibilityIsReduceTransparencyEnabled()) {
        NSString *platform = self.platform;
        NSString *deviceVersionString = [[platform stringByReplacingOccurrencesOfString:@"[^0-9,.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, platform.length)] stringByReplacingOccurrencesOfString:@"," withString:@"."];
        CGFloat deviceVersion = [deviceVersionString floatValue];
        
        if([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
            return YES;
        } else if([platform rangeOfString:@"iPhone"].location != NSNotFound) {
            return (deviceVersion >= 4.099);
        } else if([platform rangeOfString:@"iPod"].location != NSNotFound) {
            return (deviceVersion >= 5.099);
        } else if([platform rangeOfString:@"iPad"].location != NSNotFound) {
            return (deviceVersion >= 3.399);
        }
    }
    
    return NO;
}

+ (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

@end
