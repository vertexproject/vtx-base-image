RUN mkdir -p /opt/test/

COPY pytest.ini /opt/test/pytest.ini
COPY synapse_test.sh /opt/test/synapse_test.sh

RUN chmod +x /opt/test/synapse_test.sh

CMD ["/opt/test/synapse_test.sh"]
