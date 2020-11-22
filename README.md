# listBWBooks

## What?

This program creates a CSV file containing some info (author, author in kana, title, title in kana, publisher, purchased date) for purchaesed BOOK☆WALKER books.
These information are picked up from the cache file 'BOOK☆WALKER for Mac.app' uses (~/Library/Application Support/BOOKWALKER/BOOK\_WALKER\_for\_Mac.storedata).

## How?

### How to build:

Xcode and xcode command-line tools must be installed.

Just type `make` to build.
Type `sudo make install` if you want to install the command at /usr/local/bin.

### How to use:

listBWBooks reads data from default file (~/Library/Application Support/BOOKWALKER/BOOK\_WALKER\_for\_Mac.storedata).

`listBWBooks > ./bw.csv`

Apple's Numbers can read CSV files in UTF-8 encodeing (default).  But to use the CSV file with Microsoft Excel in Japanese environment you have to convert encodings like below.

`listBWBooks | iconv -c -f UTF-8 -t SJIS > ./bw.csv`

Or if you have nkf installed,

`./listBWBooks | nkf -Ws > ./bw.csv`

I don't know well about character encodings, I think nkf is preferable than iconv.
