#!/bin/bash
# assumes that the print_newdox.sh and git-branchpoint.sh scripts are accessible
# in the path as print_newdox and git-branchpoint, respectively
print_newdox $(git-branchpoint)
