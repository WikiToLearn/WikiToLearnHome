Add or update a mediawiki extension
-----------------------------------

### Add the extension on the file `extensions.list.version` inside the WikiToLearn repo

You have to add the extension in the file `extensions.list.version`, inside the WTL repo, with the syntax:
```
<Extension Name>|<Extension branch>-<Extension commit>
```

for example:
```
Echo|REL1_27-b87fa2f
```

after this you have to run the download procedure and re-start the environment

### Add the `.gitignore` entry

When you add an extension you have also to add the `.gitignore` entry to exclude the path of the extension.

for example:
```
extensions/Echo/
```
