#/********************************************************************************
# * (C) Copyright IBM Corporation 2018, 2020.
# *
# * This program and the accompanying materials are made available under the
# * terms of the Eclipse Public License 2.0 which is available at
# * http://www.eclipse.org/legal/epl-2.0.
# *
# * SPDX-License-Identifier: EPL-2.0
# *
# ********************************************************************************/

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
