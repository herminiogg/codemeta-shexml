# Codemeta - ShExML
This repository includes a set of resources used to generate Codemeta files using the ShExML language. These workflows should be treated as examples and therefore they should be adapted to your own use cases.

## Structure
* crosswalks: Implements three workflows defined on the [Codemeta website](https://codemeta.github.io/crosswalk/) for Maven, Zenodo and Github.
* shexml-codemeta: This is the workflow followed to generate a Codemeta file for the [ShExML engine](https://github.com/herminiogg/ShExML). It uses some parts of the previously defined workflows but it is heavily customised to fit the purpose of the ShExML repository.

## How to run the examples
Both folders contain a `generate-codemeta.sh` script which encapsulates the different generation steps. Therefore, you should call it using the following command:

```
$ bash generate-codemeta.sh
```

The script will download the latest version of ShExML and will run all the existing mapping rules (files ending in .shexml) in the directory. This generated a non-framed JSON-LD codemeta. In order to have it validated against the existing [Codemeta validator](https://codemeta.github.io/codemeta-generator/) the script will convert all the non-framed results to their framed JSON-LD counterpart. This is achieved using the `convertToFramedJsonLD.groovy` script.

You can differentiate between non-framed and framed JSON-LD results looking to the extension of the generated file: `.jsonld` refers to the non-framed version and `.json` to the framed one.