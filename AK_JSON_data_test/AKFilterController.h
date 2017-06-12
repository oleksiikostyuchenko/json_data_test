//
//  AKSearchController.h
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKFilterController : NSObject

- (NSArray *)searchForApptsForUsersWithSearchValue:(NSString *)aSearchValue
	inApptsArray:(NSArray *)aApptsArray usersArray:(NSArray *)aUsersArray;
- (NSArray *)showOnlyConfirmedAppointmentsForApptsArray:(NSArray *)aApptsArray;

@end
