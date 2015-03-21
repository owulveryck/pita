<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pita="http://ali/intranet" version="2.0">
	<xsl:output method="html"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>PITA Report</title>
			</head>
			<body>
				<table border='1'>
					<tr>
						<th rowspan="2">file</th>
						<th COLSPAN="2">owner</th>
						<th COLSPAN="2">group</th>
						<th COLSPAN="2">permissions</th>
						<th COLSPAN="2">type</th>
						<th rowspan="2">checksum</th>
					</tr>
					<tr>
						<th>actual</th> <th>repository</th>
						<th>actual</th> <th>repository</th>
						<th>actual</th> <th>repository</th>
						<th>actual</th> <th>repository</th>
					</tr>
				<xsl:for-each select="files/file">
						<tr>
							<td rowspan="2"><xsl:value-of select="@name"/></td>
							<td><xsl:value-of select="owner/uid"/></td>	
							<td rowspan="2"><xsl:value-of select="owner/repository"/></td>	
							<td><xsl:value-of select="groupOwner/gid"/></td>	
							<td rowspan="2"><xsl:value-of select="groupOwner/repository"/></td>	
							<td rowspan="2"><xsl:value-of select="permissions/actual"/></td>	
							<td rowspan="2"><xsl:value-of select="permissions/repository"/></td>	
							<td rowspan="2"><xsl:value-of select="type/actual"/></td>	
							<td rowspan="2"><xsl:value-of select="type/repository"/></td>	
							<xsl:if test="checksum/actual = checksum/repository">
								<td rowspan="2">OK</td>
							</xsl:if>
							<xsl:if test="checksum/actual != checksum/repository">
								<td rowspan="2">KO</td>
							</xsl:if>
<!--
							<td rowspan="2"><xsl:value-of select="checksum/actual"/></td>	
							<td rowspan="2"><xsl:value-of select="checksum/repository"/></td>	
-->
						</tr>	
						<tr>
							<td><xsl:value-of select="owner/username"/></td>	
							<td><xsl:value-of select="groupOwner/groupname"/></td>	
						</tr>	
				</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet> 
