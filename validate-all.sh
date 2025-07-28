#!/bin/bash

echo "" > validationReport.txt # Clears the validation report file
echo "" > shexCommandOutput.txt # Clears the ShEx command output file
echo "" > shaclCommandOutput.txt # Clears the SHACL command output file

if [ ! -d apache-jena ]; then
    echo "Downloading Apache Jena..."
    curl -L https://dlcdn.apache.org/jena/binaries/apache-jena-5.4.0.zip -o apache-jena.zip
    unzip -q apache-jena.zip -d apache-jena
fi

#export _JAVA_OPTIONS="-Xmx12g"

shex="apache-jena/apache-jena-5.4.0/bin/shex"
shacl="apache-jena/apache-jena-5.4.0/bin/shacl"

total_non_conformant=0

validate() {
    filename=$1
    schema=$2
    shape_map=$3
    validation_result=$($shex validate --schema $schema --data $filename -m $shape_map 2>> shexCommandOutput.txt)
    conformant=$(echo "$validation_result" | grep "Status = conformant" | wc -l)
    non_conformant=$(echo "$validation_result" | grep "Status = nonconformant" | wc -l)
    total_non_conformant=$(($total_non_conformant + non_conformant))
    echo "$validation_result" >> validationReport.txt
    if [ $non_conformant -gt 0 ] || [ $conformant -eq 0 ]; then
        echo "Validating $filename: Error!"
    else
        echo "Validating $filename: OK"
    fi
}

validate_shacl() {
    filename=$1
    schema=$2
    validation_result=$($shacl validate --shapes $schema --data $filename 2>> shaclCommandOutput.txt)
    non_conformant=$(echo "$validation_result" | grep "sh:Violation;" | wc -l)  
    total_non_conformant=$(($total_non_conformant + non_conformant))
    echo "$validation_result" >> validationReport.txt
    if [ $non_conformant -eq 0 ]; then
        echo "Validating $filename: OK"
    else
         echo "Validating $filename: Error!"
    fi
}

echo "Validating using ShEx files..."
validate crosswalks/generated/codemeta-github.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap
validate crosswalks/generated/codemeta-maven.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap
validate crosswalks/generated/codemeta-zenodo.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap
validate dmaog-codemeta/generated/codemeta.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap
validate shexml-codemeta/generated/codemeta.jsonld shapes/codemeta3.0.shex shapes/codemeta3.0.smap

echo "Validating using SHACL files..."
validate_shacl crosswalks/generated/codemeta-github.jsonld shapes/codemeta3.0.shacl.ttl
validate_shacl crosswalks/generated/codemeta-maven.jsonld shapes/codemeta3.0.shacl.ttl
validate_shacl crosswalks/generated/codemeta-zenodo.jsonld shapes/codemeta3.0.shacl.ttl
validate_shacl dmaog-codemeta/generated/codemeta.jsonld shapes/codemeta3.0.shacl.ttl
validate_shacl shexml-codemeta/generated/codemeta.jsonld shapes/codemeta3.0.shacl.ttl

if [ $total_non_conformant -gt 0 ]; then
    exit 1
else
    exit 0
fi