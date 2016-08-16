//
//  HXSBoxQuestionnaire.h
//  
//
//  Created by hudezhi on 15/9/22.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSBox;

@interface HXSBoxQuestionnaire : NSManagedObject

@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *questionnaireUrl;
@property (nonatomic, retain) HXSBox *box;

// Insert code here to declare functionality of your managed object subclass

@end
