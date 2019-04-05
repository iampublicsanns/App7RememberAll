//
//  ViewController.m
//  App7RememberAll
//
//  Created by Alexander on 20/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "UIView+MyDescription.h"
#import "AppDelegate.h"


@interface ViewController ()
@property (nonatomic) AppDelegate* appDelegate;
@end


@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  NSLog(@"view did load");
//  NSLog(@"%@", [[UIImage new] performSelector:@selector(myDescription)]); //no compile error
//  NSLog(@"%@", [[UIImage new] myDescription]); //has compiler error
  
  self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  [self.appDelegate createPlaceMO];
  [self.appDelegate saveContext];
  
  NSLog(@"%@", [[self.appDelegate getPlaces] description]);
}

- (void)viewWillAppear:(BOOL)animated {
  //ничего страшного, если не вызвать супер?
  [super viewWillAppear:animated];
  
  NSLog(@"view will appear");
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  NSMutableDictionary* example = [NSMutableDictionary new];
    //  [example enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//   
//  ]
  
  NSLog(@"view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  NSLog(@"view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  NSLog(@"view did disappear");
}

//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  
//}

//- (void) unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC {
//
//}
//
//- (void) unwindBla:(UIStoryboardSegue *)unwindSegue  {
//
//
//}
- (IBAction) unwindToRed:(UIStoryboardSegue*)unwindSegue {
  
}


@end
