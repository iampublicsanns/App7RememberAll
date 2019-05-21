//
//  Config.h
//  App7RememberAll
//
//  Created by Alexander on 10/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef Config_h
#define Config_h

static NSString * const ConfigApiKey = @"";
static NSString * const ConfigUserId = @"";
static NSString * const ConfigPhotosUrl = @"https://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=%@&user_id=%@&format=json&nojsoncallback=1&per_page=1000";
static NSString * const ConfigThumbnailSuffix = @"m";
static NSString * const ConfigBigImageSuffix = @"b";

#endif /* Config_h */
