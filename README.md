# Code Continuity Analysis Framework

Based on [Diff/AST](https://github.com/codinuum/diffast), the framework currently provides the following:
* helper scripts for factbase manipulation, and
* ontologies for the related entities.

Diff/AST exports *facts* such as abstract syntax trees (ASTs), changes between them, and other syntactic/semantic information in
[XML](https://www.w3.org/TR/xml11/) or [N-Triples](https://www.w3.org/2001/sw/RDFCore/ntriples/).
In particular, facts in N-Triples format are loaded into an RDF store such as
[Virtuoso](https://github.com/openlink/virtuoso-opensource) to build a *factbase* or a database of facts.
Factbases are intended to be queried for software engineering tasks such as
[code comprehension](https://github.com/ebt-hpc/cca),
[debugging](https://stair.center/archives/research/ddj-esecfse2018),
[change pattern mining](https://ieeexplore.ieee.org/document/7081845), and
[code homology analysis](https://link.springer.com/chapter/10.1007/978-3-642-12029-9_7).

## Building docker image

The following command line creates a docker image named `cca`.  In the image, the framework is installed at `/opt/cca`.

    $ docker build -t cca .

## License

Apache License, Version 2.0
