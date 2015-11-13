//
//  AppDelegate.m
//  Gocycling
//
//  Created by Apple on 14-4-11.
//
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SubscribeDevice.h"
#import "CustomMarcos.h"
#import "UIDevice-Hardware.h"
#import "Macros.h"
#import "RootViewController.h"

@implementation AppDelegate
@synthesize deviceTokenString;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // User defaults
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[NSMutableArray alloc] init], TEMP_ORDER_CONTESTANT_LIST,
                              nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ios7navigationbarImage"]
                                           forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ios6navigationbarImage"]
                                           forBarMetrics:UIBarMetricsDefault];
    }
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"navigationshadowImage"]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];

    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbarbackimage"]];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UITabBar appearance] setTintColor:UIColorFromRGB(0.0, 137.0, 194.0)];
    }
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: UIColorFromRGB(198.0, 198.0, 198.0)}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: UIColorFromRGB(0.0, 137.0, 194.0)}
                                             forState:UIControlStateSelected];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];



    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    RootViewController* rootVC = [[RootViewController alloc] init];
    self.window.rootViewController = rootVC;
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *_deviceTokenString = [deviceToken description];
    _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceTokenString = _deviceTokenString;
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable || [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusUnknown) {
        SubscribeDevice *subscribeDevice = [[SubscribeDevice alloc] init];
        subscribeDevice.deviceToken = _deviceTokenString;
        subscribeDevice.isSubscribe = [[NSUserDefaults standardUserDefaults] boolForKey:ENABLED_ROMOTE_NOTIFICATION];
        
        dispatch_queue_t queue = dispatch_queue_create("com.doocom.SyncDeviceToken", NULL);
        dispatch_async(queue, ^{
            [subscribeDevice sync];
        });
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
