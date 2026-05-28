import json
import os

def process_medicines(input_file, output_file, limit=None):
    print(f"Reading {input_file}...")
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    print(f"Total records found: {len(data)}")
    
    processed = []
    for item in data:
        # Filter out discontinued if you want, but maybe keep them for reference
        # if item.get('Is_discontinued') == 'TRUE': continue
        
        # Extract only necessary fields to save space
        processed_item = {
            'n': item.get('name', ''),
            'c': f"{item.get('short_composition1', '')} {item.get('short_composition2', '')}".strip(),
            'p': float(item.get('price(₹)', 0)) if item.get('price(₹)') else 0,
            'm': item.get('manufacturer_name', ''),
            't': item.get('type', ''),
            's': item.get('pack_size_label', '')
        }
        processed.append(processed_item)
        
        if limit and len(processed) >= limit:
            break
            
    print(f"Writing {len(processed)} records to {output_file}...")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(processed, f, separators=(',', ':')) # Compact JSON
        
    print("Done!")

if __name__ == "__main__":
    input_path = "indian_medicine_data.json"
    output_path = "assets/data/medicines_compact.json"
    
    if not os.path.exists("assets/data"):
        os.makedirs("assets/data")
        
    if os.path.exists(input_path):
        # For the POC, let's limit to 50,000 to keep it manageable as an asset
        process_medicines(input_path, output_path, limit=50000)
    else:
        print(f"Error: {input_path} not found. Please wait for download to finish.")
