## About shDirListing

shDirListing is Bash script to generate directory listing in HTML format so it can be read by web server. It will create an index.html file in each directory based on specified depth.

I create this tool because object storage services used for static web hosting such as S3 or Netlify does not support directory listing out-of-the box. So I need a quick way to list of files under a directory on those services.

## Requirements

- Unix or Unix like based OS such as macOS or Linux. (Windows should work under WSL)
- Bash version >= 3.2.57

## Installation

Method 1 - The easiest.

Just copy and paste the contents of shdir-listing.sh and run it on your local machine.

Method 2 - Clone the project repository from GitHub.

```
$ git clone git@github.com:rioastamal/shdir-listing.git
```

Method 3 - Download the zipped version from GitHub.

```
$ curl -O -L 'https://github.com/rioastamal/shdir-listing/archive/master.zip'
```

And then extract to your desired directory.

## Usage and Examples

Running shDirListing with `-h` flag will give you list of options and example.

```
$ bash ./shdir-listing.sh -h
```

```
Usage: shdir-listing.sh [OPTIONS] DIRNAME

Where OPTIONS:
  -d DEPTH      Specify the depth directory under DIRNAME.
  -e            Generate empty content for index.html. It will prevent
                directory listing.
  -h            Show this help and exit.
  -k            Skip creation of index.html if file named index.html already
                exists in a directory.
  -r            Dry run mode. Print the content that will be written to
                index.html for each directory.
  -v            Display shDirListing version.

------------------------------------------
                  EXAMPLE
------------------------------------------

Suppose you have following directories:

- website/
  - docs1/
    - archives/
  - docs2/
  - images/

And run this command to generate directory listing.

$ bash ./shdir-listing.sh -d 2 ~/website

It will create index.html file with maximum depth of
2 directories under website/. And here is the result.

- website/
  - docs1/
    - archives/
      - index.html
    - index.html
  - docs2/
    - index.html
  - images/
    - index.html
  - index.html

----------------------------- About shDirListing -----------------------------

shDirListing is Bash script to generate directory listing in HTML format to be
used in web server. It will create an index.html file in each directory.

shDirListing is free software licensed under MIT. Visit the project homepage
at https://github.com/rioastamal/shdir-listing
```

### Create Directory Listing for 0 Level Deep

By default the depth directory is `0` zero. Given directory below:

```
- website/
  - docs1/
    - archives/
  - docs2/
  - images/
```

```
$ bash ./shdir-listing ~/website
```

It will generate directory listing for `website/index.html` only.

### Create Directory Listing for 1 Level Deep

Given directory below:

```
- website/
  - docs1/
    - archives/
  - docs2/
  - images/
```

```
$ bash ./shdir-listing -d 1 ~/website
```

It will generate directory listing below.

```
- website/
  - docs1/
    - index.html
    - archives/
  - docs2/
    - index.html
  - images/
    - index.html
  - index.html
```

### Running in Dry Run mode.

In Dry Run mode no file will be written. So you can make sure that all the action correct before running the real one. Taken from previous example add an option switch `-r`.

```
$ bash ./shdir-listing -d 1 -r ~/website
```

```
[DRY RUN] Creating index.html for /website/docs1...DONE.
[DRY RUN] Creating index.html for /website/docs2...DONE.
[DRY RUN] Creating index.html for /website/images...DONE.
[DRY RUN] Creating index.html for /website...DONE.
```

## Author

shDirListing is written by Rio Astamal &lt;rio@rioastamal.net&gt;

## License

shDirListing is open source licensed under [MIT license](http://opensource.org/licenses/MIT).