#import <Foundation/Foundation.h>
#import "SQLite3DB.h"

#define dbFile @"~/Library/Application Support/BOOKWALKER/BOOK_WALKER_for_Mac.storedata"
#define SQL1 @"select \
                    zname, \
                    znamekana, \
                    zproductname, \
                    zproductnamekana, \
                    zcompanyname, \
                    zbuydate \
                from zauthor, zbookserver \
                where zauthor.zbook = zbookserver.z_pk;"
#define DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define DEF_TZ @"JST"
#define BW_DATE_EPOCH @"2001-01-01"


int
main()
{
    @autoreleasepool{
        NSError *err = nil;
        NSString *str = BW_DATE_EPOCH;  // Epoch of BOOKWALKER's buydate ?
        NSDataDetector *det = [NSDataDetector dataDetectorWithTypes: NSTextCheckingTypeDate error: &err];
        NSTextCheckingResult *match = [det firstMatchInString: str options: 0 range: NSMakeRange(0, [str length])];
        NSDate *refDate = [match date];
        NSDate *date;

        NSFileHandle *fout = [NSFileHandle fileHandleWithStandardOutput];
        SQLite3DB *db = [[SQLite3DB alloc] init];
        if([db connectDB: dbFile]){
            SQLite3Stmt *stmt = [db prepareStmt: SQL1];
            if(!stmt){
                NSLog(@"preparing statment failed");
                exit(1);
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = DATE_FORMAT;
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName: DEF_TZ];
            NSArray *data;
            NSString *outStr;
            while((data = [stmt step])){
                date = [NSDate dateWithTimeInterval: [data[5] doubleValue] sinceDate: refDate];
                outStr = [NSString
                    stringWithFormat: @"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n",
                    [data[0] stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""],
                    [data[1] stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""],
                    [data[2] stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""],
                    [data[3] stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""],
                    [data[4] stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""],
                    [[dateFormatter stringFromDate: date] stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""]];
                [fout writeData: [outStr dataUsingEncoding: NSUTF8StringEncoding]];;
            }
            [stmt done];
            [db disconnectDB];
        }else{
            NSLog(@"database connection faild: %@", dbFile);
            exit(1);
        }
    }
    return 0;
}
