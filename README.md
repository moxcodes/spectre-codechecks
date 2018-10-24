# A handful of utility scripts I've found useful for spectre code-quality checks

These are currently *extremely* rough, contain several hard-coded paths specific to my filesystem, rather bug-prone, and generally not release-worthy. Nonetheless, there's likely a few scraps that some might find useful.

I will steadily improve, update, and document the functions as they become more polished.

The scripts likely most useful for others are:
`git-newdox.sh`
`git-noexcept.sh`

note that noexcept is designed to simply flag all functions definitions not labelled noexcept under the assumption that virtually all should be. It can be made to not flag a function if a comment is added `/*except*/` where the noexcept would typically live. No attempt is made on the comparatively difficult task of attempting to work out whether a function should or should not be labelled noexcept.

the newdox script attempts to find all doxygen changes in the most recent branch and dumps them to a file and opens an emacs session for easy spell-checking.
