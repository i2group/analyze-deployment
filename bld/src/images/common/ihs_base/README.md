# Building an IBM HTTP Server Image from an IHS Archive

The Dockerfile in the `archive` directory can be used to build an IBM HTTP Server (including the WebSphere plugin) image from
a single zip. This method does not require IM to be installed.

## Getting the Archive

Archive installs from IBM HTTP Server can be found on Fix Central. Links to the archives are also provided in each fix
pack document. Downloading the IBM HTTP Server archive file requires entitlement.

1. Visit [Fix list for IBM HTTP Server Version 9.0](https://www.ibm.com/support/pages/node/617655)
2. Select the desired fix pack
3. Click the link for `Download Fix Pack <fixpack>`
4. Go to the section `IBM HTTP Server and Web server Plug-ins *archive* packages`
5. Download the zip archive
6. Place the zip into the Docker context root of ihs_base.
