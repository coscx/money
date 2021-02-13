#import "FlutterAdPlugin.h"
#import <DyTaskSdk/DyAdApi.h>
#import <Foundation/Foundation.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
@interface FlutterAdPlugin()<FlutterStreamHandler>{
    NSObject<FlutterPluginRegistrar> *_registrar;
      FlutterViewController *_controller;
}

@property (nonatomic, strong) FlutterEventSink eventSink;

@end

@implementation FlutterAdPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter_ad_plugin"  binaryMessenger:[registrar messenger]];
    FlutterAdPlugin* instance = [[FlutterAdPlugin alloc] newInstance:registrar flutterViewController:nil];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
    FlutterEventChannel *eventChannel = [FlutterEventChannel
         eventChannelWithName:@"flt_ad_plugin_event"
         binaryMessenger:[registrar messenger]];
    
    
    
    [eventChannel setStreamHandler:instance];
    
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar flutterViewController:(FlutterViewController*) controller {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter_ad_plugin"  binaryMessenger:[registrar messenger]];
      //FlutterAdPlugin* instance = [[FlutterAdPlugin alloc] init];
      FlutterAdPlugin* instance = [[FlutterAdPlugin alloc] newInstance:registrar flutterViewController:controller];
      [registrar addApplicationDelegate:instance];
      [registrar addMethodCallDelegate:instance channel:channel];
      FlutterEventChannel *eventChannel = [FlutterEventChannel
           eventChannelWithName:@"flt_ad_plugin_event"
           binaryMessenger:[registrar messenger]];
      
        [eventChannel setStreamHandler:instance];
        [registrar addMethodCallDelegate:instance channel:channel];
}
 
- (instancetype)newInstance:(NSObject<FlutterPluginRegistrar>*)registrar flutterViewController:(FlutterViewController*) controller{
  _registrar = registrar;
  _controller = controller;
  return self;
}
#pragma mark - FlutterStreamHandler
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments{
    return nil;
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        [self init:call.arguments result:result];
    }
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        [self getPlatformVersion:call.arguments result:result];
    }
    if ([@"jumpAdList" isEqualToString:call.method]) {
        [self jumpAdList:call.arguments result:result];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)init:(NSDictionary *)args result:(FlutterResult)result {
    NSString *host = [self getStringValueFromArgs:args forKey:@"cid"];
    if (@available(iOS 14, *)) {
         // iOS14及以上版本需要先请求权限
         [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
             // 获取到权限后，依然使用老方法获取idfa
             if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                 NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                 NSLog(@"%@",idfa);
             } else {
                      NSLog(@"请在设置-隐私-Tracking中允许App请求跟踪");
             }
         }];
     } else {
         // iOS14以下版本依然使用老方法
         // 判断在设置-隐私里用户是否打开了广告跟踪
         if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
             NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
             NSLog(@"%@",idfa);
         } else {
             NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
         }
     }
 
 
 [DyAdApi registerWithMediaId:@"dy_59614836" appKey:@"d1a4661a68e2b5165bf7b6bcb8a5803f"];
    result([self resultSuccess:@"init success"]);
}
- (void)getPlatformVersion:(NSDictionary *)args result:(FlutterResult)result {
    NSString *host = [self getStringValueFromArgs:args forKey:@"cid"];
 
    result([self resultSuccess:@"init success"]);
}
- (void)jumpAdList:(NSDictionary *)args result:(FlutterResult)result {
    NSString *host = [self getStringValueFromArgs:args forKey:@"cid"];
    
    [DyAdApi presentListViewController:_controller userId:@"88889999" advertType:0];    result([self resultSuccess:@"init success"]);
}
- (NSDictionary *)_buildResult:(int)code message:(NSString *)message data:(id)data {
    if (data) {
        return @{
            @"code": @(code),
            @"message": message,
            @"data": data
        };
    } else {
        return @{
            @"code": @(code),
            @"message": message,
        };
    }
}

- (NSDictionary *)resultSuccess:(id)data {
    return [self _buildResult:0 message:@"成功" data:data];
}

- (NSDictionary *)resultError:(NSString *)error code:(int)code{
    return [self _buildResult:code message:error data:nil];
}
- (int)getIntValueFromArgs:(NSDictionary *)args forKey:(NSString *)forKey {
    if (args[forKey] && ![args[forKey] isKindOfClass:[NSNull class]]) {
        return [[self getStringValueFromArgs:args forKey:forKey] intValue];
    }
    return 0;
}

- (NSString *)getStringValueFromArgs:(NSDictionary *)args forKey:(NSString *)forKey {
    if (![args[forKey] isKindOfClass:[NSNull class]]) {
        return [NSString stringWithString:args[forKey]];
    } else {
        return nil;
    }
}

- (BOOL)getBoolValueFromArgs:(NSDictionary *)args forKey:(NSString *)forKey {
    if (args[forKey] && ![args[forKey] isKindOfClass:[NSNull class]]) {
       return [[self getStringValueFromArgs:args forKey:forKey] boolValue];
    }
    return NO;
}

- (void)callFlutter:(id)params {
    if (self.eventSink) {
        self.eventSink(params);
    }
}

@end
