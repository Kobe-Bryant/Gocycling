//
//  RootViewController.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-11.
//
//

#define MASK_VIEW_TAG 11

#import "RootViewController.h"
#import "MainViewController.h"
#import "FilterViewController.h"
#import "CustomMarcos.h"
#import "Macros.h"
#import "DetailViewController.h"
//#import "NewGoodsViewController.h"

@interface RootViewController ()

@property (nonatomic) BOOL isViewWillAppeared;
@property (nonatomic, retain) IIViewDeckController *viewDeckController;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDeckEnabled:)
                                                 name:ENABLED_VIEW_DECK_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDeckDisabled:)
                                                 name:DISABLED_VIEW_DECK_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toggleFilterSidebar:)
                                                 name:TOGGLE_FILTER_SIDEBR_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterFullScreenChanged:)
                                                 name:FILTER_SIDEBAR_FULL_SCREEN_CHANGED_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterNormalScreenChanged:)
                                                 name:FILTER_SIDEBAR_NORMAL_SCREEN_CHANGED_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushProduct:)
                                                 name:PUSH_PRODUCT_NOTIFICATION
                                               object:nil];
 
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if (!self.isViewWillAppeared) {
        self.isViewWillAppeared = YES;
    } else {
        return;
    }
    
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
//    UINavigationController *centerViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    FilterViewController *rightViewController = [[FilterViewController alloc] init];
    self.viewDeckController =  [[IIViewDeckController alloc] initWithCenterViewController:mainViewController
                                                                       leftViewController:nil
                                                                      rightViewController:rightViewController];
    self.viewDeckController.view.frame = CGRectMake(0.0,
                                                    0.0,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height);
    self.viewDeckController.rightSize = self.view.frame.size.width - FILTER_SIDEBAR_WIDTH;
    self.viewDeckController.delegate = self;
    [self.view addSubview:self.viewDeckController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)viewDeckEnabled:(NSNotification *)notification
{
    NSLog(@"viewDeckEnabled %@", notification);
    self.viewDeckController.enabled = YES;
}

- (void)viewDeckDisabled:(NSNotification *)notification
{
    NSLog(@"viewDeckDisabled %@", notification);
    self.viewDeckController.enabled = NO;
}


- (void)toggleFilterSidebar:(NSNotification *)notification
{
    NSLog(@"toggleFilterSidebar %@", notification);
    LOG(@"toggleFilterSidebar %@", notification);

    [_viewDeckController toggleRightViewAnimated:YES];
}

- (void)filterSidebarDidOpened:(NSNotification *)notification
{
    NSLog(@"filterSidebarDidOpened %@", notification);
}

- (void)filterSidebarDidClosed:(NSNotification *)notification
{
    NSLog(@"filterSidebarDidClosed %@", notification);
    
}

- (void)filterFullScreenChanged:(NSNotification *)notification
{
    NSLog(@"filterFullScreenChanged %@", notification);

    [self.viewDeckController setRightSize:0.0 completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)filterNormalScreenChanged:(NSNotification *)notification
{
    NSLog(@"filterNormalScreenChanged %@", notification);
    
    [self.viewDeckController setRightSize:(self.view.frame.size.width - FILTER_SIDEBAR_WIDTH) completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)pushProduct:(NSNotification *)notification
{
    NSLog(@"pushProduct %@", notification);
//    [self.viewDeckController closeRightViewAnimated:NO];
    
    [self.viewDeckController closeRightViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        if (success) {
//            NSLog(@"success");
    
//            NSNumber *productID = [[notification object] objectForKey:PRODUCT_ID];
//            NSLog(@"productID %@", productID);
//            DetailViewController *productVC = [[DetailViewController alloc] initWithProductID:productID];
//            [controller.centerController.navigationController pushViewController:productVC animated:YES];
//            UIViewController *testVC = [[UIViewController alloc] init];
//            [self.viewDeckController rightViewPushViewControllerOverCenterController:productVC];


//            [controller.centerController.navigationController pushViewController:testVC animated:YES];

        }
    }];
    
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    NSLog(@"didOpenViewSide");
    
    if (viewDeckSide == IIViewDeckRightSide) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = CGRectMake(0.0,
                                    0.0,
                                    self.viewDeckController.centerController.view.frame.size.width,
                                    self.viewDeckController.centerController.view.frame.size.height);
        maskView.tag = MASK_VIEW_TAG;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(toggleFilterSidebar:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [maskView addGestureRecognizer:tap];
        
        [viewDeckController.centerController.view addSubview:maskView];
    }
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    NSLog(@"didCloseViewSide");
    
    for (UIView *subview in viewDeckController.centerController.view.subviews) {
        if (subview.tag == MASK_VIEW_TAG) {
            [subview removeFromSuperview];
        }
    }
}

@end
