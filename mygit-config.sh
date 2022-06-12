#!/bin/bash

echo Enter your email :
read email
echo email : $email

echo Enter your username :
read username
echo username : $username

echo Paste the token :
read token

# Template ~/.gitconfig
read -r -d '' TEMPGITCONFIG << EOM
 [user] 
    email = $email
    name = $username

 [alias]
    ci = commit 
    co = checkout 
    st = status 
    br = branch
EOM


# Template ~/.netrc
read -r -d '' TEMPNETRC << EOM
machine github.com
       login $username
       password $token
EOM

# Template ~/.local/bin/mygit
read -r -d '' MYGIT << EOM
#!/bin/bash
# usage :  \$ mygit "commit message" 

USER=$username
PROJECT="\$PWD"

if [ ! -e ~/.git ]; then
    echo "directory .git is not present ! Init and remote add origin."
    git init
    echo "git add ."
    git add .
    echo "git commit -m "\$1""
    if [[ -n "\$1" ]]; then
        git commit -m "\$1"
    else 
        git commit -m "commit"
    fi
    echo "Go to https://github.com/new and copy-paste :"
    echo "\${PROJECT##*/}"
    echo "and press enter when done."
    read ANSWER
    git remote add origin https://github.com/\$USER/"\${PROJECT##*/}".git
    echo "git push origin master"
    git push origin master
else
    echo "git add ."
    git add .
    echo "git commit -m "\$1""
    if [[ -n "\$1" ]]; then
        git commit -m "\$1"
    else 
        git commit -m "commit"
    fi
    echo "git push origin master"
    git push origin master
fi
EOM

# .gitconfig generation
echo "File ~/.gitconfig generation :"
if [ -e ~/.gitconfig ]; then
    echo "File ~/.gitconfig already exists ! Overwrite ? y/n "
    read ANSWER
    case $ANSWER in
        [yY]) echo "$TEMPGITCONFIG" > ~/.gitconfig ;;
        [nN]) echo "skipping..." ;;
    esac
else
    echo "$TEMPGITCONFIG" > ~/.gitconfig ;
fi

# .netrc generation
echo "File ~/.netrc generation :"
if [ -e ~/.netrc ]; then
    echo "File ~/.netrc already exists ! Overwrite ? y/n "
    read ANSWER
    case $ANSWER in
        [yY]) echo "$TEMPNETRC" > ~/.netrc ;;
        [nN]) echo "skipping..." ;;
    esac
else
    echo "$TEMPNETRC" > ~/.netrc ;
fi

# ~/.local/bin/mygit generation
echo "File  ~/.local/bin/mygit generation :"
if [ -e ~/.local/bin/mygit ]; then
    echo "File ~/.local/bin/mygit already exists ! Overwrite ? y/n "
    read ANSWER
    case $ANSWER in
        [yY]) echo "$MYGIT" > ~/.local/bin/mygit ;;
        [nN]) echo "skipping..." ;;
    esac
else
    echo "$MYGIT" > ~/.local/bin/mygit ;
fi
