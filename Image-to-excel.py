import pytesseract
from PIL import Image
import pandas as pd
import re

# ✅ Step 1: Path to Tesseract executable
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

# ✅ Step 2: Load your image
image_path = r"C:\Users\dell\Downloads\PHOTO-2025-06-19-17-43-28.jpg"
image = Image.open(image_path)

# ✅ Step 3: Extract text from image
raw_text = pytesseract.image_to_string(image)

# ✅ Step 4: Parse the text
structured_data = []
entries = raw_text.split("Guarantor:")
for entry in entries[1:]:
    try:
        lines = entry.strip().split('\n')
        first_line = lines[0]

        ref_match = re.search(r'\d{10,}', first_line)
        customer_ref = ref_match.group() if ref_match else ""

        name_parts = first_line.replace(customer_ref, "").strip().rsplit(" ", 2)
        customer_name = " ".join(name_parts[:-2]) if len(name_parts) >= 3 else ""
        city = name_parts[-2] if len(name_parts) >= 2 else ""
        state = name_parts[-1] if len(name_parts) >= 2 else ""

        purchase_value = ""
        for line in lines:
            if "Dollars" in line and "Cents" in line:
                purchase_value = line.strip()
                break

        loan_period = re.search(r'(\d+|[A-Za-z]+)\s+Years', entry)
        interest = re.search(r'(\d+\.?\d*)\s*%', entry)
        guarantor = re.search(r'(Mr\.|Mrs\.|Ms\.|Dr\.)\s+[A-Z][a-z]+.*', entry)

        structured_data.append([
            customer_ref,
            customer_name,
            city,
            state,
            purchase_value,
            "",  # Down Payment
            loan_period.group(0) if loan_period else "",
            interest.group(1) + "%" if interest else "",
            guarantor.group(0).strip() if guarantor else "",
            ""  # Guarantor Reference
        ])

    except Exception as e:
        print(f"❌ Error parsing entry: {e}")

# ✅ Step 5: Create Excel
df = pd.DataFrame(structured_data, columns=[
    "Customer Reference Number", "Customer Name", "City", "State",
    "Purchase Value", "Down Payment", "Loan Period",
    "Annual Interest In Percentage", "Guarantor Name", "Guarantor Reference Number"
])

df.to_excel("structured_output.xlsx", index=False)
print("✅ Excel file saved as: structured_output.xlsx")



entries = raw_text.split("Guarantor:")


print("OCR Text:\n", raw_text)




from PIL import Image
import pytesseract
import pandas as pd

pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

image = Image.open(r"C:\Users\dell\Downloads\PHOTO-2025-06-19-17-43-28.jpg")
raw_text = pytesseract.image_to_string(image)
print("Extracted Text:\n", raw_text)

# Save line-by-line for debugging
lines = [line.strip() for line in raw_text.split('\n') if line.strip()]
df = pd.DataFrame(lines, columns=["Extracted Text"])
df.to_excel("ocr_debug_output.xlsx", index=False)
print("✅ OCR debug output saved!")

