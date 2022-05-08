FROM python:3-slim

WORKDIR /app

COPY *requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

USER nobody

ENV FLASK_APP=service.api:app

CMD [ "flask", "run", "--host", "0.0.0.0" ]
EXPOSE 5000
