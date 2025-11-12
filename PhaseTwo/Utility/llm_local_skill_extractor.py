from transformers import AutoTokenizer, LlamaForCausalLM
from huggingface_hub import login
import torch

login()

torch.multiprocessing.set_start_method('spawn', force=True)
torch.no_grad()
device = "cuda" if torch.cuda.is_available() else "cpu"

model_name_or_path = "meta-llama/Llama-3.1-8B-Instruct"

tokenizer = AutoTokenizer.from_pretrained(model_name_or_path, device_map=device)
tokenizer.pad_token = tokenizer.eos_token

model = LlamaForCausalLM.from_pretrained(model_name_or_path,
                                            device_map='auto',
                                            dtype=torch.bfloat16)
model.generation_config.min_new_tokens = 10
model.generation_config.max_new_tokens = 128
model.generation_config.do_sample = True
model.generation_config.num_return_sequences = 1

few_shot_prompt = [
    {
        "role": "system",
        "content":
        """You are a skill extraction model.
        Extract 1-3 relevant HARD skills in a simple comma-separated list with each skill being 1-2 words.
        Do NOT extract soft skills (e.g., \"communication,\" \"scheduling,\" etc. are examples of soft skills and not hard skills)"""
    }

]

import pandas as pd

df = pd.read_csv('../Data/new_england_indeed_jobs.csv')

def extract_skills(row):
    desc = row['description']
    prompt = few_shot_prompt + [{"role": "user", "content": desc}]
    tokenized_prompt = tokenizer.apply_chat_template(prompt, add_generation_prompt=True, return_tensors='pt', padding=True).to(device=device)
    output_tokens = model.generate(inputs=tokenized_prompt,
                            generation_config=model.generation_config,
                            pad_token_id=tokenizer.eos_token_id)
    output_decoded = tokenizer.batch_decode(output_tokens[:, tokenized_prompt.shape[1]:], skip_special_tokens=True)[0]
    print(output_decoded + '\n\n')
    torch.cuda.empty_cache()
    return output_decoded

from tqdm import tqdm

tqdm.pandas()

df['skills'] = df.progress_apply(extract_skills, axis=1)

df.to_csv('../Data/new_england_indeed_jobs.csv', index=False)