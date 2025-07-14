#!/bin/bash

echo "" > validationReport.txt # Clears the validation report file
echo "" > shexCommandOutput.txt # Clears the ShEx command output file

if [ ! -d apache-jena ]; then
    echo "Downloading Apache Jena..."
    curl -L https://dlcdn.apache.org/jena/binaries/apache-jena-5.4.0.zip -o apache-jena.zip
    unzip -q apache-jena.zip -d apache-jena
fi

#export _JAVA_OPTIONS="-Xmx12g"

shex="apache-jena/apache-jena-5.4.0/bin/shex"

validate() {
    filename=$1
    schema=$2
    shape_map=$3
    validation_result=$($shex validate --schema $schema --data $filename -m $shape_map 2>> shexCommandOutput.txt)
    conformant=$(echo "$validation_result" | grep "Status = conformant" | wc -l)
    non_conformant=$(echo "$validation_result" | grep "Status = nonconformant" | wc -l)
    { echo "$validation_result" | grep "Status = nonconformant" || true; } >> validationReport.txt
    if [ $non_conformant -gt 0 ] || [ $conformant -eq 0 ]; then
        echo "Validating $filename: Error!"
    else
        echo "Validating $filename: OK"
    fi
}

validate crosswalks/generated/codemeta-github.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap
validate crosswalks/generated/codemeta-maven.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap
validate crosswalks/generated/codemeta-zenodo.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap
validate dmaog-codemeta/generated/codemeta.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap
validate shexml-codemeta/generated/codemeta.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap