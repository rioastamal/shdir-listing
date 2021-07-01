#!/bin/bash
#
# @author Rio Astamal <rio@rioastamal.net>

readonly SHDIR_SCRIPT_NAME=$(basename $0)

SHDIR_VERSION="2021-06-29"
SHDIR_DRY_RUN="no"
SHDIR_SKIP_INDEX="no"
SHDIR_DEPTH="0"
SHDIR_EMPTY_HTML="no"

shdir_see_help()
{
    echo "Try '$SHDIR_SCRIPT_NAME -h' for more information."
}

shdir_help()
{
    echo "\
Usage: $0 [OPTIONS] DIRNAME

Where OPTIONS:
  -d DEPTH      Specify the depth directory under DIRNAME.
  -e            Generate empty content for index.html. It will prevent
                directory listing.
  -h            Show this help and exit.
  -k            Skip creation of index.html if file named index.html already
                exists in a directory.
  -r            Dry run mode. Do not write contents to index.html.
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
"
}

shdir_listing_html()
{
    [ -z "$1" ] && {
        echo "shdir_listing_html: Missing 1st arg for directory name." >&2
        return 1
    }

    [ -z "$2" ] && {
        echo "shdir_listing_html: Missing 2nd arg for root directory." >&2
        return 1
    }

    local output_file=$1/index.html
    local doc_root=$( echo "$1" | sed "s#$2##g" )
    [ -z "$doc_root" ] && doc_root="/"
    echo "$doc_root" | grep -q '/$' || doc_root="$doc_root/"

    local html="<!DOCTYPE html>
<html>
<body>
<h2>Directory Listing $doc_root</h2>
<ul>"

    for _dir in $( find $1 -maxdepth 1 | sort )
    do
        local _dirname=$( basename $_dir )
        [ "$_dirname" = "index.html" ] && continue

        local suffix="/"

        [ -f "$_dir" ] && suffix=""

        html="${html}\n<li><a href=\"${_dirname}${suffix}\">${_dirname}</a></li>"
    done

    html="${html}\n</ul><p>Generated on $( date -R )</p></body></html>"
    echo -e $html
}

shdir_create_index_file()
{
    [ -z "$1" ] && {
        echo "shdir_create_index_file: Missing 1st arg for directory name." >&2
        return 1
    }

    [ -z "$2" ] && {
        echo "shdir_create_index_file: Missing 2nd arg for depth." >&2
        return 1
    }

    local depth=$2
    local suffix=""
    local root_dir="$1"

    [ "$SHDIR_DRY_RUN" = "yes" ] && suffix="[DRY RUN] "

    for _dir in $( find $1 -maxdepth $depth -type d | sort -r )
    do
        echo -n "${suffix}Creating index.html for ${_dir}..."

        [ -f "$_dir/index.html" ] && [ "$SHDIR_SKIP_INDEX" = "yes" ] && {
            echo "SKIP.";
            continue
        }

        [ "$SHDIR_DRY_RUN" = "yes" ] && {
            echo "DONE."
            continue
        }

        [ "$SHDIR_EMPTY_HTML" = "yes" ] && {
            echo > $_dir/index.html && echo "DONE."
            continue
        }

        shdir_listing_html "$_dir" "$root_dir" > $_dir/index.html
        echo "DONE.";
    done
}

while getopts d:ehkrv SHDIR_OPT;
do
    case $SHDIR_OPT in
        d)
            SHDIR_DEPTH="$OPTARG"
        ;;

        e)
            SHDIR_EMPTY_HTML="yes"
        ;;

        h)
            shdir_help
            exit 0
        ;;

        k)
            SHDIR_SKIP_INDEX="yes"
        ;;

        r)
            SHDIR_DRY_RUN="yes"
        ;;

        v)
            echo "shDirListing version $SHDIR_VERSION"
            exit 0
        ;;

        \?)
            shdir_see_help
            exit 400
        ;;
    esac
done

[ $# -eq 0 ] && {
    shdir_see_help
    exit 400
}

# Remove getopts args from the arguments $ var
shift $(( OPTIND - 1 ))

shdir_create_index_file "$1" $SHDIR_DEPTH

exit 0