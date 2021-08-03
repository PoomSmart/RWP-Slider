#import <CoreGraphics/CoreGraphics.h>

extern CGFloat kMADisplayFilterPrefReduceWhitePointIntensityMax;
extern CGFloat kMADisplayFilterPrefReduceWhitePointIntensityMin;

extern void MADisplayFilterPrefSetReduceWhitePointIntensity(CGFloat intenity);
extern CGFloat MADisplayFilterPrefGetReduceWhitePointIntensity();

extern BOOL _AXSReduceWhitePointEnabled();

%hook CCUIDisplayModuleViewController

- (float)_backlightLevel {
    return _AXSReduceWhitePointEnabled() ? kMADisplayFilterPrefReduceWhitePointIntensityMax - MADisplayFilterPrefGetReduceWhitePointIntensity() + kMADisplayFilterPrefReduceWhitePointIntensityMin : %orig;
}

- (void)_setBacklightLevel:(float)level {
    if (_AXSReduceWhitePointEnabled())
        MADisplayFilterPrefSetReduceWhitePointIntensity(kMADisplayFilterPrefReduceWhitePointIntensityMax - level + kMADisplayFilterPrefReduceWhitePointIntensityMin);
    else
        %orig;
}

%end

static void ScreenBrightnessDidChange() {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification object:UIScreen.mainScreen];
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if ([((__bridge NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"CCUIDisplayModuleViewController"]) {
        %init;
    }
}
 
%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, notificationCallback, (CFStringRef)NSBundleDidLoadNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)ScreenBrightnessDidChange, CFSTR("com.apple.mediaaccessibility.displayFilterSettingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}