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
#import "GalleryVC.h"


@interface ViewController ()
@property (nonatomic) AppDelegate* appDelegate;
@end


@implementation ViewController
{
  UIViewController *gallery;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"view did load");

  [self presentGallery];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  NSLog(@"view will appear");
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];

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




- (void) presentGallery {
  
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

  GalleryVC *collectionVC = [[GalleryVC alloc]
                             initWithCollectionViewLayout:flowLayout
                             ];
  collectionVC.view.layer.opacity = 0.8;
  collectionVC.collectionView.layer.opacity = 0.8;
  collectionVC.clearsSelectionOnViewWillAppear = NO;
  
  
  NSLog(@"123 -- %@", collectionVC.collectionView);

  //The layout object is stored in the collectionViewLayout property. Setting this property directly updates the layout immediately, without animating the changes.
  NSLog(@"%@", collectionVC.collectionView.collectionViewLayout.description);
  
  //[self presentViewController:collectionVC animated:YES completion:nil];
  [self.navigationController pushViewController:collectionVC animated:YES];
}


@end
