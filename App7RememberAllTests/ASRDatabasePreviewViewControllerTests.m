//
//  ASRDatabasePreviewViewControllerTests.m
//  App7RememberAllTests
//
//  Created by Alexander on 10/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "ASRDatabasePreviewViewController.h"
#import "ASRImageDAO.h"


@interface ASRDatabasePreviewViewController (Tests)

@property (nonatomic, nullable, strong) ASRImageDAO *imageDAO;

@end


@interface ASRDatabasePreviewViewControllerTests : XCTestCase

@end

@implementation ASRDatabasePreviewViewControllerTests

- (void)testInit
{
	// arrange
	id imageDAOMock = OCMClassMock([ASRImageDAO class]);
	
	// act
	ASRDatabasePreviewViewController *previewViewController = [[ASRDatabasePreviewViewController alloc] initWithImageDAO:imageDAOMock];
	
	// verify
	XCTAssertEqual(previewViewController.imageDAO, imageDAOMock);
}

//- (void)testShowImageWithUrlString
//{
//	// arrange
//	id dataManagerMock = OCMClassMock([ASRDataManager class]);
//	OCMExpect([dataManagerMock tryGetCachedImage:[OCMArg isNotNil]]);
//	OCMExpect([dataManagerMock loadBigImageByUrl:[OCMArg any] completion:[OCMArg any]]);
//
//	ASRDatabasePreviewViewController *previewViewController = [[ASRDatabasePreviewViewController alloc] initWithDataManager:dataManagerMock];
//
//	// act
//	[previewViewController showImageWithUrlString:@"http://someurl.com"];
//
//	// verify
//	OCMVerifyAll(dataManagerMock);
//
//	OCMExpect([dataManagerMock tryGetCachedImage:[OCMArg isNotNil]]);
//	OCMReject([dataManagerMock loadBigImageByUrl:[OCMArg any] completion:[OCMArg any]]);
//
//	// act2
//	[previewViewController showImageWithUrlString:@"http://someurl.com"];
//
//	// verify
//	OCMVerifyAll(dataManagerMock);
//}

@end
