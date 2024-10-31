FROM debian:bookworm-slim

RUN apt update \
    && apt -y upgrade \
    && apt install --no-install-recommends -y supervisor \
    && apt -y autoremove \
    && apt clean all

RUN apt update \
    && apt install --no-install-recommends -y openssh-server \
    && apt -y autoremove \
    && apt clean all

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY set_root_password.sh /usr/local/bin/set_root_password.sh
RUN chown root.root /usr/local/bin/set_root_password.sh \
    && chmod 755 /usr/local/bin/set_root_password.sh

RUN apt update \
    && apt install --no-install-recommends -y corosync-qnetd \
    && apt -y autoremove \
    && apt clean all

RUN mkdir -p /run/sshd

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 22
EXPOSE 5403

CMD ["/usr/bin/supervisord"]

