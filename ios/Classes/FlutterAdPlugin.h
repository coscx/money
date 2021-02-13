#import <Flutter/Flutter.h>

@interface FlutterAdPlugin : NSObject<FlutterPlugin>
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar flutterViewController:(FlutterViewController*) controller;
- (instancetype)newInstance:(NSObject<FlutterPluginRegistrar>*)registrar flutterViewController:(FlutterViewController*) controller;
@end
