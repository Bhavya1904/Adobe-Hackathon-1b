# PDF Information Extraction and Ranking

This project provides a modular solution for extracting and ranking relevant information from a collection of PDF documents. It identifies the most important sections based on a given persona and task, then extracts and analyzes their content.

## Approach Overview

1. **PDF Parsing & Heading Extraction**  
    - Uses `pymupdf` to parse PDFs and extract text blocks with metadata (font size, boldness, etc.).
    - Heuristics identify headings (large/bold fonts, uppercase, numbered patterns, etc.).
    - Filters out irrelevant text (page numbers, URLs, bullets).

2. **Semantic Ranking of Topics**  
    - Uses `sentence-transformers` to embed context (persona, task, description) and headings.
    - Ranks PDFs and headings by cosine similarity to the context.
    - Selects the top 5 most relevant section titles.

3. **Subsection Extraction**  
    - Extracts text between identified headings using regular expressions.
    - Cleans extracted text to remove PDF artifacts.

4. **Workflow**  
    - Loads persona, task, and PDF list from an input JSON file.
    - Extracts and ranks headings, then extracts and analyzes top sections.
    - Outputs results to a JSON file.

## Limitations & Future Improvements

- Heading identification is heuristic-based; ML models could improve accuracy.
- Subsection extraction may miss complex structures.
- Tables/figures are not explicitly handled.
- More robust error handling can be added.

## Usage Instructions

### 1. Prepare Your Files

- **Input JSON:**  
  Name your input JSON file exactly as `Challenge1b_input.json` (case-sensitive).  
  Place it in the project root directory.

- **PDF Files:**  
  Place all input PDFs inside a folder named `input` in the project root.

### 2. Directory Structure

```
your_project_folder/
├── Dockerfile
├── your_script_name.py
├── requirements.txt
├── Challenge1b_input.json
└── input/
     ├── your_pdf_file1.pdf
     ├── your_pdf_file2.pdf
     └── ...
```

### 3. Docker Setup

#### Dockerfile

Create a `Dockerfile` in your project root:

```dockerfile
FROM python:3.9-slim-buster
WORKDIR /app
RUN apt-get update && apt-get install -y \
     libgl1-mesa-glx \
     libgomp1 \
     && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "your_script_name.py"]
```
> Replace `your_script_name.py` with your actual script filename.

#### requirements.txt

```
pymupdf
sentence-transformers
scikit-learn
torch
```

### 4. Build and Run

**Build the Docker image:**
```bash
docker build -t pdf-processor .
```

**Run the container:**
```bash
docker run --name my-pdf-processing-run pdf-processor
```

**Retrieve the output:**
```bash
docker cp my-pdf-processing-run:/app/challenge1b_output.json .
```

**(Optional) Remove the container:**
```bash
docker rm my-pdf-processing-run
```

---

**Note:**  
- The script expects the input JSON to be named `Challenge1b_input.json` and PDFs to be in the `input` folder.
- The output will be saved as `challenge1b_output.json` in the container's `/app` directory.
- Here's what each command does:

1. **`docker build -t pdf-processor:latest .`**
   - Builds a Docker image from the Dockerfile in the current directory and tags it as "pdf-processor:latest"

2. **`docker run -v "$(pwd)/input:/app/input" -v "$(pwd):/app/output" --rm pdf-processor:latest`**
   - Runs the container, mounts your local `input` folder to `/app/input` inside container and current directory to `/app/output`, then automatically deletes the container when done

3. **`docker run --name pdf-proc -v "$(pwd):/app" pdf-processor:latest`**
   - Runs the container with name "pdf-proc", mounts your entire current directory to `/app` inside the container (so container can read/write files directly to your local folder)

The third command is the most useful as it gives the container full access to your project directory.
