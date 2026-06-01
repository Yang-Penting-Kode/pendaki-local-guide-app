import os
import re
import random
import string

directory = 'lib'
count = 0

def get_random_seed():
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=6))

def replace_unsplash(match):
    seed = get_random_seed()
    return f"https://picsum.photos/seed/{seed}/600/400"

for root, _, files in os.walk(directory):
    for file in files:
        if not file.endswith('.dart'):
            continue
        filepath = os.path.join(root, file)
        
        with open(filepath, 'r') as f:
            content = f.read()
            
        # Regex to match unsplash URLs:
        # https://images.unsplash.com/ followed by non-whitespace, non-quotes
        new_content, num_subs = re.subn(r'https://images\.unsplash\.com/[^\s\'"]+', replace_unsplash, content)
        
        if num_subs > 0:
            with open(filepath, 'w') as f:
                f.write(new_content)
            count += 1
            print(f"Modified: {filepath}")

print(f"Total modified files: {count}")
