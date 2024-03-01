(lang dune 3.14)

(name zebang)

(package
 (name zebang)
 (description "File based script runner powered by shebangs")
 (depends ppx_jane))

(generate_opam_files true)

(source
 (github atomicptr/zebang))

(authors "Christopher Kaster")

(maintainers "Christopher Kaster")

(license GPL-3.0-or-later)
