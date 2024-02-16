FROM python:3.12-slim-bookworm

RUN apt-get update && apt-get install -y libpq-dev gcc

WORKDIR bergsolawi

COPY . .

RUN pip install -r requirements.txt

ENV JUNTAGRICO_SECRET_KEY="TEST_KEY"

# Setup DB
RUN ./manage.py migrate

# Setup admin user
RUN ./manage.py createsuperuser && ./manage.py create_member_for_superusers

# Create Testdata
RUN ./manage.py generate_testdata_advanced

CMD ./manage.py runserver
