FROM python:3

WORKDIR /data_dir

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update
RUN apt-get install vim -y

COPY . .

CMD [ "python", "/data_dir/main.py" ]
