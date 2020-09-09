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

int
main()
{
    @autoreleasepool{
        NSFileHandle *fout = [NSFileHandle fileHandleWithStandardOutput];
        SQLite3DB *db = [[SQLite3DB alloc] init];
        if([db connectDB: dbFile]){
            SQLite3Stmt *stmt = [db prepareStmt: SQL1];
            if(!stmt){
                NSLog(@"preparing statment failed");
                exit(1);
            }
    //        NSLog(@"preparing statment SUCCEEDED");
            NSArray *data;
            NSString *outStr;
            while((data = [stmt step])){
                outStr = [NSString stringWithFormat: @"%@, %@, %@, %@, %@, %@\n", data[0], data[1], data[2], data[3], data[4], data[5]];
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
