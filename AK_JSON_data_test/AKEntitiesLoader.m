//
//  AKEntitiesLoader.m
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/20/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import "AKEntitiesLoader.h"

NSString *kAKWebServiceURL = @"http://178.32.4.84:7080/TestCRM/FANetworkService.svc/GetDataFrom";

@interface AKEntitiesLoader () <NSURLSessionDelegate>

@end

@implementation AKEntitiesLoader

- (void)loadAllEntitiesWithCompletionBlock:
	(void (^)(NSData *aAppointments,NSData *AppointmentTypes,
		NSData *aUsers, NSError* error))aCompletion {
	__block NSError *appointmentsLoadError = nil;
	__block NSError *appointmentTypesLoadError = nil;
	__block NSError *usersLoadError = nil;
	__block NSData *theAppointments;
	__block NSData *theAppointmentTypes;
	__block NSData *theUsers;

	dispatch_group_t loadGroup = dispatch_group_create();

	dispatch_group_enter(loadGroup);
	NSDictionary *postDataForAppointments = @{ 
								  @"REQUEST" : @{@"FUNCTION" : @"GetDataFrom",
												 @"OBJECT" : @"Appointment",
												 @"UDID" : @"UDID1"},
								  @"CONTENT" : @{},
								  };
	[self ak_loadDataWithPostData:postDataForAppointments
		fromURL:kAKWebServiceURL completionHandler:^(NSData * _Nullable data,
			NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (nil == error) {
				theAppointments = data;
			} else {
				appointmentsLoadError = error;
			}
			dispatch_group_leave(loadGroup);
	}];

	dispatch_group_enter(loadGroup);
	NSDictionary *postDataForAppointmentTypes = @{ 
								  @"REQUEST" : @{@"FUNCTION" : @"GetDataFrom",
												 @"OBJECT" : @"AppointmentType",
												 @"UDID" : @"UDID1"},
								  @"CONTENT" : @{},
								  };
	[self ak_loadDataWithPostData:postDataForAppointmentTypes
		fromURL:kAKWebServiceURL completionHandler:^(NSData * _Nullable data,
			NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (nil == error) {
				theAppointmentTypes = data;
			} else {
				appointmentTypesLoadError = error;
			}
			dispatch_group_leave(loadGroup);
	}];

	dispatch_group_enter(loadGroup);
	NSDictionary *postDataForUsers = @{ 
								  @"REQUEST" : @{@"FUNCTION" : @"GetDataFrom",
												 @"OBJECT" : @"User",
												 @"UDID" : @"UDID1"},
								  @"CONTENT" : @{},
								  };
	[self ak_loadDataWithPostData:postDataForUsers
		fromURL:kAKWebServiceURL completionHandler:^(NSData * _Nullable data,
			NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (nil == error) {
				theUsers = data;
			} else {
				usersLoadError = error;
			}
			dispatch_group_leave(loadGroup);
	}];

	dispatch_group_notify(loadGroup,dispatch_get_main_queue(),^{
		NSError *overallError = nil;
		if (appointmentsLoadError || appointmentsLoadError || usersLoadError) {
			NSArray *errorArray =
			@[appointmentsLoadError, appointmentsLoadError, usersLoadError];
			for (NSError *theError in errorArray) {
				if (nil != theError) {
					overallError = theError;
					break;
				}
			}
		}
		aCompletion(theAppointments, theAppointmentTypes, theUsers,
			overallError);
	});
}

#pragma mark - private

- (void)ak_loadDataWithPostData:(NSDictionary *)aPostData
	fromURL:(NSString *)aURLString
	completionHandler:(void (^)(NSData * _Nullable data,
		NSURLResponse * _Nullable response,
		NSError * _Nullable error))completionHandler {
	NSError *error;

	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration
		defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
		delegate:self delegateQueue:nil];
	NSURL *url = [NSURL URLWithString:aURLString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
		cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	NSData *postData = [NSJSONSerialization dataWithJSONObject:aPostData
		options:0 error:&error];
	[request setHTTPBody:postData];

	NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
		completionHandler:completionHandler];

	[postDataTask resume];	
}

@end
