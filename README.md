## Features
- load: if load > then a value, store best 5 processes ordered by cpu
- load: kill process with highest cpu (optional)
- rediskeys if load > then a value, store patterns counts (requirements: redis-cli)
- optionals: send email, call a rest url, run a command (requirements: mail, curl)

## Usage
`bash SCRIPT.sh CONFIG`    
Example: `bash load.sh ./config`

## Config
**NOTE** You can use only one config for all scripts, or create a dedicated config

### Example (all scripts)
```
logs_dir=./logs
mail=false
mail_address=test@example.com
curl=false
curl_address=http://test.example.com/alert
curl_data='{"alert":"need check"}'

# load
load_trigger=0.5
kill=false
load_command="echo 'hello world'"

# rediskeys
redis_password=""
redis_host=""
redis_trigger=1000000
redis_patterns=( '*' 'test:*' )
redis_command=""
```
