FROM python:3.8.0

# Set defaults environment variables.
ENV APP_HOST="0.0.0.0"
ENV APP_PORT="5000"
ENV HOME_APP=/home/appuser
ENV PATH="${HOME_APP}/.local/bin:$PATH"

# Create user and home dir (root).
RUN useradd --create-home appuser

# Copy app files to docker.
COPY ./requirements.txt ${HOME_APP}
COPY ./data ${HOME_APP}
COPY ./app.py ${HOME_APP}
RUN chown -R appuser:appuser ${HOME_APP}

# Install python requirements.
WORKDIR ${HOME_APP}
RUN pip3 install --upgrade pip
USER appuser
RUN pip3 install -r ./requirements.txt
# Start the app
EXPOSE ${APP_PORT}
CMD ["/bin/sh", "-c", "python3 app.py"]