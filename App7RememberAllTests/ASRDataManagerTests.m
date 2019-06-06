//
//  ASR ASRDataManagerTests.m
//  App7RememberAllTests
//
//  Created by Alexander on 31/05/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

//@import OCMock;
//#import "OCMock.h"
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DataManager.h"
#import "ASRMockURLProtocol.h"


@interface DataManager (Tests)

@property (nonatomic, nullable, strong) NSCache<NSString *, NSData *> *imagesCache;
@property (nonatomic, strong) NSURLSession *session;

@end


@interface ASRDataManagerTests : XCTestCase

@end


@implementation ASRDataManagerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
	
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInit
{
	// arrange
	NSCache *imagesCache = OCMPartialMock([NSCache new]);
	
	// act
	DataManager *dataManager = [[DataManager alloc] initWithCache:imagesCache];
	
	// verify
	//expect(dataManager.cache).to.equal(cache);
	XCTAssertEqual(dataManager.imagesCache, imagesCache);

	
	
//	id mockClassB = OCMClassMock([DataManager class]);
//	NSString *notificationName = @"notification name";
//	NSNotification *notification = [NSNotification notificationWithName:notificationName
//																															 object:mockClassB];
//	NSString *expectedInfo = @"info";
//	OCMStub([mockClassB loadImageByUrl: completion:<#^(NSData * _Nullable image)completion#>]).andReturn(expectedInfo);
//
//	OCMStub([mockClassB postNotification]).andPost(notification);
//
//
//	id userDefaultsMock = OCMClassMock([NSUserDefaults class]);
//
//	id mockObserver = OCMObserverMock();
//	[[NSNotificationCenter defaultCenter] addMockObserver:mockObserver
//																									 name:notificationName
//																								 object:mockClassB];
}

- (void)testLoadCatalogueWithCompletion
{
	// arrange
	NSCache *imagesCache = OCMPartialMock([NSCache new]);
	DataManager *dataManager = [[DataManager alloc] initWithCache:imagesCache];
	
	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	config.timeoutIntervalForRequest = 1;
	NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

	id sessionMock = OCMPartialMock(session);
	OCMExpect([sessionMock dataTaskWithURL:[OCMArg any] completionHandler:[OCMArg any]]).andForwardToRealObject();
	
	dataManager.session = sessionMock;
	
	// act
	XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"response"];
	
	[dataManager loadCatalogueWithCompletion:^(NSArray<NSDictionary *> * _Nullable data) {
		NSLog(@"something loaded");
		[expectation fulfill];
	}];
	
	// verify
	OCMVerifyAll(sessionMock);
	[self waitForExpectations:@[expectation] timeout:1];
}

- (void)testLoadBigImageByUrl
{
	// arrange

	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	config.protocolClasses = @[[ASRMockURLProtocol class]];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

	id sessionMock = OCMPartialMock(session);
	OCMExpect([sessionMock dataTaskWithURL:[OCMArg any] completionHandler:[OCMArg any]]).andForwardToRealObject();

	NSCache *imagesCache = OCMPartialMock([NSCache new]);
	DataManager *dataManager = [[DataManager alloc] initWithCache:imagesCache];
	dataManager.session = session;

	NSString *imageUrl = @"http://someurl.com";
	id imageOnServer = [@"asdf" dataUsingEncoding:NSUTF8StringEncoding];

	XCTestExpectation *expectationMock = [[XCTestExpectation alloc] initWithDescription:@"mock protocol responded"];

	ASRMockURLProtocol.requestHandler = ^(NSURLRequest * _Nullable request, ResponseCallback _Nullable responseCallback) {
		XCTAssertTrue([request.URL.host containsString:@"someurl"]);

		responseCallback(
			[[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil],
			imageOnServer
		);

		[expectationMock fulfill];
	};

	// act
	XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"data manager responded"];

	[dataManager loadBigImageByUrl:imageUrl completion:^(NSData *image) {
		//must be returned in callback
		XCTAssertEqualObjects(image, imageOnServer);

		// must lay in cache
		NSData *imageFromCache = [imagesCache objectForKey:imageUrl];
		XCTAssertEqualObjects(imageFromCache, imageOnServer);

		// must be available via public method
		NSData *imageFromTryGetCachedImage = [dataManager tryGetCachedImage:imageUrl];
		XCTAssertEqual(imageFromCache, imageFromTryGetCachedImage);

		[expectation fulfill];
	}];

	// verify
	
	// must be nil in cache
	NSData *imageFromCache = [imagesCache objectForKey:imageUrl];
	XCTAssertNil(imageFromCache);
	
	[self waitForExpectations:@[expectation, expectationMock] timeout:1];
	OCMVerifyAll(sessionMock);
}

- (void)testLoadImageByUrl
{
	// arrange

	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	config.protocolClasses = @[[ASRMockURLProtocol class]];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

	id sessionMock = OCMPartialMock(session);
	OCMExpect([sessionMock dataTaskWithURL:[OCMArg any] completionHandler:[OCMArg any]]).andForwardToRealObject();
	
	NSCache *imagesCache = OCMPartialMock([NSCache new]);
	DataManager *dataManager = [[DataManager alloc] initWithCache:imagesCache];
	dataManager.session = session;
	
	NSString *imageUrl = @"http://someurl.com";
	//id imageOnServer = OCMClassMock([NSData class]); // равен [NSData new]
	id imageOnServer = [@"asdf" dataUsingEncoding:NSUTF8StringEncoding];
	
	XCTestExpectation *expectationMock = [[XCTestExpectation alloc] initWithDescription:@"mock protocol responded"];
	
	ASRMockURLProtocol.requestHandler = ^(NSURLRequest * _Nullable request, ResponseCallback _Nullable responseCallback) {
		XCTAssertTrue([request.URL.host containsString:@"someurl"]);
		
		responseCallback(
										 [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil],
										 imageOnServer
//										 [NSData new]
//										 [@"asdf" dataUsingEncoding:NSUTF8StringEncoding]
										 );
		
		[expectationMock fulfill];
	};
	
	// act
	XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"data manager responded"];

	[dataManager loadImageByUrl:imageUrl completion:^(NSData *image) {
		//must be returned in callback
		XCTAssertEqualObjects(image, imageOnServer);

		// must lay in cache
		NSData *imageFromCache = [imagesCache objectForKey:imageUrl];
		XCTAssertEqualObjects(imageFromCache, imageOnServer);

		// must be available via public method
		NSData *imageFromTryGetCachedImage = [dataManager tryGetCachedImage:imageUrl];
		XCTAssertEqual(imageFromCache, imageFromTryGetCachedImage);

		[expectation fulfill];
	}];

	// verify
	OCMVerifyAll(sessionMock);

	// must be nil in cache
	NSData *imageFromCache = [imagesCache objectForKey:imageUrl];
	XCTAssertNil(imageFromCache);

	[self waitForExpectations:@[expectation, expectationMock] timeout:1];
}

- (void)testHandleGetPublicPhotosJSON
{
	NSString *jsonString = @"{\"photos\":\
	{\"page\":1,\"pages\":35,\"perpage\":300,\"total\":\"10229\",\
	\"photo\":[\
	{\"id\":\"14131308870\",\"owner\":\"12037949754@N01\",\"secret\":\"8c5910f1b2\",\"server\":\"3791\",\"farm\":4,\"title\":\"Risk legacy campaign completed\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},\
	{\"id\":\"10305022715\",\"owner\":\"12037949754@N01\",\"secret\":\"75bffa38fb\",\"server\":\"5520\",\"farm\":6,\"title\":\"SoO\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0}\
	]},\
	\"stat\":\"ok\"}";

	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	NSError *parseErr;
	id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&parseErr];

	// act
	NSArray<NSDictionary *> *images = [DataManager handleGetPublicPhotosJSON:json];

	// verify
	
	NSString *imageId = images[0][@"id"];
	NSString *server = images[0][@"server"];
	NSString *secret = images[0][@"secret"];
	NSNumber *farm = images[0][@"farm"];

	XCTAssertEqualObjects(imageId, @"14131308870");
	XCTAssertEqualObjects(server, @"3791");
	XCTAssertEqualObjects(secret, @"8c5910f1b2");
	XCTAssertEqualObjects(farm, @4);
}

- (void)testMakeUrlStringFromJSON
{
	// arrange
	
	NSString *imageId = @"imageValue";
	NSString *server = @"serverValue";
	NSString *secret = @"secretValue";
	NSNumber *farm = @44444;

	NSString *suffix = @"suffixValue";

	NSString *jsonString = [NSString stringWithFormat:@"{\"id\":\"%@\",\"owner\":\"12037949754@N01\",\"secret\":\"%@\",\"server\":\"%@\",\"farm\":%@,\"title\":\"Risk legacy campaign completed\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0}",imageId, secret, server, farm];
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	NSError *parseErr;
	id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&parseErr];

	// act
	NSString *url = [DataManager makeUrlStringFromJSON:json suffix:suffix];
	
	// verify
	NSString *expectedString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farm, server, imageId, secret, suffix];
	
	XCTAssertEqualObjects(url, expectedString);
}


@end
