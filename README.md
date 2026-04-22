# Flow-Fish

Flow-Fish adds an AI-powered fish shell autocomplete flow.

Type a command line starting with `@` and press `Enter`. The prompt is sent to Groq and replaced with the generated shell command.

## Requirements

- fish shell
- `curl`
- `jq`
- A `GROQ_API_KEY` environment variable

## Setup

1. Clone this repo into your fish config directory or as a plugin source.
2. Make sure this repo is on fish's function path.
3. Restart fish.
4. Export your Groq API key:

```fish
set -Ux GROQ_API_KEY your_key_here
```

## Example

```fish
@ list the 10 largest files in the current directory
```

Press `Enter` and the generated command will replace the prompt input.

## Notes

- The default model is `llama-3.1-8b-instant`.
- The binding preserves existing Pure theme key bindings when `__pure_key_bindings` is available.
