//
//  AKSearchController.m
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import "AKFilterController.h"
#import "AKAppointmentModel.h"
#import "AKUserModel.h"

@implementation AKFilterController

- (NSArray *)searchForApptsForUsersWithSearchValue:(NSString *)aSearchValue
	inApptsArray:(NSArray *)aApptsArray usersArray:(NSArray *)aUsersArray {
	NSMutableArray *theResultArray = [NSMutableArray new];
	for (AKUserModel *theUser in aUsersArray) {
		if (!([theUser.name rangeOfString:aSearchValue
				options:NSCaseInsensitiveSearch].location == NSNotFound)
			|| !([theUser.surname rangeOfString:aSearchValue
				options:NSCaseInsensitiveSearch].location ==
				NSNotFound)) {
				for (AKAppointmentModel *theAppt in aApptsArray) {
					if (theAppt.relatedUserID == theUser.userID) {
						[theResultArray addObject:theAppt];
					}
				}
		}
	}

	return [NSArray arrayWithArray:theResultArray];
}

- (NSArray *)showOnlyConfirmedAppointmentsForApptsArray:(NSArray *)aApptsArray {
	NSMutableArray *theResultArray = [NSMutableArray new];
	for (AKAppointmentModel *theAppt in aApptsArray) {
		if (theAppt.isConfirmed) {
			[theResultArray addObject:theAppt];
		}
	}

	return [NSArray arrayWithArray:theResultArray];
}

@end
