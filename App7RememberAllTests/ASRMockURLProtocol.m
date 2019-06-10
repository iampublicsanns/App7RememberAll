//
//  ASRMockURLProtocol.m
//  App7RememberAllTests
//
//  Created by Alexander on 04/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "ASRMockURLProtocol.h"


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
	if (!ASRMockURLProtocol.requestHandler)
	{
		return;
	}

	ASRMockURLProtocol.requestHandler(self.request, ^void(NSHTTPURLResponse *response, NSData *data) {
		[self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
		[self.client URLProtocol:self didLoadData:data];
		[self.client URLProtocolDidFinishLoading:self];
	});
}

- (void)stopLoading
{
//	[super stopLoading];
}

@end
