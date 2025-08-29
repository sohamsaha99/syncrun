# syncrun

One shared script to **sync a project to a remote** and **run it there**.
Per-project tweaks live in a tiny config file—no copy-paste drift.

## Quick start

```bash
# Clone anywhere and add bin/ to your PATH
git clone https://github.com/<you>/syncrun.git
echo 'export PATH="$HOME/syncrun/bin:$PATH"' >> ~/.bashrc   # or ~/.zshrc
source ~/.bashrc
```

In each project:

```bash
mkdir -p ./.syncrun
cp ~/syncrun/examples/project-config.sh ./.syncrun/config.sh
# edit values in ./.syncrun/config.sh as needed
```

Run it:

```bash
sync-run 'lr=0.05 epochs=200'   # sync + run
sync-run --no-sync 'lr=0.05'    # only run
sync-run --no-run               # only sync
sync-run --pull-env             # pull remote_env.RData
sync-run --onsite               # use REMOTE_ON_SITE
sync-run --help                 # usage
```

## Hooks (optional)

Create executable files for custom steps:

```
.synchrun/hooks/pre_sync
.synchrun/hooks/post_sync
.synchrun/hooks/pre_run
.synchrun/hooks/post_run
```

Example:

```bash
#!/usr/bin/env bash
# .syncrun/hooks/pre_run
set -euo pipefail
echo "[hook] creating timestamp"
date > ./.last-remote-run
```

Make it executable:

```bash
chmod +x ./.syncrun/hooks/pre_run
```

## Customization

* Edit `./.syncrun/config.sh` to override:

  * `REMOTE`, `REMOTE_ON_SITE`, `REMOTE_RUN_DIR`
  * `RSYNC_EXCLUDES` (array): `RSYNC_EXCLUDES+=("data/raw" "outputs")`
  * `RESTORE_CMD` and `RUN_CMD` (placeholders supported):

    * `__RUN_ARGS__` gets replaced with your CLI args (properly escaped)

