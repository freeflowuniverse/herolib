# Groq AI Client Example

This example demonstrates how to use Groq's AI API with the herolib OpenAI client. Groq provides API compatibility with OpenAI's client libraries, allowing you to leverage Groq's fast inference speeds with minimal changes to your existing code.

## Prerequisites

- V programming language installed
- A Groq API key (get one from [Groq's website](https://console.groq.com/keys))

## Setup

1. Copy the `.env.example` file to `.env`:

```bash
cp .env.example .env
```

2. Edit the `.env` file and replace `your-groq-api-key-here` with your actual Groq API key.

3. Load the environment variables:

```bash
source .env
```

## Running the Example

Execute the script with:

```bash
v run groq_client.vsh
```

Or make it executable first:

```bash
chmod +x groq_client.vsh
./groq_client.vsh
```

## How It Works

The example uses the existing OpenAI client from herolib but configures it to use Groq's API endpoint:

1. It retrieves the Groq API key from the environment variables
2. Configures the OpenAI client with the Groq API key
3. Overrides the default OpenAI URL with Groq's API URL (`https://api.groq.com/openai/v1`)
4. Sends a chat completion request to Groq's API
5. Displays the response

## Supported Models

Groq supports various models including:

- llama2-70b-4096
- mixtral-8x7b-32768
- gemma-7b-it

For a complete and up-to-date list of supported models, refer to the [Groq API documentation](https://console.groq.com/docs/models).

## Notes

- The example uses the `gpt_3_5_turbo` enum from the OpenAI client, but Groq will automatically map this to an appropriate model on their end.
- For production use, you may want to explicitly specify one of Groq's supported models.