//
//  ASRGalleryViewControllerTests.m
//  App7RememberAllTests
//
//  Created by Alexander on 31/05/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "ASRDataManager.h"
#import "ASRPreviewViewController.h"

@interface ASRPreviewViewController (Tests)

@property (nonatomic, nullable, strong) ASRDataManager *dataManager;

@end


@interface ASRPreviewViewControllerTests : XCTestCase

@end

@implementation ASRPreviewViewControllerTests

- (void)testInit
{
	// arrange
	id dataManagerMock = OCMClassMock([ASRDataManager class]);

	// act
	ASRPreviewViewController *previewViewController = [[ASRPreviewViewController alloc] initWithDataManager:dataManagerMock];

	// verify
	XCTAssertEqual(previewViewController.dataManager, dataManagerMock);
}

- (void)testShowImageWithUrlString
{
	// arrange
	id dataManagerMock = OCMClassMock([ASRDataManager class]);
	OCMExpect([dataManagerMock tryGetCachedImage:[OCMArg isNotNil]]);
	OCMExpect([dataManagerMock loadBigImageByUrl:[OCMArg any] completion:[OCMArg any]]);
	
	ASRPreviewViewController *previewViewController = [[ASRPreviewViewController alloc] initWithDataManager:dataManagerMock];

	// act
	[previewViewController showImageWithUrlString:@"http://someurl.com"];

	// verify
	OCMVerifyAll(dataManagerMock);
}

@end
