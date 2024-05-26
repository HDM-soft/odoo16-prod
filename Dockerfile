FROM odoo:16.0

COPY ./config/odoo.conf /etc/odoo/
COPY ./gitman.yml /usr/lib/python3/dist-packages/odoo/
COPY ./install_dependencies.sh /usr/lib/python3/dist-packages/odoo/

USER root

RUN apt update && apt install git -y

RUN python3 -m pip install gitman

RUN gitman install -r /usr/lib/python3/dist-packages/odoo/

CMD odoo -c /etc/odoo/odoo.conf
