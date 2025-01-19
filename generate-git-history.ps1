# Script to generate realistic Git history for LinkedIn Clone project
# Phase 1: Jan 19 - Feb 27, 2025 (Small/basic commits)
# Phase 2: Mar 9 - May 15, 2025 (Heavy commit days)

# Initialize git if not already initialized
if (-not (Test-Path ".git")) {
    git init
    Write-Host "Git repository initialized"
}

# Configure git user (change these if needed)
git config user.name "lakshanaaaaa"
git config user.email "lakshanasampath916@gmail.com"

# Function to create a commit with a specific date
function Make-Commit {
    param(
        [string]$Message,
        [string]$Date
    )
    
    $env:GIT_AUTHOR_DATE = $Date
    $env:GIT_COMMITTER_DATE = $Date
    
    git add .
    git commit -m $Message --allow-empty
    
    Remove-Item Env:\GIT_AUTHOR_DATE
    Remove-Item Env:\GIT_COMMITTER_DATE
}

# Function to get random time
function Get-RandomTime {
    $hour = Get-Random -Minimum 9 -Maximum 22
    $minute = Get-Random -Minimum 0 -Maximum 60
    return "{0:D2}:{1:D2}:00" -f $hour, $minute
}

# Comprehensive commit messages pool
$commitMessages = @{
    "setup" = @(
        "Initial project setup with Express and React",
        "Configure MongoDB connection",
        "Setup environment variables",
        "Add project dependencies",
        "Configure Vite build tools",
        "Setup TailwindCSS and DaisyUI",
        "Configure ESLint and Prettier",
        "Add Git ignore file"
    )
    "models" = @(
        "Create User model",
        "Add Post model with references",
        "Create Connection Request model",
        "Add Notification model",
        "Create Contest model",
        "Update user schema with new fields",
        "Add indexes to models for performance",
        "Create Message model",
        "Add Job model",
        "Update post schema"
    )
    "auth" = @(
        "Implement user authentication",
        "Add JWT token generation",
        "Create login endpoint",
        "Add signup validation",
        "Implement logout functionality",
        "Add password hashing with bcrypt",
        "Create auth middleware",
        "Add token refresh mechanism",
        "Implement session management",
        "Add email verification",
        "Fix authentication bug",
        "Update auth routes"
    )
    "components" = @(
        "Create navbar component",
        "Add post card component",
        "Create sidebar widget",
        "Add profile header component",
        "Create comment component",
        "Add notification dropdown",
        "Create modal component",
        "Add button components",
        "Create form input components",
        "Add loading spinner",
        "Create user card component",
        "Add search bar component"
    )
    "pages" = @(
        "Create home page",
        "Add login page",
        "Create signup page",
        "Add profile page",
        "Create notifications page",
        "Add connections page",
        "Create settings page",
        "Add messages page",
        "Create job listings page",
        "Add contest calendar page"
    )
    "features" = @(
        "Implement post creation",
        "Add like functionality",
        "Create comment system",
        "Add image upload with Cloudinary",
        "Implement connection requests",
        "Add notification system",
        "Create user profile editing",
        "Implement search functionality",
        "Add infinite scroll",
        "Create news feed",
        "Implement post sharing",
        "Add hashtag support",
        "Create messaging feature",
        "Add job postings",
        "Implement saved posts",
        "Create company pages",
        "Add follow system",
        "Implement post deletion",
        "Add profile picture upload",
        "Create banner upload"
    )
    "ui" = @(
        "Add responsive design",
        "Implement dark mode",
        "Add loading skeletons",
        "Create toast notifications",
        "Add mobile menu",
        "Implement dropdown menus",
        "Add animations",
        "Update color scheme",
        "Improve spacing",
        "Update typography",
        "Add hover effects",
        "Improve button styles",
        "Update card design",
        "Add transitions",
        "Improve form styling"
    )
    "fixes" = @(
        "Fix authentication bug",
        "Resolve image upload issue",
        "Fix responsive layout",
        "Correct API endpoint",
        "Fix memory leak",
        "Resolve CORS issue",
        "Fix date formatting",
        "Correct validation error",
        "Fix infinite loop",
        "Resolve race condition",
        "Fix styling issue",
        "Correct typo in component",
        "Fix broken link",
        "Resolve dependency conflict",
        "Fix navbar overflow",
        "Resolve modal z-index issue"
    )
    "improvements" = @(
        "Optimize database queries",
        "Improve error handling",
        "Refactor auth controller",
        "Enhance UI responsiveness",
        "Optimize image loading",
        "Improve code structure",
        "Add input validation",
        "Enhance security",
        "Optimize bundle size",
        "Improve accessibility",
        "Add loading states",
        "Enhance user feedback",
        "Improve performance",
        "Refactor components",
        "Add error boundaries"
    )
    "api" = @(
        "Create user endpoints",
        "Add post API routes",
        "Implement connection API",
        "Create notification endpoints",
        "Add search API",
        "Implement messaging API",
        "Create job API routes",
        "Add contest endpoints",
        "Update API documentation",
        "Add rate limiting"
    )
    "styling" = @(
        "Update color scheme",
        "Add animations",
        "Improve spacing",
        "Update typography",
        "Add hover effects",
        "Improve button styles",
        "Update card design",
        "Add transitions",
        "Improve form styling",
        "Update icon set",
        "Add gradient backgrounds",
        "Improve shadow effects"
    )
    "backend" = @(
        "Setup Express server",
        "Configure middleware",
        "Add error handling middleware",
        "Implement validation middleware",
        "Create database connection",
        "Add Cloudinary config",
        "Setup email service",
        "Configure CORS",
        "Add security headers",
        "Implement logging"
    )
    "frontend" = @(
        "Setup React Router",
        "Configure React Query",
        "Add context providers",
        "Create custom hooks",
        "Setup Axios interceptors",
        "Add protected routes",
        "Configure state management",
        "Create utility functions",
        "Add form validation",
        "Setup error handling"
    )
}

# Phase 1: Jan 19 - Feb 27, 2025
# Pattern: 2-3 days with commits, 2 days off, 5 days with commits, 2 days off
# 1-2 commits per active day

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PHASE 1: Jan 19 - Feb 27, 2025" -ForegroundColor Cyan
Write-Host "Small/basic commits (frontend setup, components)" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$phase1Start = Get-Date "2025-01-19"
$phase1End = Get-Date "2025-02-27"
$phase1Commits = @()

$currentDate = $phase1Start
$patternIndex = 0
$patterns = @(
    @{Days = 2; Active = $true},   # 2-3 days with commits
    @{Days = 3; Active = $true},
    @{Days = 2; Active = $false},  # 2 days off
    @{Days = 5; Active = $true},   # 5 days with commits
    @{Days = 2; Active = $false}   # 2 days off
)

while ($currentDate -le $phase1End) {
    $pattern = $patterns[$patternIndex % $patterns.Count]
    
    for ($i = 0; $i -lt $pattern.Days -and $currentDate -le $phase1End; $i++) {
        $dateStr = $currentDate.ToString("yyyy-MM-dd")
        
        if ($pattern.Active) {
            # 1-2 commits per day
            $numCommits = Get-Random -Minimum 1 -Maximum 3
            
            for ($j = 0; $j -lt $numCommits; $j++) {
                $time = Get-RandomTime
                $fullDate = "$dateStr $time"
                
                # Select appropriate message for Phase 1
                $categories = @("setup", "components", "pages", "models", "auth", "backend", "frontend", "ui")
                $category = $categories | Get-Random
                $message = $commitMessages[$category] | Get-Random
                
                $phase1Commits += @($fullDate, $message)
            }
        }
        
        $currentDate = $currentDate.AddDays(1)
    }
    
    $patternIndex++
}

Write-Host "Phase 1 commits generated: $($phase1Commits.Count / 2)" -ForegroundColor Green

# Phase 2: Mar 9 - May 15, 2025
# Heavy commit days with specific distribution

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "PHASE 2: Mar 9 - May 15, 2025" -ForegroundColor Cyan
Write-Host "Heavy commit days (max 10 commits/day)" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$phase2Start = Get-Date "2025-03-09"
$phase2End = Get-Date "2025-05-15"
$phase2Commits = @()

# Get all dates in Phase 2
$allPhase2Dates = @()
$currentDate = $phase2Start
while ($currentDate -le $phase2End) {
    $allPhase2Dates += $currentDate
    $currentDate = $currentDate.AddDays(1)
}

# Randomly select days for specific commit counts
$totalDays = $allPhase2Dates.Count
$availableDays = 0..($totalDays - 1)

# Select 15 random days for 7 commits
$days7commits_set1 = $availableDays | Get-Random -Count 15
$availableDays = $availableDays | Where-Object { $days7commits_set1 -notcontains $_ }

# Select 12 random days for 7 commits (second set)
$days7commits_set2 = $availableDays | Get-Random -Count 12
$availableDays = $availableDays | Where-Object { $days7commits_set2 -notcontains $_ }

# Select 12 random days for 2 commits
$days2commits = $availableDays | Get-Random -Count 12
$availableDays = $availableDays | Where-Object { $days2commits -notcontains $_ }

# Select 5 continuous days for NO commits
$noCommitStart = Get-Random -Minimum 0 -Maximum ($availableDays.Count - 5)
$noCommitDays = $availableDays[$noCommitStart..($noCommitStart + 4)]
$availableDays = $availableDays | Where-Object { $noCommitDays -notcontains $_ }

Write-Host "Distribution:" -ForegroundColor Yellow
Write-Host "  - 15 days with 7 commits" -ForegroundColor Gray
Write-Host "  - 12 days with 7 commits" -ForegroundColor Gray
Write-Host "  - 12 days with 2 commits" -ForegroundColor Gray
Write-Host "  - 5 continuous days with NO commits" -ForegroundColor Gray
Write-Host "  - Remaining days: 4-6 commits`n" -ForegroundColor Gray

# Generate commits for Phase 2
for ($i = 0; $i -lt $allPhase2Dates.Count; $i++) {
    $date = $allPhase2Dates[$i]
    $dateStr = $date.ToString("yyyy-MM-dd")
    
    # Determine number of commits for this day
    $numCommits = 0
    if ($noCommitDays -contains $i) {
        $numCommits = 0
    } elseif ($days7commits_set1 -contains $i -or $days7commits_set2 -contains $i) {
        $numCommits = 7
    } elseif ($days2commits -contains $i) {
        $numCommits = 2
    } else {
        $numCommits = Get-Random -Minimum 4 -Maximum 7
    }
    
    # Generate commits for this day
    $usedTimes = @()
    for ($j = 0; $j -lt $numCommits; $j++) {
        do {
            $time = Get-RandomTime
        } while ($usedTimes -contains $time)
        $usedTimes += $time
        
        $fullDate = "$dateStr $time"
        
        # Select appropriate message for Phase 2 (more advanced features)
        $categories = @("features", "api", "improvements", "fixes", "styling", "ui", "backend", "frontend")
        $category = $categories | Get-Random
        $message = $commitMessages[$category] | Get-Random
        
        $phase2Commits += @($fullDate, $message)
    }
}

Write-Host "Phase 2 commits generated: $($phase2Commits.Count / 2)" -ForegroundColor Green

# Combine all commits
$allCommits = $phase1Commits + $phase2Commits

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "TOTAL COMMITS: $($allCommits.Count / 2)" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Starting commit creation...`n" -ForegroundColor Yellow

# Create all commits
$count = 0
for ($i = 0; $i -lt $allCommits.Count; $i += 2) {
    $date = $allCommits[$i]
    $message = $allCommits[$i + 1]
    
    Make-Commit -Message $message -Date $date
    $count++
    
    if ($count % 25 -eq 0) {
        Write-Host "Created $count commits..." -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Git history created successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Total commits: $count" -ForegroundColor Cyan
Write-Host "Phase 1 (Jan 19 - Feb 27): Basic setup" -ForegroundColor Cyan
Write-Host "Phase 2 (Mar 9 - May 15): Heavy development" -ForegroundColor Cyan
Write-Host "`nView history with: git log --oneline --graph" -ForegroundColor Magenta
Write-Host "View by date: git log --pretty=format:'%h %ad | %s' --date=short" -ForegroundColor Magenta
