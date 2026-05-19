FROM docker.elastic.co/elasticsearch/elasticsearch:8.11.0

ENV discovery.type=single-node \
    ES_JAVA_OPTS="-Xms2g -Xmx2g"

EXPOSE 9200 9300

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
  CMD curl -fsS http://localhost:9200/_cluster/health?wait_for_status=yellow\&timeout=5s || exit 1
