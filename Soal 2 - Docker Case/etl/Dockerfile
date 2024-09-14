# Gunakan `python:3.11.4` sebagai base image
FROM python:3.11.4

# Setting working direktory
WORKDIR /etl

# Copy lokasi working directory ke container /etl
COPY . /etl

# install dependecies yang dibutuhkan yang tertera pada file requrements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Run etl.py saat container diaktifkan.
CMD ["python", "etl.py"]