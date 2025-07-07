FROM python:latest

RUN useradd --user-group --system --no-log-init --create-home ansible
USER ansible

RUN python3 -m pip install --user ansible && \
  mkdir -p /home/ansible/ansible

ENV PATH="$PATH:/home/ansible/.local/bin"

WORKDIR /home/ansible/ansible

RUN ansible-galaxy collection install f5networks.f5_bigip

ENTRYPOINT [ "ansible-playbook" ]
CMD [ "--version" ]