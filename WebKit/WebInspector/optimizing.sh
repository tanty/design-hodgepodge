#!/bin/bash

EXISTING_LICENSE=false
LICENSE=$(scour -q --enable-viewboxing --enable-id-stripping --shorten-ids -i $1 | grep cc:license | cut -d \" -f 2)
if [ "x${LICENSE}x" == "xhttp://creativecommons.org/licenses/by-sa/3.0/x" ]; then
    EXISTING_LICENSE=true
    LICENSE_TEXT='Licensed under the Creative Commons Attribution-Share Alike 3.0 United States License (http:\/\/creativecommons.org\/licenses\/by-sa\/3.0\/)'
fi

if ${EXISTING_LICENSE}; then
    scour -q --enable-viewboxing --enable-id-stripping --shorten-ids --remove-metadata -i $1 -o $2
    sed -i 's/Created with Inkscape (http:\/\/www.inkscape.org\/)/'"${LICENSE_TEXT}"'/g' $2
else
    echo "WARNING!!! $1 doesn't have any license"
    scour -q --enable-viewboxing --enable-id-stripping --shorten-ids --remove-metadata --enable-comment-stripping -i $1 -o $2
fi

sed -i 's/ xmlns:rdf="http:\/\/www.w3.org\/1999\/02\/22-rdf-syntax-ns#"//g' $2
sed -i 's/ xmlns:cc="http:\/\/creativecommons.org\/ns#"//g' $2
sed -i 's/ xmlns:xlink="http:\/\/www.w3.org\/1999\/xlink"//g' $2
sed -i 's/ xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/"//g' $2

