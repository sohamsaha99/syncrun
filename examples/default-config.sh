# Global defaults users can edit
REMOTE="lynx"
REMOTE_ON_SITE="saha@lynx.dfci.harvard.edu"
RSYNC_EXCLUDES+=(".venv" "__pycache__")
REMOTE_RUN_DIR="tmp/MAIC"
REMOTE_DATA="remote_env.RData"
RESTORE_CMD='Rscript -e "if (requireNamespace(\"renv\", quietly=TRUE)) renv::restore()"'  # safe if renv absent
RUN_CMD='R --quiet -e "source(\"run.R\"); save.image(\"remote_env.RData\")" --args __RUN_ARGS__'

