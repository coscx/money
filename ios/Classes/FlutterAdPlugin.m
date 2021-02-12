#import "FlutterAdPlugin.h"
#if __has_include(<flutter_ad_plugin/flutter_ad_plugin-Swift.h>)
#import <flutter_ad_plugin/flutter_ad_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_ad_plugin-Swift.h"
#endif

@implementation FlutterAdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAdPlugin registerWithRegistrar:registrar];
}
@end
