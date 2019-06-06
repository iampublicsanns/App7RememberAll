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
#import "PreviewViewController.h"

@interface PreviewViewController (Tests)

@property (nonatomic, nullable, strong) DataManager *dataManager;

@end


@interface ASRPreviewViewControllerTests : XCTestCase

@end

@implementation ASRPreviewViewControllerTests

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
	PreviewViewController *previewViewController = [[PreviewViewController alloc] initWithDataManager:dataManagerMock];

	// verify
	XCTAssertEqual(previewViewController.dataManager, dataManagerMock);
}

- (void)testShowImageWithUrlString
{
	// arrange
	id dataManagerMock = OCMClassMock([DataManager class]);
	OCMExpect([dataManagerMock tryGetCachedImage:[OCMArg isNotNil]]);
	OCMExpect([dataManagerMock loadBigImageByUrl:[OCMArg any] completion:[OCMArg any]]);
	
	PreviewViewController *previewViewController = [[PreviewViewController alloc] initWithDataManager:dataManagerMock];

	// act
	[previewViewController showImageWithUrlString:@"http://someurl.com"];

	// verify
	OCMVerifyAll(dataManagerMock);
}

@end
