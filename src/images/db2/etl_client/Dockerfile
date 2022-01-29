# MIT License
#
# Copyright (c) 2022, N. Harris Computer Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
