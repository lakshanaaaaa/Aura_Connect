#  Slack Integration Setup - Quick Guide

## Prerequisites

- A Slack workspace
- Admin access to create Slack apps
- GitHub repository with Actions enabled

---

## 🚀 Quick Setup (5 minutes)

### Option 1: Slack Bot Token (Recommended)

#### Step 1: Create Slack App

1. Visit: https://api.slack.com/apps
2. Click **"Create New App"**
3. Select **"From scratch"**
4. App Name: `Aura Connect CI Bot`
5. Select your workspace
6. Click **"Create App"**

#### Step 2: Configure Bot Permissions

1. In your app settings, go to **"OAuth & Permissions"**
2. Scroll to **"Scopes"** → **"Bot Token Scopes"**
3. Click **"Add an OAuth Scope"** and add:
   - `chat:write` - Send messages
   - `chat:write.public` - Post to public channels without joining

#### Step 3: Install App to Workspace

1. Scroll to top of **"OAuth & Permissions"** page
2. Click **"Install to Workspace"**
3. Review permissions and click **"Allow"**
4. Copy the **"Bot User OAuth Token"** (starts with `xoxb-`)
   - ⚠️ Keep this secret! Don't commit it to your repo

#### Step 4: Add Token to GitHub

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Name: `SLACK_TOKEN`
5. Value: Paste your bot token (xoxb-...)
6. Click **"Add secret"**

#### Step 5: Invite Bot to Channel

1. In Slack, go to `#auro-connect` channel (or create it)
2. Type: `/invite @Aura Connect CI Bot`
3. Press Enter

✅ Done! Your bot is ready to send notifications.

---

### Option 2: Incoming Webhook (Alternative)

Use this if you can't create a Slack app.

#### Step 1: Create Webhook

1. Visit: https://api.slack.com/messaging/webhooks
2. Click **"Create your Slack app"**
3. Select **"From scratch"**
4. Name: `Aura Connect CI Webhook`
5. Select workspace
6. Go to **"Incoming Webhooks"**
7. Toggle **"Activate Incoming Webhooks"** to ON
8. Click **"Add New Webhook to Workspace"**
9. Select channel: `#auro-connect`
10. Click **"Allow"**
11. Copy the webhook URL (starts with `https://hooks.slack.com/services/`)

#### Step 2: Add Webhook to GitHub

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Name: `SLACK_WEBHOOK_URL`
5. Value: Paste your webhook URL
6. Click **"Add secret"**

✅ Done! Webhook is ready.

---

## 🧪 Test Your Setup

### Method 1: Push a Commit

```bash
# Make a small change
echo "# Testing CI/CD" >> README.md

# Commit and push
git add README.md
git commit -m "Test CI/CD pipeline"
git push origin main
```

### Method 2: Manually Trigger Workflow

1. Go to GitHub → **Actions** tab
2. Select **"CI Pipeline"** workflow
3. Click **"Run workflow"**
4. Select branch and click **"Run workflow"**

### What to Expect

Within 2-5 minutes, you should see:

1. **In GitHub Actions**:
   - Workflow running
   - Jobs completing (setup, lint, test, etc.)
   - Green checkmarks ✅

2. **In Slack**:
   - Message in `#auro-connect` channel
   - Status summary with emojis
   - Test results and metrics
   - Link to GitHub Actions run

---

## 📋 Verification Checklist

- [ ] Slack app created
- [ ] Bot permissions configured (`chat:write`, `chat:write.public`)
- [ ] App installed to workspace
- [ ] Bot token copied
- [ ] `SLACK_TOKEN` secret added to GitHub
- [ ] Bot invited to `#auro-connect` channel
- [ ] Test commit pushed
- [ ] Notification received in Slack

---

## 🎨 Customize Notifications

### Change Channel

Edit `.github/workflows/ci.yml`:

```yaml
env:
  SLACK_CHANNEL: '#your-channel-name'  # Change this
```

### Change Bot Name/Icon

In Slack app settings:

1. Go to **"Basic Information"**
2. Scroll to **"Display Information"**
3. Update:
   - App name
   - Short description
   - App icon (512x512 PNG)
4. Click **"Save Changes"**

### Customize Message Format

Edit `scripts/slack-notify.sh`:

```bash
# Find the message creation section
cat << EOF > slack_api_message.json
{
  "channel": "$SLACK_CHANNEL",
  "text": "$STATUS",
  "attachments": [
    # Customize fields here
  ]
}
EOF
```

---

## 🔒 Security Best Practices

### ✅ DO:
- Store tokens in GitHub Secrets
- Use bot tokens (not user tokens)
- Limit bot permissions to minimum needed
- Rotate tokens periodically
- Use separate tokens for dev/prod

### ❌ DON'T:
- Commit tokens to your repository
- Share tokens in chat/email
- Use personal access tokens
- Give excessive permissions
- Hardcode tokens in scripts

---

## 🐛 Troubleshooting

### No Slack Notification Received

**Check 1: Is the secret set?**
```bash
# In GitHub repo → Settings → Secrets → Actions
# Verify SLACK_TOKEN exists
```

**Check 2: Is the bot in the channel?**
```bash
# In Slack channel, type:
/invite @Aura Connect CI Bot
```

**Check 3: Check GitHub Actions logs**
```bash
# Go to Actions tab → Select failed run → Click "notify" job
# Look for error messages
```

**Common errors:**

1. **"channel_not_found"**
   - Solution: Invite bot to channel or use public channel

2. **"invalid_auth"**
   - Solution: Check token is correct and starts with `xoxb-`

3. **"not_in_channel"**
   - Solution: Invite bot to channel with `/invite`

### Notification Sent But Looks Wrong

**Problem**: Message formatting broken

**Solution**: Check `slack-notify.sh` for syntax errors:
```bash
# Test locally (requires bash)
bash scripts/slack-notify.sh
```

### Bot Token vs Webhook - Which to Use?

| Feature | Bot Token | Webhook |
|---------|-----------|---------|
| Setup complexity | Medium | Easy |
| Flexibility | High | Low |
| Channel switching | Yes | No |
| Message threading | Yes | No |
| User mentions | Yes | Limited |
| **Recommended** | ✅ Yes | For simple cases |

---

## 📊 Understanding Slack Message Colors

The script uses colors to indicate status:

- 🟢 **Green** (`good`): All tests passed
- 🟡 **Yellow** (`warning`): Some tests failed, but not critical
- 🔴 **Red** (`danger`): Pipeline failed

Colors are set in `determine_status()` function:

```bash
determine_status() {
  if [[ "$setup_result" == "failure" ]]; then
    echo "danger"  # Red
  elif [[ "$lint_result" == "failure" ]]; then
    echo "warning"  # Yellow
  else
    echo "good"  # Green
  fi
}
```

---

## 🎯 Next Steps

1. **Test the pipeline**: Push a commit and verify notification
2. **Customize messages**: Adjust format to your team's needs
3. **Add more channels**: Send to different channels for different events
4. **Set up alerts**: Configure @mentions for failures
5. **Track metrics**: Monitor test trends over time

---

## 📚 Additional Resources

- [Slack API Documentation](https://api.slack.com/)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Slack Message Formatting](https://api.slack.com/reference/surfaces/formatting)
- [Slack Block Kit Builder](https://app.slack.com/block-kit-builder)

---

## 💡 Pro Tips

1. **Use threads**: Reply to original message with detailed logs
2. **Add reactions**: Bot can add ✅ or ❌ reactions
3. **Interactive buttons**: Add "Rerun" or "Deploy" buttons
4. **Multiple channels**: Send to different channels based on branch
5. **Mention users**: Tag specific people on failures

---

Need help? Check the main guide: `docs/DEVOPS-GUIDE.md`
