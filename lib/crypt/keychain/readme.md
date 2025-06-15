security add-internet-password -s git.threefold.info -a despiegk -w mypassword

-s: The server (e.g., git.threefold.info).
-a: The account or username (e.g., despiegk).
-w: The password (e.g., mypassword).


security find-internet-password -s git.threefold.info -w


security delete-internet-password -s git.threefold.info



git config --global credential.helper osxkeychain


