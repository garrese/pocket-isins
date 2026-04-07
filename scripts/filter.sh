#!/bin/sh
# Internal script called by git filter-branch --env-filter
# Extracts date using git show, mutates the time portion using sed, and exports variables.

ORIG_ADATE=$(git show -s --format=%ad --date=iso-strict $GIT_COMMIT)
NEW_ADATE=$(echo "$ORIG_ADATE" | sed 's/T..:..:../T00:00:00/')
export GIT_AUTHOR_DATE="$NEW_ADATE"

ORIG_CDATE=$(git show -s --format=%cd --date=iso-strict $GIT_COMMIT)
NEW_CDATE=$(echo "$ORIG_CDATE" | sed 's/T..:..:../T00:00:00/')
export GIT_COMMITTER_DATE="$NEW_CDATE"
