# Gunakan `python:3.11.4` sebagai base image
FROM python:3.11.4

# Setting working direktory
WORKDIR /api

# Copy lokasi working directory ke container /api
COPY . /api

# install dependecies yang dibutuhkan yang tertera pada file requrements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Setting container untuk membuka jalur pada port 6000
EXPOSE 6000

# Run api.py saat container diaktifkan.
CMD ["python", "api.py"]
