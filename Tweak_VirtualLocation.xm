#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"
#import "OCLogWriteToFile.h"

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
// 120.080372,30.287409
%hook CLLocation
-(CLLocationCoordinate2D) coordinate
{
	%orig;
    CLLocationCoordinate2D location;
    //纬度
    location.latitude = 30.287409;
    //经度
    location.longitude = 120.080372;
    // [OCShowAlertView showAlertViewWithMessage:@"经纬度"];
    return location;
}
%end

