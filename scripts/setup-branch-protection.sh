#!/usr/bin/env bash
set -euo pipefail

# main ブランチの保護ルールを GitHub に設定するスクリプト
# 前提: gh CLI でログイン済み、リモートが設定済み
# Usage: bash scripts/setup-branch-protection.sh

REPO="$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null)" || {
  echo "Error: Not a GitHub repository or gh CLI not authenticated."
  echo "Run: gh auth login"
  exit 1
}

echo "Setting branch protection for $REPO (main branch)..."

gh api -X PUT "repos/$REPO/branches/main/protection" \
  --input - << 'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["Lint / Type Check / Test (22)"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF

echo "Done! Branch protection enabled for main:"
echo "  - CI must pass before merge"
echo "  - 1 approving review required"
echo "  - Stale reviews dismissed on new pushes"
echo "  - Force push disabled"
echo "  - Branch deletion disabled"
