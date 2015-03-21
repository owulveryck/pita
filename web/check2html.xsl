<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pita="http://ali/intranet" version="2.0">
	<xsl:output metdod="html"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>PITA Report</title>
				<link rel="stylesheet" type="text/css" href="table.css" /> 
			</head>
			<body>
				<table border='1' class="sofT" cellspacing="0">
					<tr>
						<td rowspan="2" class="helpHed">file</td>
						<td COLSPAN="2" class="helpHed">owner</td>
						<td COLSPAN="2" class="helpHed">group</td>
						<td COLSPAN="2" class="helpHed">permissions</td>
						<td COLSPAN="2" class="helpHed">type</td>
						<td rowspan="2" class="helpHed">checksum</td>
					</tr>
					<tr>
						<td class="helpHed">actual</td> <td class="helpHed">repository</td>
						<td class="helpHed">actual</td> <td class="helpHed">repository</td>
						<td class="helpHed">actual</td> <td class="helpHed">repository</td>
						<td class="helpHed">actual</td> <td class="helpHed">repository</td>
					</tr>
				<xsl:for-each select="files/file">
						<tr onmouseover="this.style.backgroundColor='#ffff66';" onmouseout="this.style.backgroundColor='#FFFFFF';">
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
						<tr onmouseover="this.style.backgroundColor='#ffff66';" onmouseout="this.style.backgroundColor='#FFFFFF';">
							<td><xsl:value-of select="owner/username"/></td>	
							<td><xsl:value-of select="groupOwner/groupname"/></td>	
						</tr>	
				</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet> 
