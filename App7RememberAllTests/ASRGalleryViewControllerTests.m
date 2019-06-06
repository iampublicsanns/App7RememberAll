//
//  ASRGalleryViewControllerTests.m
//  App7RememberAllTests
//
//  Created by Alexander on 31/05/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DataManager.h"
#import "GalleryViewController.h"


@interface GalleryViewController (Tests)

@property (nonatomic, nullable, copy) NSArray<NSDictionary *> *imagesCatalogue;
@property (nonatomic, nullable, strong) DataManager *dataManager;

@end


@interface ASRGalleryViewControllerTests : XCTestCase

@end

@implementation ASRGalleryViewControllerTests

- (void)setUp
{
	// Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
	// Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testInit
{
	// arrange
	id dataManagerMock = OCMClassMock([DataManager class]);

	// act
	GalleryViewController *galleryViewController = [[GalleryViewController alloc] initWithDataManager:dataManagerMock];

	// verify
	XCTAssertEqual(galleryViewController.dataManager, dataManagerMock);

}

@end
