#!/bin/bash

# This script depends on:
# * scour: http://www.codedread.com/scour
# * svgo: https://github.com/tanty/svgo

BASE_PATH="`dirname \"$0\"`"
FULL_SCRIPT_PATH=$(readlink -f $0)
FULL_BASE_PATH="`dirname \"$FULL_SCRIPT_PATH\"`"

EXISTING_LICENSE=false
scour -q --enable-viewboxing --enable-id-stripping --shorten-ids -i $1 -o $2
LICENSE=$(cat $2 | grep cc:license | cut -d \" -f 2)

if [ "x${LICENSE}x" == "xhttp://creativecommons.org/licenses/by-sa/3.0/x" ]; then
    EXISTING_LICENSE=true
    LICENSE_TEXT=' Licensed under the Creative Commons Attribution-Share Alike 3.0 United States License (http:\/\/creativecommons.org\/licenses\/by-sa\/3.0\/) '
fi

cat $2 | grep "style=\".*\""
if [ ${?} -eq 0 ] ; then
    echo "WARNING!!! $2 does have styles"
fi

# $ sudo npm install -g tanty/svgo
if ${EXISTING_LICENSE}; then
    svgo --config=$FULL_BASE_PATH/config-svgo.yml -p 5 --multipass --pretty -i $2 -o $2
    sed -i 's/Created with Inkscape (http:\/\/www.inkscape.org\/)/'"${LICENSE_TEXT}"'/g' $2
else
    echo "WARNING!!! $1 doesn't have any license"
    svgo --config=$FULL_BASE_PATH/config-svgo.yml --enable=removeComments -p 5 --multipass --pretty -i $2 -o $2
fi

# sed -i 's/ xmlns:rdf="http:\/\/www.w3.org\/1999\/02\/22-rdf-syntax-ns#"//g' $2
# sed -i 's/ xmlns:cc="http:\/\/creativecommons.org\/ns#"//g' $2
# sed -i 's/ xmlns:xlink="http:\/\/www.w3.org\/1999\/xlink"//g' $2
# sed -i 's/ xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/"//g' $2
# sed -i 's/ standalone="no"//g' $2
# sed -i 's/text-indent:0;//g' $2
# sed -i 's/;text-indent:0//g' $2
# sed -i 's/text-indent:0//g' $2
# sed -i 's/text-transform:none;//g' $2
# sed -i 's/;text-transform:none//g' $2
# sed -i 's/text-transform:none//g' $2
# sed -i 's/enable-background:new;//g' $2
# sed -i 's/;enable-background:new//g' $2
# sed -i 's/enable-background:new//g' $2
# sed -i 's/ style=""//g' $2

cat $2 | grep "<text" > /dev/null
if [ ${?} -eq 0 ] ; then
    echo "WARNING!!! $2 does have text elements"
fi

cat $2 | grep "<g" > /dev/null
if [ ${?} -eq 0 ] ; then
    echo "WARNING!!! $2 does have groups"
fi
