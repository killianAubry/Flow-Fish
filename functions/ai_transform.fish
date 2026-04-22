function ai_transform --description 'Convert an inline prompt into a shell command.'
    set -l input (commandline)

    if not string match -rq '^@' -- $input
        commandline -f execute
        return
    end

    set -l prompt (string replace -r '^@\s*' '' -- $input)
    commandline -r ''
    commandline -f repaint

    set -l body (jq -nc --arg p "Convert this into a Linux command. Output ONLY the command, no explanation, no backticks: $prompt" \
        '{model: "llama-3.1-8b-instant", messages: [{role: "user", content: $p}], max_tokens: 200}')

    set -l tmpfile (mktemp)
    curl -s https://api.groq.com/openai/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $GROQ_API_KEY" \
        -d "$body" >$tmpfile 2>/dev/null &
    set -l curl_pid $last_pid

    while kill -0 $curl_pid 2>/dev/null
        printf '\r\033[2K|' >/dev/tty
        sleep 0.1
        printf '\r\033[2K/' >/dev/tty
        sleep 0.1
        printf '\r\033[2K-' >/dev/tty
        sleep 0.1
        printf '\r\033[2K\\' >/dev/tty
        sleep 0.1
    end

    printf '\r\033[2K' >/dev/tty

    set -l raw (string collect <$tmpfile)
    rm -f $tmpfile

    set -l response (echo $raw | jq -r '.choices[0].message.content')

    if test -z "$response" -o "$response" = null
        return
    end

    commandline -r -- $response
end
