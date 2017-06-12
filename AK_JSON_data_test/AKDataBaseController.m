//
//  AKDataBaseController.m
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import "AKStorageProvider.h"
#import "AKAppointmentModel.h"
#import "AKAppointmentTypeModel.h"
#import "AKUserModel.h"
#import "AKDataBaseController.h"
#import "NSDate+AKNSDateExtension.h"

@implementation AKDataBaseController

- (void)addDataToDBWithAppointments:(NSData *)aAppointmentsData
	appointmentTypes:(NSData *)aAppointmentTypesData users:(NSData *)aUsersData
	completion:(void (^)(NSError *error))aCompletion {
	NSDictionary *theAppointments = [self ak_parseJSONData:aAppointmentsData];
	NSDictionary *theAppointmentTypes = [self
		ak_parseJSONData:aAppointmentTypesData];
	NSDictionary *theUsers = [self ak_parseJSONData:aUsersData];

	[self ak_addApptsWithDictionary:theAppointments];
	[self ak_addApptsTypesWithDictionary:theAppointmentTypes];
	[self ak_addUsersWithDictionary:theUsers];

	if ([self.storageProvider saveContext]) {
		aCompletion(nil);
	} else {
		NSError *theError = [[NSError alloc] initWithDomain:@"Error" code:1
			userInfo:@{@"Error" : @"Unable to save context"}];
		aCompletion(theError);
	}
}

- (BOOL)isDBEmpty {
	NSArray *theAppointmentsArray =
	[self ak_retrieveObjectsForEntityName:@"AKAppointment"];
	NSArray *theAppointmentTypesArray = 
	[self ak_retrieveObjectsForEntityName:@"AKAppointmentType"];
	NSArray *theUsersArray =
	[self ak_retrieveObjectsForEntityName:@"AKUser"];
	return ([theAppointmentsArray count] == 0 &&
			[theAppointmentTypesArray count] == 0 &&
			[theUsersArray count] == 0) ? YES : NO;
}

- (BOOL)eraseDBEnteties {
	NSFetchRequest *appointmentsDeleteRequest = [[NSFetchRequest alloc]
		initWithEntityName:@"AKAppointment"];
	NSFetchRequest *appointmentTypesDeleteRequest = [[NSFetchRequest alloc]
		initWithEntityName:@"AKAppointmentType"];
	NSFetchRequest *usersDeleteRequest = [[NSFetchRequest alloc] 
		initWithEntityName:@"AKUser"];

	NSBatchDeleteRequest *deleteApptsBatchRequest =
	[[NSBatchDeleteRequest alloc]
		initWithFetchRequest:appointmentsDeleteRequest];
	NSBatchDeleteRequest *deleteApptTypesBatchRequest =
	[[NSBatchDeleteRequest alloc]
		initWithFetchRequest:appointmentTypesDeleteRequest];
	NSBatchDeleteRequest *deleteUsersBatchRequest =
	[[NSBatchDeleteRequest alloc] initWithFetchRequest:usersDeleteRequest];

	NSError *deleteApptsError = nil;
	NSError *deleteApptTypesError = nil;
	NSError *deleteUsersError = nil;
	[self.storageProvider.persistentContainer.persistentStoreCoordinator
		executeRequest:deleteApptsBatchRequest
		withContext:self.storageProvider.persistentContainer.viewContext
		error:&deleteApptsError];
	[self.storageProvider.persistentContainer.persistentStoreCoordinator
		executeRequest:deleteApptTypesBatchRequest
		withContext:self.storageProvider.persistentContainer.viewContext
		error:&deleteApptTypesError];
	[self.storageProvider.persistentContainer.persistentStoreCoordinator
		executeRequest:deleteUsersBatchRequest
		withContext:self.storageProvider.persistentContainer.viewContext
		error:&deleteUsersError];
	
	if (deleteApptsError || deleteApptTypesError || deleteUsersError) {
		NSArray *errorArray =
		@[deleteApptsError, deleteApptTypesError, deleteUsersError];
		for (NSError *theError in errorArray) {
			if (nil != theError) {
				NSLog(@"Unresolved error %@, %@", theError, theError.userInfo);
			}
		}
		abort();
	}

	return [self.storageProvider saveContext];
}

- (void)loadAllEntetiesFromDBWithCompletion:
	(void (^)(NSArray *aAppts, NSArray *aApptsTypes,
		NSArray *aUsers))aCompletion {
	NSArray *theAppts = [self ak_retrieveObjectsForEntityName:@"AKAppointment"];
	NSArray *theApptsTypes = [self ak_retrieveObjectsForEntityName:@"AKAppointmentType"];
	NSArray *theUsers = [self ak_retrieveObjectsForEntityName:@"AKUser"];
	aCompletion (theAppts, theApptsTypes, theUsers);
}

#pragma mark - private

- (NSArray *)ak_retrieveObjectsForEntityName:(NSString *)aName {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:aName];

	NSError *error = nil;
	NSArray *results = [self.storageProvider.persistentContainer.viewContext
		executeFetchRequest:request error:&error];
	if (error != nil) {
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
		abort();
	}

	return results;
}

#pragma mark - add Dictionaries to DB

- (void)ak_addApptsWithDictionary:(NSDictionary *)aAppts {
	NSDictionary *theAppts = [[aAppts valueForKey:@"CONTENT"]
		valueForKey:@"TABLE_DATA"];
	for (NSDictionary *theAppt in theAppts) {
		[self ak_addApptToDBWithoutSavingContextWithID:[theAppt valueForKey:@"Id"]
			typeID:[theAppt valueForKey:@"TypeId"]
			subject:[theAppt valueForKey:@"Subject"]
			details:[theAppt valueForKey:@"Details"]
			startDate:[NSDate dateWithString:[theAppt valueForKey:@"StartDate"]]
			endDate:[NSDate dateWithString:[theAppt valueForKey:@"EndDate"]]
			userID:[theAppt valueForKey:@"RelatedUserId"]
		    isConfirmed:[[theAppt valueForKey:@"IsConfirmed"] boolValue]];
	}
}

- (void)ak_addApptsTypesWithDictionary:(NSDictionary *)aApptsTypes {
	NSDictionary *theAppts = [[aApptsTypes valueForKey:@"CONTENT"]
		valueForKey:@"TABLE_DATA"];
	for (NSDictionary *theApptType in theAppts) {
		[self ak_addApptTypeToDBWithoutSavingContextWithID:[theApptType valueForKey:@"Id"]
			appointmentType:[theApptType valueForKey:@"Type"]
			appointmentDescription:[theApptType valueForKey:@"Description"]];
	}
}

- (void)ak_addUsersWithDictionary:(NSDictionary *)aUsers {
	NSDictionary *theUsers = [[aUsers valueForKey:@"CONTENT"]
		valueForKey:@"TABLE_DATA"];
	for (NSDictionary *theUser in theUsers) {
		[self ak_addUserToDBWithoutSavingContextWithUserID:[theUser valueForKey:@"Id"]
			name:[theUser valueForKey:@"Name"]
			surname:[theUser valueForKey:@"Surname"]
			imageLinkString:[theUser valueForKey:@"UserPictureUrl"]];
	}
}

#pragma mark - add entity to DB

- (void)ak_addApptTypeToDBWithoutSavingContextWithID:
	(NSString *)aAppointmentTypeID
	appointmentType:(NSString *)aAppointmentType
	appointmentDescription:(NSString *)aAppointmentDescription {
	AKAppointmentTypeModel *theApptType = [NSEntityDescription
		insertNewObjectForEntityForName:@"AKAppointmentType"
		inManagedObjectContext:
			self.storageProvider.persistentContainer.viewContext];
	theApptType.appointmentDescription = aAppointmentDescription;
	theApptType.appointmentID = aAppointmentTypeID;
	theApptType.appointmentType = aAppointmentType;
}

- (void)ak_addApptToDBWithoutSavingContextWithID:(NSString *)aApptID
	typeID:(NSString *)aApptTypeID subject:(NSString *)aApptSubject
	details:(NSString *)aApptDetails startDate:(NSDate *)aApptStartDate
	endDate:(NSDate *)aApptEndDate userID:(NSString *)aUserID
	isConfirmed:(BOOL)aApptIsConfirmed {
	AKAppointmentModel *theAppt = [NSEntityDescription
		insertNewObjectForEntityForName:@"AKAppointment"
		inManagedObjectContext:
		self.storageProvider.persistentContainer.viewContext];
	theAppt.appointmentID = aApptID;
	theAppt.appointmentType = aApptTypeID;
	theAppt.appointmentDetails = aApptDetails;
	theAppt.appointmentSubject = aApptSubject;
	theAppt.appointmentStartDate = aApptStartDate;
	theAppt.appointmentEndDate = aApptEndDate;
	theAppt.relatedUserID = aUserID;
	theAppt.isConfirmed = aApptIsConfirmed;
}

- (void)ak_addUserToDBWithoutSavingContextWithUserID:(NSString *)aUserID
	name:(NSString *)aUserName surname:(NSString *)aUserSurname
	imageLinkString:(NSString *)aURLString{
	AKUserModel *theUser = [NSEntityDescription
		insertNewObjectForEntityForName:@"AKUser"
		inManagedObjectContext:
		self.storageProvider.persistentContainer.viewContext];
	theUser.userID = aUserID;
	theUser.name = aUserName;
	theUser.surname = aUserSurname;
	theUser.userPictureURL = aURLString;
}

- (NSDictionary *)ak_parseJSONData:(NSData *)aData {
	NSError *theParsingError = nil;
	NSDictionary *theParsedDict = nil;
	theParsedDict = [NSJSONSerialization JSONObjectWithData:aData
		options:0 error:&theParsingError];
	if (theParsingError) {
		NSLog(@"%@", theParsingError.localizedDescription);
	}

	return theParsedDict;
}

- (AKStorageProvider *)storageProvider {
	return [AKStorageProvider sharedInstance];
}

@end
