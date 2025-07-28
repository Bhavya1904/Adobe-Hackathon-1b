# 1. Use official Python image
FROM python:3.10-slim

# 2. Set working directory
WORKDIR /app

# 3. Install system dependencies (for PyMuPDF & transformers)
RUN apt-get update && apt-get install -y \
    build-essential \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# 4. Copy requirement file and install dependencies
COPY requirements.txt .
RUN pip install "numpy<2.0"

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install sentence-transformers
# 5. Copy project files
COPY . .

# 6. Set default command
CMD ["python", "main.py"]
