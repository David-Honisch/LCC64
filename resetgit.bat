REM -- Remove the history from 
rm -rf .git

REM -- recreate the repos from the current content only
git init
git add .
git commit -m "Initial commit"

REM -- push to the github remote repos ensuring you overwrite history
git remote add origin git@github.com:<YOUR ACCOUNT>/<YOUR REPOS>.git
git push -u --force origin master