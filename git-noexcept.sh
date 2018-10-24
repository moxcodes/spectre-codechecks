#!/bin/bash
# assumes that detect_missing_noexcept.sh and git-branchpoint.sh are available
# in the PATH as detect_missing_noexcept and git-branchpoint, respectively
detect_missing_noexcept $(git-branchpoint)
