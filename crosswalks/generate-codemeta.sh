#!/bin/bash

if ! test -f "generated/shexml.jar"; then
    mkdir generated
    curl -L https://github.com/herminiogg/ShExML/releases/download/v0.5.3/ShExML-v0.5.3.jar -o generated/shexml.jar
fi

# generates the non framed versions
# for Maven and Github this is enough as there are not linked entities
java -Dfile.encoding=UTF8 -jar generated/shexml.jar -m codemeta-maven.shexml -nu -f json-ld -o generated/codemeta-maven.json
java -Dfile.encoding=UTF8 -jar generated/shexml.jar -m codemeta-github.shexml -nu -f json-ld -o generated/codemeta-github.json
java -Dfile.encoding=UTF8 -jar generated/shexml.jar -m codemeta-zenodo.shexml -nu -f json-ld -o generated/codemeta-zenodo.jsonld

# converts to the framed version for Zenodo's case
groovy ../convertToFramedJsonLD.groovy generated/codemeta-zenodo.jsonld codemeta-context.jsonld generated/codemeta-zenodo.json