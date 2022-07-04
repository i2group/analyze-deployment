# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#
# SPDX short identifier: MIT

FROM base_client_image

#Change the user that runs DB2 commands.
USER i2analyze:db2iusr1

#Remove the previous i2 Analyze deployment toolkit, to simulate the fact you wouldn't normally have the ETL toolkit and i2 Analyze toolkit on the same server.
RUN rm -rf ${i2analyzeDir}/*

#Copy the example data to ingest.
COPY --chown=i2analyze:db2iusr1 example ${i2analyzeDir}/example

#Copy the initialization script.
COPY --chown=i2analyze:db2iusr1 initializeEtlClient ${i2analyzeDir}/initializeEtlClient

#Copy example ingestion script.
COPY --chown=i2analyze:db2iusr1 ingestExampleData ${i2analyzeDir}/ingestExampleData

ENTRYPOINT tail -f /dev/null
