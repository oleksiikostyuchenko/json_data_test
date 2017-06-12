//
//  AKUser.h
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AKUserModel : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userPictureURL;

@end
