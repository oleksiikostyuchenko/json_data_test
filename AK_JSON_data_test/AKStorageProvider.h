//
//  AKStorageProvider.h
//  AK_test_app
//
//  Created by Alexey Kostyuchenko on 4/1/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AKStorageProvider : NSObject

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

+(AKStorageProvider *)sharedInstance;
- (BOOL)saveContext;

@end
