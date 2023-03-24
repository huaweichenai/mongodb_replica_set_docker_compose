FROM mongo

COPY ./config/mongo.conf /etc/mongo/mongo.conf
COPY ./security/key /etc/mongo/key

RUN chmod 400 /etc/mongo/key && \
    chown mongodb:mongodb /etc/mongo/key

RUN set -eux; \
	mkdir -p /data/systemlog && \
	chown -R mongodb:mongodb /data/systemlog

ENV TZ Asia/Shanghai
