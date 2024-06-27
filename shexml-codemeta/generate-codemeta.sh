#!/bin/bash

if ! test -f "generated/shexml.jar"; then
    mkdir generated
    curl -L https://github.com/herminiogg/ShExML/releases/download/v0.5.2/ShExML-v0.5.2.jar -o generated/shexml.jar
fi

# generates the non framed version
java -Dfile.encoding=UTF8 -jar generated/shexml.jar -m codemeta-shexml.shexml -f json-ld -o generated/codemeta.jsonld

# converts to the framed version
groovy ../convertToFramedJsonLD.groovy generated/codemeta.jsonld codemeta-context.jsonld generated/codemeta.json