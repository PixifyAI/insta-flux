import gradio as gr
import asyncio
from runware import Runware, IImageInference

RUNWARE_API_KEY = "RUNWARE_API_KEY"

# Async function to generate image based on input parameters
async def generate_image(prompt, model, numberResults, negativePrompt, useCache, height, width):
    try:
        runware = Runware(api_key=RUNWARE_API_KEY)
        await runware.connect()

        request_image = IImageInference(
            positivePrompt=prompt,
            model=model,
            numberResults=numberResults,
            negativePrompt=negativePrompt,
            useCache=useCache,
            height=height,
            width=width,
        )

        images = await runware.imageInference(requestImage=request_image)
        if images:
            return images[0].imageURL
        else:
            return None
    except Exception as e:
        print(f"Error: {e}")
        return None

# Synchronous wrapper to run the async function
def generate(prompt, model, numberResults, negativePrompt, useCache, height, width):
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    image_url = loop.run_until_complete(generate_image(prompt, model, numberResults, negativePrompt, useCache, height, width))

    if image_url:
        return image_url
    else:
        return "No image generated."

# Gradio UI with additional settings
interface = gr.Interface(
    fn=generate,
    inputs=[
        gr.Textbox(label="Enter your prompt"),
        gr.Textbox(label="Model", value="runware:101@1"),  # Model input
        gr.Slider(label="Number of Results", minimum=1, maximum=10, step=1, value=1),  # Number of results
        gr.Textbox(label="Negative Prompt", value=""),  # Negative prompt
        gr.Checkbox(label="Use Cache", value=False),  # Cache option
        gr.Slider(label="Height", minimum=256, maximum=2048, step=64, value=512),  # Image height
        gr.Slider(label="Width", minimum=256, maximum=2048, step=64, value=512),  # Image width
    ],
    outputs=gr.Image(label="Flux Generated Image"),
    title="InstaFlux",
    description="A simple Flux image generator using Runware API (runware:101@1 is flux.dev 6 sec / runware:100@1 is fastflux 3 sec)"
)

interface.launch()