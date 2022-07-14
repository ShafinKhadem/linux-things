## Cleanly work on a large repo

- Fork it & never touch the main branch.
- git clone the fork.
- :warning: Delete all remote branches except main or master from fork: `git branch -r | grep -Po '(?<=origin/).*' | grep -v 'main\|master' | xargs -I {} git push origin :{}`
- Add new remote named 'upstream' from upstream url to track upstream main.
- Clear the useless remote tracking branches from 'upstream': `git branch -r | grep -Po '(?<=upstream/).*' | grep -v 'main\|master' | xargs -I {} git branch -r -d upstream/{}`

If you ever mistakenly remove the 'origin' remote, after re-adding it, you can make the local branches track their origin equivalents by `git branch | cut -c 3- | xargs -I {} git branch -u origin/{} {}`


## Properly ignore changes in git

**Discard changes (from gitkraken) will discard/reset the changes, not ignore**

**First add that file/folder to .gitignore**. Can be done from gitkraken: `right click-> ignore-> ignore`.

**After gitignoring**, there are 3 options, you probably want #3

1. This will keep the local file for you, but will delete it for anyone else when they pull. Can be done from gitkraken: `right click-> ignore-> ignore and stop tracking`.

```
git rm --cached <file-name> or git rm -r --cached <folder-name>
```

2. This is for optimization, like a folder with a large number of files, e.g. SDKs that probably won't ever change. It tells git to stop checking that huge folder every time for changes, locally, since it won't have any. The assume-unchanged index will be reset and **file(s) will be overwritten completely resetting local changes if there are upstream changes to the file/folder (when you pull)**.

```
git update-index --assume-unchanged <path-name>
```

3. This is to tell git you want your own independent version of the file or folder. For instance, you don't want to overwrite (or delete) production/staging config files. if upstream changes are done:
    - **If there is no local change, files will be overwritten.**
    - **If there is local change, pull will fail (has to manually --no-skip-worktree in that case)**.

    **But it ignores the ‘`reset --hard`' command which could become a nasty surprise** for a developer.

```
git update-index --skip-worktree <path-name>
```

It's important to know that git update-index will not propagate with git, and each user will have to run it independently. Another important thing to know: **update-index won't work as intended without gitignoring first**.

## gitkraken hard-to-notice useful features

- select multiple commits and view merged diff
- move commit up/down
