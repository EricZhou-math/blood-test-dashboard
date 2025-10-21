#!/usr/bin/env bash
set -euo pipefail

# One-click publish to GitHub + jsDelivr for blood-test-dashboard
# Usage:
#   ./publish_to_github.sh [path_to_csv]
# CSV format (no header):
#   username,ghp_xxxPERSONAL_ACCESS_TOKEN
# Default CSV path: ../github_api.csv

CSV_PATH="${1:-../github_api.csv}"
REPO_NAME="blood-test-dashboard"

if [[ ! -f "$CSV_PATH" ]]; then
  echo "[ERROR] CSV file not found: $CSV_PATH"
  echo "Please create a CSV file with: username,token (no header)."
  exit 1
fi

# Read first line and parse username, token
LINE=$(head -n 1 "$CSV_PATH" | tr -d '\r')
IFS=',' read -r GITHUB_USER GITHUB_TOKEN <<< "$LINE"

if [[ -z "${GITHUB_USER:-}" || -z "${GITHUB_TOKEN:-}" ]]; then
  echo "[ERROR] Invalid CSV content. Expect: username,token"
  exit 1
fi

# Create repo via GitHub API (idempotent)
CREATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -X POST https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\",\"private\":false,\"description\":\"Blood Test Dashboard static site\",\"has_issues\":false,\"has_projects\":false,\"has_wiki\":false}") || true

if [[ "$CREATE_STATUS" == "201" ]]; then
  echo "[INFO] GitHub repo created: https://github.com/$GITHUB_USER/$REPO_NAME"
elif [[ "$CREATE_STATUS" == "422" ]]; then
  echo "[INFO] Repo already exists: https://github.com/$GITHUB_USER/$REPO_NAME"
else
  echo "[WARN] Repo create HTTP status: $CREATE_STATUS (continuing if exists)"
fi

# Ensure local git repo is initialized and on main
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[INFO] Initializing git repository..."
  git init
  git add .
  git commit -m "init site for GitHub+jsDelivr"
fi
# Switch to main
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  git branch -M main
fi

# Add GitHub remote with token for push
if git remote get-url github >/dev/null 2>&1; then
  git remote remove github || true
fi
GITHUB_REMOTE_URL="https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo "[INFO] Adding GitHub remote: github"
git remote add github "$GITHUB_REMOTE_URL"

# Push to GitHub
echo "[INFO] Pushing to GitHub..."
# Avoid leaking token in local git config after push
GIT_ASKPASS_HELPER=$(mktemp)
cat >"$GIT_ASKPASS_HELPER" <<'EOF'
#!/usr/bin/env bash
# noop
exit 0
EOF
chmod +x "$GIT_ASKPASS_HELPER"
GIT_ASKPASS="$GIT_ASKPASS_HELPER" git push -u github main
rm -f "$GIT_ASKPASS_HELPER"

echo "[INFO] Push completed. Generating jsDelivr URL..."
JS_URL_NOREF="https://cdn.jsdelivr.net/gh/${GITHUB_USER}/${REPO_NAME}/index.html"
JS_URL_MAIN="https://cdn.jsdelivr.net/gh/${GITHUB_USER}/${REPO_NAME}@main/index.html"

# Verify availability (prefer @main to avoid edge caching of default branch)
STATUS_MAIN=$(curl -s -o /dev/null -w "%{http_code}" "$JS_URL_MAIN")
STATUS_NOREF=$(curl -s -o /dev/null -w "%{http_code}" "$JS_URL_NOREF")

if [[ "$STATUS_MAIN" == "200" ]]; then
  FINAL_URL="$JS_URL_MAIN"
elif [[ "$STATUS_NOREF" == "200" ]]; then
  FINAL_URL="$JS_URL_NOREF"
else
  echo "[WARN] jsDelivr not yet available (status: main=$STATUS_MAIN, noref=$STATUS_NOREF). It can take ~1-2 min."
  FINAL_URL="$JS_URL_MAIN"
fi

echo "[INFO] jsDelivr URL: $FINAL_URL"

# Update QR code
if [[ -f "generate_qr.py" ]]; then
  echo "[INFO] Updating qrcode.png with new URL..."
  python3 generate_qr.py --link "$FINAL_URL" --output "qrcode.png"
  git add qrcode.png
fi

# Append access URL to README (idempotent append)
if [[ -f "README.md" ]]; then
  echo "\n---\nGitHub + jsDelivr 访问地址\n\n$FINAL_URL\n\n使用微信扫码上方二维码可直接打开仪表盘。\n" >> README.md
  git add README.md
fi

echo "[INFO] Committing updated README/QR..."
if git diff --cached --quiet; then
  echo "[INFO] No changes to commit."
else
  git commit -m "Publish via GitHub+jsDelivr: update QR and README with CDN URL"
  echo "[INFO] Pushing updates..."
  GIT_ASKPASS="$GIT_ASKPASS_HELPER" git push github main || true
fi

echo "[DONE] Published to GitHub and accessible via jsDelivr: $FINAL_URL"