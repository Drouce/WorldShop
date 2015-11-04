@import Foundation;

#ifdef DEBUG
#define DRLog(...) NSLog(__VA_ARGS__)
#else
#define DRLog(...)
#endif

#define DRColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DRGlobalBg DRColor(230, 230, 230)

#define DRNotificationCenter [NSNotificationCenter defaultCenter]

extern NSString *const DRCityDidSelectNotification;
extern NSString *const DRSelectCity;

extern NSString *const DRSortDidChangeNotification;
extern NSString *const DRSelectSort;

extern NSString *const DRCategoryDidChangeNotification;
extern NSString *const DRSelectCategory;
extern NSString *const DRSelectSubCategory;

extern NSString *const DRRegionDidChangeNotification;
extern NSString *const DRSelectRegion;
extern NSString *const DRSelectSubRegion;

extern NSString *const DRCollectStateDidChangeNotification;
extern NSString *const DRIsCollectKey;
extern NSString *const DRCollectDealKey;