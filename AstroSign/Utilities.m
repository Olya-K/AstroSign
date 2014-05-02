//
//  SocketComm.m
//  AstroSign
//
//  Created by Olga on 3/25/2014.
//
//


/**  © 2014, Olga K. All Rights Reserved.
 *
 *  This file is part of the AstroSign project.
 *  You may use this file only for your personal, and non-commercial use.
 *  You may not modify or use the contents of this file for any purpose (other
 *  than as specified above) without the express written consent of the author.
 *  You may not reproduce, republish, post, transmit, publicly display,
 *  publicly perform, or distribute in print or electronically any of the contents
 *  of this file without express consent of rightful owner.
 *  This notice must be retained in all files and may not be removed.
 *  This License is subject to change at any time without notice/warning.
 *
 *						Author : Olga K.
 *						Contact: Olga.K@live.ca
 */

#import "Utilities.h"

@implementation Utilities

-(NSString*) GetPage:(NSString*)stringURL
{
    NSURL* url = [NSURL URLWithString: stringURL];
    NSData* data = [NSData dataWithContentsOfURL: url];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(UIImage*) GetImage:(NSString *)imageURL
{
    NSURL* url = [NSURL URLWithString:imageURL];
    NSData* data = [NSData dataWithContentsOfURL: url];
    return [[UIImage alloc]initWithData:data];
}

-(bool) ImageExists:(NSString*) imageName
{
    NSArray* arr = [self Horoscopes];
    for (NSString* str in arr)
    {
        if ([str isEqualToString:imageName])
        {
            return true;
        }
    }
    return false;
}

-(UIImage*) LoadImage:(NSString*)imageName
{
    return [UIImage imageNamed:imageName];
}

-(void) SaveImage:(NSString*)imageName withImage:(UIImage*)img
{
    NSString* imagePath = [[self GetDocumentsPath] stringByAppendingPathComponent: imageName];
    [UIImagePNGRepresentation(img) writeToFile:imagePath atomically:YES];
}


-(NSString*) GetDocumentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) objectAtIndex: 0];
}

-(NSMutableArray*) LoadHoroscopeImages
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSArray* names = [self Horoscopes];
    
    for (NSString* str in names)
    {
        UIImage* img = [self LoadImage: str];
        [array addObject: img];
    }
    return array;
}

-(NSString*) GetHoroscopeInfo:(NSString*)sign
{
    NSString* stringURL = [NSString stringWithFormat: @"http://my.horoscope.com/astrology/free-daily-horoscope-%@.html", sign];
    
    NSString* page = [self GetPage: stringURL];
    
    NSString* pattern = @"<div class=\"fontdef1\" style=\"padding-right:10px;\" id=\"textline\">(.*?)</div>";
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    NSTextCheckingResult* match = [regex firstMatchInString:page options:0 range:NSMakeRange(0, [page length])];
    if (match != nil)
    {
        return [page substringWithRange:[match rangeAtIndex:1]];
    }
    
    return nil;
}

-(NSArray*) Horoscopes
{
    return [[NSArray alloc] initWithObjects: @"Aries", @"Taurus", @"Cancer", @"Gemini", @"Virgo", @"Leo", @"Libra", @"Scorpio", @"Sagittarius", @"Capricorn", @"Aquarius", @"Pisces", nil];
}

-(NSInteger) getSignByDate:(NSDate*) date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components: NSMonthCalendarUnit | NSDayCalendarUnit fromDate: date];
    
    NSUInteger day = [components day];
    NSUInteger month = [components month];
    
    switch(month)
    {
        case 1:
            return (day <= 19) ? 9 : 10;
            
        case 2:
            return (day <= 18) ? 10 : 11;
            
        case 3:
            return (day <= 20) ? 11 : 0;
            
        case 4:
            return (day <= 19) ? 0 : 1;
            
        case 5:
            return (day <= 20) ? 1 : 2;
            
        case 6:
            return (day <= 20) ? 2 : 3;
            
        case 7:
            return (day <= 22) ? 3 : 4;
            
        case 8:
            return (day <= 23) ? 4 : 5;
            
        case 9:
            return (day <= 22) ? 5 : 6;
            
        case 10:
            return (day <= 23) ? 6 : 7;
            
        case 11:
            return (day <= 23) ? 7 : 8;
            
        case 12:
            return (day <= 22) ? 8 : 9;
    }
    
    return -1;
}

@end