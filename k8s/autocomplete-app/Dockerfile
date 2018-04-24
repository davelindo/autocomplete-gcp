FROM python:3.6.5-alpine3.6

RUN pip install flask elasticsearch redis wtforms

COPY ./app /app/
RUN ["chmod", "+x", "/app/run.sh"]

WORKDIR /app/
CMD [ "/app/run.sh" ]

EXPOSE 5000