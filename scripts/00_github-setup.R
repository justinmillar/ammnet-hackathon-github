# Linking Github to RStudio
# 1. Make sure our git and Github information is connected to RStudio
# 2. Practice pushing new commits
# 3. Push an interactive graph to Github

# Connect Git and Github information to RStudio
# install.packages("usethis")
library(usethis)

git_sitrep()

# Pass git creds to RStudio by creating a Github token
usethis::gh_token_help()
usethis::create_github_token()

git_sitrep()


# Try making a local commit
## By using the graphic interface
## or the Terminal

# Create a "local" folder and add to gitignore
dir.create("local")
usethis::use_git_ignore("local")

# Create Github repository (Cloud)
usethis::use_github()
