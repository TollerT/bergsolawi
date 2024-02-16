# Container for local testing
#
# Build:
# docker build -t bergsolawi .
#
# Run the container with docker:
# docker run -it -p 8000:8000 bergsolawi
#
# Now you can access it on 0.0.0.0:8000

FROM python:3.8-slim-bookworm

RUN apt-get update && apt-get install -y libpq-dev gcc

WORKDIR bergsolawi

COPY bergsolawi bergsolawi
COPY requirements.txt manage.py ./

RUN pip install -r requirements.txt

ENV JUNTAGRICO_SECRET_KEY="TEST_KEY"
ENV JUNTAGRICO_DEBUG="True"
ENV EMAIL_HOST="test@test.ch"
ENV EMAIL_HOST_USER="test"
ENV EMAIL_HOST_PASSWORD="test"

# Setup DB
RUN ./manage.py migrate

# Setup admin user
RUN ./manage.py createsuperuser && ./manage.py create_member_for_superusers

# Create Testdata
RUN ./manage.py generate_testdata_advanced

EXPOSE 8000
CMD ./manage.py runserver '0.0.0.0:8000'
