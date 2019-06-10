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
@property (nonatomic, nullable, strong) NSManagedObjectID *imageMOID;

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

- (void)testShowImageByMOID
{
	// arrange
	id moidMock = OCMClassMock([NSManagedObjectID class]);
	id imageDAOMock = OCMClassMock([ASRImageDAO class]);
	OCMExpect([imageDAOMock getASRMOImageByMOID:moidMock]);

	ASRDatabasePreviewViewController *previewViewController = [[ASRDatabasePreviewViewController alloc] initWithImageDAO:imageDAOMock];

	// act
	[previewViewController showImageByMOID:moidMock];

	// verify
	XCTAssertEqual(moidMock, previewViewController.imageMOID);
	OCMVerifyAll(imageDAOMock);
}

@end
