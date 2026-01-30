# ⚡ Quick Reference Card

## 🚀 Common Commands

### Test Pipeline Locally

```bash
# Run linting
cd backend && npm run lint
cd frontend && npm run lint

# Run tests
cd backend && npm test
cd frontend && npm test

# Check for issues before pushing
npm run lint && npm test
```

### Trigger Pipeline

```bash
# Push to main (triggers pipeline)
git push origin main

# Push to develop (triggers pipeline)
git push origin develop

# Create pull request (triggers pipeline)
git checkout -b feature/my-feature
git push origin feature/my-feature
# Then create PR on GitHub
```

### View Pipeline Status

```bash
# Open GitHub Actions in browser
# Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/actions

# Or use GitHub CLI
gh run list
gh run view
gh run watch
```

---

## 📋 Workflow File Locations

```
.github/workflows/ci.yml          # Main CI/CD workflow
scripts/slack-notify.sh           # Slack notification script
docs/DEVOPS-GUIDE.md              # Full documentation
docs/SLACK-SETUP.md               # Slack setup guide
```

---

## 🔧 Quick Fixes

### Pipeline Failing on Setup

```bash
# Fix: Update dependencies
cd backend && npm install
cd frontend && npm install

# Commit and push
git add package-lock.json
git commit -m "Update dependencies"
git push
```

### Linting Errors

```bash
# Auto-fix linting issues
npm run lint -- --fix

# Or manually fix and commit
git add .
git commit -m "Fix linting errors"
git push
```

### Tests Failing

```bash
# Run tests locally to debug
npm test

# Run specific test
npm test -- path/to/test.js

# Update snapshots if needed
npm test -- -u
```

---

## 🔑 GitHub Secrets

### Add Secret

1. Go to repo Settings
2. Secrets and variables → Actions
3. New repository secret
4. Add name and value
5. Save

### Required Secrets

```
SLACK_TOKEN           # Slack bot token (xoxb-...)
SLACK_WEBHOOK_URL     # Alternative to bot token
```

### Optional Secrets

```
MONGODB_URI           # Database connection
API_KEY               # External API keys
CLOUDINARY_URL        # Image hosting
```

---

## 📊 Slack Message Colors

```
🟢 Green (good)       = All tests passed
🟡 Yellow (warning)   = Some tests failed
🔴 Red (danger)       = Pipeline failed
```

---

## 🎯 Job Status Meanings

```
✅ Success            = Job completed without errors
❌ Failed             = Job encountered errors
⏭️ Skipped           = Job was skipped (dependency failed)
🔄 Running            = Job is currently executing
⏸️ Pending           = Job is waiting to start
```

---

## 📈 Performance Metrics

### Lighthouse Scores

```
90-100    = Excellent 🟢
50-89     = Needs improvement 🟡
0-49      = Poor 🔴
```

### Core Web Vitals

```
FCP (First Contentful Paint)
  Good: < 1.8s
  Needs improvement: 1.8s - 3s
  Poor: > 3s

LCP (Largest Contentful Paint)
  Good: < 2.5s
  Needs improvement: 2.5s - 4s
  Poor: > 4s

CLS (Cumulative Layout Shift)
  Good: < 0.1
  Needs improvement: 0.1 - 0.25
  Poor: > 0.25

TBT (Total Blocking Time)
  Good: < 200ms
  Needs improvement: 200ms - 600ms
  Poor: > 600ms
```

---

## 🔍 Debugging Commands

### View Workflow Logs

```bash
# Using GitHub CLI
gh run list                    # List recent runs
gh run view RUN_ID             # View specific run
gh run view RUN_ID --log       # View logs

# Or visit in browser
# https://github.com/USER/REPO/actions/runs/RUN_ID
```

### Download Artifacts

```bash
# Using GitHub CLI
gh run download RUN_ID

# Or download from GitHub Actions UI
# Actions → Select run → Artifacts section
```

### Check Slack Script Locally

```bash
# Make script executable
chmod +x scripts/slack-notify.sh

# Test script (requires bash)
bash scripts/slack-notify.sh
```

---

## 🛠️ Customization Snippets

### Change Node Version

Edit `.github/workflows/ci.yml`:
```yaml
env:
  NODE_VERSION: '20'  # Change from 18 to 20
```

### Add Environment Variable

```yaml
env:
  MY_VAR: 'my-value'
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

### Add New Job

```yaml
my-new-job:
  name: 🎯 My New Job
  runs-on: ubuntu-latest
  needs: setup
  steps:
    - name: Checkout
      uses: actions/checkout@v4
    - name: Do something
      run: echo "Hello!"
```

### Change Slack Channel

```yaml
env:
  SLACK_CHANNEL: '#my-channel'
```

---

## 📞 Useful Links

```
GitHub Actions:
  https://github.com/YOUR_USERNAME/YOUR_REPO/actions

Slack API:
  https://api.slack.com/apps

Lighthouse:
  https://developers.google.com/web/tools/lighthouse

GitHub Secrets:
  https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions
```

---

## 🎓 Learning Resources

```
GitHub Actions Docs:
  https://docs.github.com/en/actions

Slack API Docs:
  https://api.slack.com/

DevOps Roadmap:
  https://roadmap.sh/devops

CI/CD Best Practices:
  https://www.atlassian.com/continuous-delivery
```

---

## 🚨 Emergency Procedures

### Pipeline Stuck/Hanging

```bash
# Cancel running workflow
gh run cancel RUN_ID

# Or use GitHub UI
# Actions → Select run → Cancel workflow
```

### Disable Workflow Temporarily

```bash
# Rename workflow file
mv .github/workflows/ci.yml .github/workflows/ci.yml.disabled

# Commit and push
git add .github/workflows/
git commit -m "Temporarily disable CI"
git push
```

### Re-enable Workflow

```bash
# Rename back
mv .github/workflows/ci.yml.disabled .github/workflows/ci.yml

# Commit and push
git add .github/workflows/
git commit -m "Re-enable CI"
git push
```

---

## 📝 Common Patterns

### Run Job Only on Main Branch

```yaml
if: github.ref == 'refs/heads/main'
```

### Run Job Only on Pull Requests

```yaml
if: github.event_name == 'pull_request'
```

### Run Job on Schedule

```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight
```

### Matrix Build (Multiple Versions)

```yaml
strategy:
  matrix:
    node-version: [16, 18, 20]
steps:
  - uses: actions/setup-node@v4
    with:
      node-version: ${{ matrix.node-version }}
```

---

## 🎯 Checklist for New Features

Before pushing:
- [ ] Code passes linting locally
- [ ] Tests pass locally
- [ ] No console errors
- [ ] Documentation updated
- [ ] Commit message is clear

After pushing:
- [ ] Check GitHub Actions status
- [ ] Review Slack notification
- [ ] Check detailed logs if failed
- [ ] Fix issues and push again

---

## 💡 Pro Tips

1. **Use `--fix` flag**: Auto-fix linting issues
   ```bash
   npm run lint -- --fix
   ```

2. **Run tests in watch mode locally**:
   ```bash
   npm test -- --watch
   ```

3. **Check coverage locally**:
   ```bash
   npm test -- --coverage
   ```

4. **Use GitHub CLI for faster workflow**:
   ```bash
   gh run watch  # Watch current run
   ```

5. **Cache dependencies for faster builds**:
   Already configured in workflow!

6. **Use `continue-on-error` for non-critical jobs**:
   ```yaml
   continue-on-error: true
   ```

---

## 🔄 Workflow Lifecycle

```
1. Push code
2. GitHub detects push
3. Workflow triggered
4. Jobs run in parallel
5. Artifacts uploaded
6. Notification sent
7. Team notified
```

---

## 📊 Monitoring Metrics

Track these over time:
- Build success rate
- Average build duration
- Test coverage percentage
- Performance scores
- Failed test patterns

---

## 🎉 Success Indicators

Your pipeline is working well when:
- ✅ Builds complete in < 10 minutes
- ✅ Success rate > 90%
- ✅ Team responds to notifications
- ✅ Bugs caught before production
- ✅ Deployments are confident

---

**Keep this card handy for quick reference!** 📌
