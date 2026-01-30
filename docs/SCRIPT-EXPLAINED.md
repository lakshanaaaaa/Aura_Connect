# 🔍 Slack Notification Script - Line by Line Explanation

This document explains the `slack-notify.sh` script in detail, perfect for learning Bash scripting and DevOps practices.

---

## 📚 Script Overview

**Purpose**: Parse CI/CD results and send formatted notifications to Slack

**Language**: Bash (shell scripting)

**Runs on**: Ubuntu Linux (GitHub Actions runner)

**Input**: Environment variables + artifact files

**Output**: Slack notification message

---

## 🎯 Script Structure

```
1. Setup & Configuration (lines 1-15)
2. Helper Functions (lines 17-200)
   - parse_e2e_results()
   - parse_performance_metrics()
   - parse_unit_test_results()
   - determine_status()
   - build_enhanced_field_value()
   - build_field_value()
3. Main Execution (lines 202-300)
   - Parse metrics
   - Build message
   - Send to Slack
```

---

## 📖 Line-by-Line Breakdown

### Section 1: Shebang & Error Handling

```bash
#!/bin/bash
```
**What it does**: Tells the system to use Bash to run this script

**Why**: Different shells (sh, bash, zsh) have different features. We need Bash specifically.

---

```bash
set -e
```
**What it does**: Exit immediately if any command fails

**Why**: Prevents the script from continuing with errors. If `jq` fails, we want to know immediately.

**Example**:
```bash
# Without set -e
command_that_fails  # Script continues
echo "This runs"    # This still executes

# With set -e
command_that_fails  # Script stops here
echo "This runs"    # This never executes
```

---

### Section 2: Parse GitHub Context

```bash
GITHUB_SHA=$(echo "$GITHUB_CONTEXT" | jq -r '.sha')
```

**What it does**: Extracts the commit SHA from GitHub context JSON

**Breaking it down**:
- `$GITHUB_CONTEXT`: Environment variable containing JSON data
- `echo "$GITHUB_CONTEXT"`: Prints the JSON
- `|`: Pipe operator - sends output to next command
- `jq -r '.sha'`: JSON parser that extracts the `sha` field
- `$(...)`: Command substitution - captures output into variable

**Example**:
```bash
# Input (GITHUB_CONTEXT):
{"sha": "abc123", "ref_name": "main"}

# Command:
echo '{"sha": "abc123"}' | jq -r '.sha'

# Output:
abc123

# Stored in:
GITHUB_SHA="abc123"
```

**Why we need it**: To show which commit triggered the build in Slack

---

```bash
GITHUB_REF_NAME=$(echo "$GITHUB_CONTEXT" | jq -r '.ref_name')
GITHUB_ACTOR=$(echo "$GITHUB_CONTEXT" | jq -r '.actor')
GITHUB_EVENT_NAME=$(echo "$GITHUB_CONTEXT" | jq -r '.event_name')
GITHUB_WORKFLOW=$(echo "$GITHUB_CONTEXT" | jq -r '.workflow')
GITHUB_SERVER_URL=$(echo "$GITHUB_CONTEXT" | jq -r '.server_url')
GITHUB_REPOSITORY=$(echo "$GITHUB_CONTEXT" | jq -r '.repository')
GITHUB_RUN_ID=$(echo "$GITHUB_CONTEXT" | jq -r '.run_id')
```

**What they do**: Extract various GitHub metadata

- `ref_name`: Branch name (e.g., "main")
- `actor`: Who pushed the code (e.g., "john-doe")
- `event_name`: What triggered it (e.g., "push")
- `workflow`: Workflow name (e.g., "CI Pipeline")
- `server_url`: GitHub URL (e.g., "https://github.com")
- `repository`: Repo name (e.g., "user/repo")
- `run_id`: Unique workflow run ID

---

### Section 3: Parse E2E Results Function

```bash
parse_e2e_results() {
  local e2e_passed=0
  local e2e_failed=0
  local e2e_total=0
  local e2e_duration="0s"
```

**What it does**: Declares local variables (only exist inside this function)

**Why `local`**: Prevents variable name conflicts with other parts of the script

---

```bash
if [ -f "artifacts/e2e-test-results/e2e-output.log" ]; then
```

**What it does**: Checks if the E2E log file exists

**Breaking it down**:
- `[ ... ]`: Test command (like an if condition)
- `-f`: Test if file exists and is a regular file
- `"artifacts/..."`: Path to the file

**Other test operators**:
```bash
-f file   # File exists
-d dir    # Directory exists
-z string # String is empty
-n string # String is not empty
-eq       # Numbers are equal
```

---

```bash
local log_file="artifacts/e2e-test-results/e2e-output.log"
echo "📊 Found E2E output log: $log_file" >&2
```

**What it does**: 
- Stores file path in variable
- Prints debug message to stderr

**Why `>&2`**: Sends output to stderr (error stream) instead of stdout
- stdout: Normal output (captured by calling code)
- stderr: Error/debug messages (shown in logs but not captured)

---

```bash
e2e_passed=$(grep -oP '\K\d+(?=\s+passed)' "$log_file" | tail -1 2>/dev/null || \
             grep -oP 'Tests passed:\s*\K\d+' "$log_file" | tail -1 2>/dev/null || echo "0")
```

**What it does**: Extracts number of passed tests using regex

**Breaking it down**:
- `grep -oP`: Search with Perl regex, output only matching part
- `\K`: Keep everything before this (don't include in match)
- `\d+`: One or more digits
- `(?=\s+passed)`: Positive lookahead - must be followed by " passed"
- `tail -1`: Get last match (most recent)
- `2>/dev/null`: Suppress error messages
- `||`: OR operator - if first command fails, try next
- `echo "0"`: Default value if nothing found

**Example**:
```bash
# Input file content:
"5 passed, 0 failed"

# Command:
grep -oP '\K\d+(?=\s+passed)' file.txt

# Output:
5
```

**Why multiple patterns**: Different test frameworks format output differently

---

```bash
e2e_total=$((e2e_passed + e2e_failed))
```

**What it does**: Arithmetic operation in Bash

**Syntax**: `$(( expression ))`

**Examples**:
```bash
sum=$((5 + 3))        # 8
diff=$((10 - 4))      # 6
product=$((3 * 4))    # 12
quotient=$((10 / 2))  # 5
```

---

```bash
echo "$e2e_passed|$e2e_failed|$e2e_total|$e2e_duration"
```

**What it does**: Returns values separated by pipe character

**Why pipe-separated**: Easy to parse later with `IFS='|' read -r`

**Example output**: `5|0|5|45s`

---

### Section 4: Parse Performance Metrics Function

```bash
local lighthouse_dir="artifacts/performance-test-results/lighthouse-reports"

if [ -d "$lighthouse_dir" ]; then
```

**What it does**: Checks if directory exists

**`-d` test**: Returns true if path exists and is a directory

---

```bash
local json_report=$(find "$lighthouse_dir" -name "*.json" -type f | head -1)
```

**What it does**: Finds the first JSON file in the directory

**Breaking it down**:
- `find`: Search for files
- `"$lighthouse_dir"`: Where to search
- `-name "*.json"`: Files matching pattern
- `-type f`: Only regular files (not directories)
- `| head -1`: Take first result

---

```bash
if command -v jq >/dev/null 2>&1; then
```

**What it does**: Checks if `jq` command is available

**Breaking it down**:
- `command -v jq`: Returns path to jq if it exists
- `>/dev/null`: Discard stdout
- `2>&1`: Redirect stderr to stdout (also discarded)

**Why**: Gracefully handle missing dependencies

---

```bash
perf_score=$(jq -r '.categories.performance.score * 100 | floor' "$json_report" 2>/dev/null || echo "N/A")
```

**What it does**: Extracts performance score from JSON

**Breaking it down**:
- `jq -r`: Raw output (no quotes)
- `.categories.performance.score`: Navigate JSON structure
- `* 100`: Convert 0.92 to 92
- `| floor`: Round down to integer
- `2>/dev/null`: Suppress errors
- `|| echo "N/A"`: Default if extraction fails

**Example**:
```bash
# Input JSON:
{"categories": {"performance": {"score": 0.92}}}

# Command:
jq -r '.categories.performance.score * 100 | floor' file.json

# Output:
92
```

---

### Section 5: Determine Status Function

```bash
determine_status() {
  local setup_result="$1"
  local lint_result="$2"
  local test_results="$3"
  local performance_results="$4"
```

**What it does**: Accepts 4 parameters (job results)

**`$1, $2, $3, $4`**: Positional parameters (function arguments)

---

```bash
if [[ "$setup_result" == "failure" ]]; then
    echo "❌ CI Pipeline FAILED"
    echo "danger"
    return
fi
```

**What it does**: Checks if setup failed

**`[[ ... ]]`**: Enhanced test command (supports pattern matching)

**`return`**: Exit function early

**Why two echoes**: First line is status message, second is Slack color

---

```bash
if [[ "$lint_result" == "failure" ]] || [[ "$test_results" == *"failure"* ]]; then
```

**What it does**: Checks multiple conditions

**`||`**: Logical OR

**`*"failure"*`**: Pattern matching - contains "failure" anywhere

---

### Section 6: Build Enhanced Field Value

```bash
case "$job_type" in
    "e2e")
        # Handle E2E
        ;;
    "performance")
        # Handle performance
        ;;
    *)
        # Default case
        ;;
esac
```

**What it does**: Switch statement (like if-else chain)

**Syntax**:
```bash
case $variable in
    pattern1)
        commands
        ;;
    pattern2)
        commands
        ;;
    *)
        default commands
        ;;
esac
```

---

```bash
IFS='|' read -r passed failed total duration <<< "$metrics"
```

**What it does**: Splits pipe-separated string into variables

**Breaking it down**:
- `IFS='|'`: Internal Field Separator (what to split on)
- `read -r`: Read input without interpreting backslashes
- `passed failed total duration`: Variable names
- `<<<`: Here-string (feed string as input)
- `"$metrics"`: String to split (e.g., "5|0|5|45s")

**Example**:
```bash
# Input:
metrics="5|0|5|45s"

# Command:
IFS='|' read -r passed failed total duration <<< "$metrics"

# Result:
passed=5
failed=0
total=5
duration=45s
```

---

```bash
if [ "$total" -gt 0 ]; then
```

**What it does**: Numeric comparison

**Operators**:
```bash
-eq   # Equal
-ne   # Not equal
-gt   # Greater than
-ge   # Greater than or equal
-lt   # Less than
-le   # Less than or equal
```

---

### Section 7: Main Execution

```bash
echo "📊 Parsing test results and performance metrics..."
E2E_METRICS=$(parse_e2e_results)
PERF_METRICS=$(parse_performance_metrics)
UNIT_METRICS=$(parse_unit_test_results)
```

**What it does**: Calls functions and captures their output

**`$(function_name)`**: Command substitution - runs function and stores output

---

```bash
SETUP_RESULT="${SETUP_RESULT:-success}"
```

**What it does**: Use environment variable or default to "success"

**Syntax**: `${VAR:-default}`

**Examples**:
```bash
# If SETUP_RESULT is set:
SETUP_RESULT="failure"
value="${SETUP_RESULT:-success}"  # value="failure"

# If SETUP_RESULT is not set:
value="${SETUP_RESULT:-success}"  # value="success"
```

---

```bash
STATUS_INFO=$(determine_status "$SETUP_RESULT" "$LINT_RESULT" "$TEST_RESULTS" "$PERFORMANCE_RESULTS")
STATUS=$(echo "$STATUS_INFO" | head -n1)
COLOR=$(echo "$STATUS_INFO" | tail -n1)
```

**What it does**: Captures multi-line output and splits it

**Breaking it down**:
- Function returns 2 lines
- `head -n1`: Get first line (status message)
- `tail -n1`: Get last line (color)

---

### Section 8: Send to Slack

```bash
cat << EOF > slack_api_message.json
{
  "channel": "$SLACK_CHANNEL",
  "text": "$STATUS",
  ...
}
EOF
```

**What it does**: Creates JSON file using heredoc

**Heredoc syntax**:
```bash
cat << DELIMITER > file.txt
content here
variables like $VAR are expanded
DELIMITER
```

**Why**: Easier to write multi-line JSON than escaping quotes

---

```bash
curl -X POST -H "Authorization: Bearer $SLACK_TOKEN" \
     -H 'Content-type: application/json' \
     --data @slack_api_message.json \
     "https://slack.com/api/chat.postMessage"
```

**What it does**: Sends HTTP POST request to Slack API

**Breaking it down**:
- `curl`: Command-line HTTP client
- `-X POST`: HTTP method
- `-H "..."`: Add header
- `--data @file`: Send file contents as body
- `\`: Line continuation (makes long commands readable)

---

```bash
rm -f slack_api_message.json slack_webhook_message.json
```

**What it does**: Cleanup temporary files

**`-f`**: Force (don't error if file doesn't exist)

---

## 🎓 Key Bash Concepts Used

### 1. Variables
```bash
VAR="value"           # Set variable
echo "$VAR"           # Use variable
echo "${VAR}"         # Use variable (safer)
echo "${VAR:-default}" # Use or default
```

### 2. Command Substitution
```bash
result=$(command)     # Capture output
result=`command`      # Old syntax (avoid)
```

### 3. Pipes and Redirection
```bash
cmd1 | cmd2           # Pipe stdout
cmd > file            # Redirect stdout to file
cmd >> file           # Append stdout to file
cmd 2> file           # Redirect stderr to file
cmd &> file           # Redirect both to file
cmd 2>&1              # Redirect stderr to stdout
```

### 4. Test Conditions
```bash
[ condition ]         # Basic test
[[ condition ]]       # Enhanced test
test condition        # Same as [ ]
```

### 5. Functions
```bash
function_name() {
  local var="value"   # Local variable
  echo "$1"           # First parameter
  return 0            # Exit code
}
```

### 6. String Operations
```bash
${#string}            # Length
${string:0:5}         # Substring
${string/old/new}     # Replace first
${string//old/new}    # Replace all
```

### 7. Arrays
```bash
arr=(one two three)   # Create array
echo "${arr[0]}"      # First element
echo "${arr[@]}"      # All elements
echo "${#arr[@]}"     # Array length
```

---

## 🔍 Common Patterns Explained

### Pattern 1: Safe Variable Usage
```bash
# Bad (can break with spaces)
echo $VAR

# Good (always quote)
echo "$VAR"

# Best (handles undefined)
echo "${VAR:-default}"
```

### Pattern 2: Error Handling
```bash
# Try command, use default if fails
result=$(command 2>/dev/null || echo "default")

# Check if command succeeded
if command; then
  echo "Success"
else
  echo "Failed"
fi
```

### Pattern 3: File Checking
```bash
# Check before using
if [ -f "file.txt" ]; then
  cat "file.txt"
else
  echo "File not found"
fi
```

### Pattern 4: Parsing Output
```bash
# Extract specific data
value=$(echo "$json" | jq -r '.field')

# Parse multiple values
IFS='|' read -r var1 var2 var3 <<< "$data"
```

---

## 💡 Why This Script is Well-Written

1. **Error Handling**: `set -e` catches failures early
2. **Modularity**: Functions for each task
3. **Robustness**: Multiple fallback patterns
4. **Debugging**: Debug messages to stderr
5. **Flexibility**: Works with bot token or webhook
6. **Clean Code**: Clear variable names, comments
7. **Graceful Degradation**: Continues if optional data missing

---

## 🎯 Learning Exercises

### Exercise 1: Add New Metric
Add a function to parse security scan results:
```bash
parse_security_results() {
  local vulnerabilities=0
  # Your code here
  echo "$vulnerabilities"
}
```

### Exercise 2: Customize Message
Modify the Slack message to include your team name:
```bash
"footer": "Your Team Name - CI/CD"
```

### Exercise 3: Add Threshold Check
Add logic to fail if performance score < 80:
```bash
if [ "$perf_score" -lt 80 ]; then
  echo "Performance too low!"
  exit 1
fi
```

---

## 📚 Further Reading

- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [ShellCheck](https://www.shellcheck.net/) - Bash linter
- [jq Manual](https://stedolan.github.io/jq/manual/)
- [curl Documentation](https://curl.se/docs/)

---

**Now you understand every line of the script!** 🎉
