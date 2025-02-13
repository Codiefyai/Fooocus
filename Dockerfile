FROM python:3.10-slim-buster  # Or a suitable Python version

WORKDIR /app

# Install system dependencies (if needed - check Fooocus docs/requirements)
# Example for common image libraries:
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     libgl1-mesa-glx \
#     libglib2.0-0 \
#     && rm -rf /var/lib/apt/lists/*

# Copy repository files
COPY . /app/

# Install Conda (if required by Fooocus - based on your commands)
RUN apt-get update && apt-get install -y wget bzip2
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    /bin/bash miniconda.sh -b -p /miniconda && \
    rm miniconda.sh
ENV PATH="/miniconda/bin:${PATH}"

# Create and activate Conda environment
RUN conda env create -f environment.yaml
SHELL ["conda", "run", "-n", "fooocus", "/bin/bash", "-c"] # Set shell for subsequent RUN commands to use conda env

# Install specific requirements versions
RUN pip install -r requirements_versions.txt

# Expose the port Fooocus uses (default 7860)
EXPOSE 7860

# Command to run Fooocus (adjust as needed based on Fooocus documentation)
CMD ["python", "entry_points/webui.py", "--listen"] # Important: Add --listen for Render to access it
