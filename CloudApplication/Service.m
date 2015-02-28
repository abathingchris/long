#import "Service.h"

@implementation Service

+ (NSString *)sayHello {
  return @"hello";
}

+ (NSNumber*)sumOf:(NSNumber*)a and:(NSNumber*)b
{
  return @(a.integerValue + b.integerValue);
}

+ (NSArray *)user
{
  return @[@"chris", @"ami", @"yvonne", @"melissa"];
}
@end
