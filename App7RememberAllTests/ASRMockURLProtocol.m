//
//  ASRMockURLProtocol.m
//  App7RememberAllTests
//
//  Created by Alexander on 04/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "ASRMockURLProtocol.h"
#import <XCTest/XCTest.h>


@implementation ASRMockURLProtocol

static RequestHandler _requestHandler;

+ (void)setRequestHandler:(RequestHandler)requestHandler
{
	_requestHandler = requestHandler;
}

+ (RequestHandler)requestHandler
{
	return _requestHandler;
}


+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
	return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
	return request;
}

- (void)startLoading
{
	if (!ASRMockURLProtocol.requestHandler) {
		XCTFail(@"No request handler");
		return;
	}

	ASRMockURLProtocol.requestHandler(self.request, ^void(NSHTTPURLResponse *response, NSData *data){
		[self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
		[self.client URLProtocol:self didLoadData:data];
		[self.client URLProtocolDidFinishLoading:self];
		//[self.client URLProtocol:<#(nonnull NSURLProtocol *)#> didFailWithError:<#(nonnull NSError *)#>]
	});
	
	
	
//	[self handleRequest: self.request withBlock:^(NSHTTPURLResponse *response, NSData *data) {
//		[self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//		[self.client URLProtocol:self didLoadData:data];
//		[self.client URLProtocolDidFinishLoading:self];
//		//[self.client URLProtocol:<#(nonnull NSURLProtocol *)#> didFailWithError:<#(nonnull NSError *)#>]
//
//	}];
}

- (void)stopLoading
{
//	[super stopLoading];
}

- (void)handleRequest: (NSURLRequest*)request
						withBlock: (void(^)(NSHTTPURLResponse *response, NSData *data))responseCallback
{
	XCTAssertTrue([request.URL.host containsString:@"someurl"]);
	
	responseCallback([[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:@(200) HTTPVersion:@"HTTP/1.1" headerFields:nil], [NSData new]);
}

@end
