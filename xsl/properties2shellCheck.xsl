<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pita="http://ali/intranet" version="2.0">
	<xsl:output method="text"/>
	<xsl:template name="pita:openTag">
		<xsl:param name="tag"/>
		<xsl:text>echo "&lt;</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text>&gt;"</xsl:text>
		<xsl:text></xsl:text>
	</xsl:template>
	<xsl:template name="pita:closeTag">
		<xsl:param name="tag"/>
		<xsl:text>echo "&lt;/</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text>&gt;"</xsl:text>
		<xsl:text></xsl:text>
	</xsl:template>
	<xsl:template name="pita:echo">
		<xsl:param name="tag"/>
		<xsl:param name="value"/>
		<xsl:text>echo "&lt;</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:value-of select="$value"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text>&gt;"</xsl:text>
		<xsl:text></xsl:text>
	</xsl:template>
	<xsl:template name="pita:cmd">
		<xsl:param name="tag"/>
		<xsl:param name="cmd"/>
		<xsl:param name="cdata"/>
		<xsl:text>echo "&lt;</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:if test="$cdata = 1">
			<xsl:text>&lt;![CDATA[</xsl:text>
		</xsl:if>
		<xsl:text>$(</xsl:text>
		<xsl:value-of select="$cmd"/>
		<xsl:text>)</xsl:text>
		<xsl:if test="$cdata = 1">
			<xsl:text>]]&gt;</xsl:text>
		</xsl:if>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text>&gt;"
		</xsl:text>
	</xsl:template>
	<xsl:template match="/">
		<xsl:text>&lt;?xml-stylesheet type="text/xsl" href="check2html.xsl"?&gt;</xsl:text>
		<xsl:call-template name="pita:openTag"> 
			<xsl:with-param name="tag">files</xsl:with-param>
		</xsl:call-template>

		<xsl:for-each select="properties/property">
			<xsl:call-template name="pita:openTag"> 
				<xsl:with-param name="tag">file name='<xsl:value-of select="@file"/>'</xsl:with-param>
			</xsl:call-template>
			<!-- banner -->
			<!-- Diff of the container -->
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">diff</xsl:with-param>
					<xsl:with-param name="cdata">1</xsl:with-param>
					<xsl:with-param name="cmd">diff $SANDBOX<xsl:value-of select="@file"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="@file"/></xsl:with-param>
				</xsl:call-template> 
			<!-- Check of the owner -->
				<xsl:call-template name="pita:openTag"> 
					<xsl:with-param name="tag">owner</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">uid</xsl:with-param>
					<xsl:with-param name="cmd">stat -c '%u' <xsl:value-of select="@file"/></xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">username</xsl:with-param>
					<xsl:with-param name="cmd">stat -c '%U' <xsl:value-of select="@file"/></xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:echo">
					<xsl:with-param name="tag">repository</xsl:with-param>
					<xsl:with-param name="value"><xsl:value-of select="owner"/></xsl:with-param>
				</xsl:call-template>
				<!--
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">same</xsl:with-param>
					<xsl:with-param name="cmd">stat -c '|%u|%U|' <xsl:value-of select="@file"/> | grep -q '|<xsl:value-of select="owner"/>|' &amp;&amp; echo true || echo false</xsl:with-param>
				</xsl:call-template> 
				-->
				<xsl:call-template name="pita:closeTag"> 
					<xsl:with-param name="tag">owner</xsl:with-param>
				</xsl:call-template>
			<!-- Check of the group -->
				<xsl:call-template name="pita:openTag"> 
					<xsl:with-param name="tag">groupOwner</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">gid</xsl:with-param>
					<xsl:with-param name="cmd">stat -c '%g' <xsl:value-of select="@file"/></xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">groupname</xsl:with-param>
					<xsl:with-param name="cmd">stat -c '%G' <xsl:value-of select="@file"/></xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:echo">
					<xsl:with-param name="tag">repository</xsl:with-param>
					<xsl:with-param name="value"><xsl:value-of select="group"/></xsl:with-param>
				</xsl:call-template>
				<!--
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">same</xsl:with-param>
					<xsl:with-param name="cmd">stat -c '|%g|%G|' <xsl:value-of select="@file"/> | grep -q '|<xsl:value-of select="group"/>|' &amp;&amp; echo true || echo false</xsl:with-param>
				</xsl:call-template> 
				-->
				<xsl:call-template name="pita:closeTag"> 
					<xsl:with-param name="tag">groupOwner</xsl:with-param>
				</xsl:call-template>
			<!-- Check of the permissions -->
				<xsl:call-template name="pita:openTag">
					<xsl:with-param name="tag">permissions</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">actual</xsl:with-param>
					<xsl:with-param name="cmd">stat -c '%a' <xsl:value-of select="@file"/></xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:echo"> 
					<xsl:with-param name="tag">repository</xsl:with-param>
					<xsl:with-param name="value"><xsl:value-of select="perms"/></xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:closeTag"> 
					<xsl:with-param name="tag">permissions</xsl:with-param>
				</xsl:call-template>
			<!-- Check of the md5 -->
				<xsl:call-template name="pita:openTag">
					<xsl:with-param name="tag">checksum</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">actual</xsl:with-param>
					<xsl:with-param name="cmd">md5sum $SANDBOX<xsl:value-of select="@file"/>| awk '{print $1}'</xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">repository</xsl:with-param>
					<xsl:with-param name="cmd">md5sum <xsl:value-of select="@file"/>| awk '{print $1}'</xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:closeTag"> 
					<xsl:with-param name="tag">checksum</xsl:with-param>
				</xsl:call-template>
			<!-- File type -->
				<xsl:call-template name="pita:openTag">
					<xsl:with-param name="tag">type</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">actual</xsl:with-param>
					<xsl:with-param name="cmd"> stat -c '%F' $SANDBOX/<xsl:value-of select="@file"/> | sed 's/empty //'</xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:echo"> 
					<xsl:with-param name="tag">repository</xsl:with-param>
					<!--<xsl:with-param name="cmd">stat -c '%F' <xsl:value-of select="@file"/> | sed 's/empty //'</xsl:with-param>-->
					<xsl:with-param name="value"><xsl:value-of select="type"/></xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:closeTag"> 
					<xsl:with-param name="tag">type</xsl:with-param>
				</xsl:call-template>
			<!-- link -->
				<xsl:call-template name="pita:openTag">
					<xsl:with-param name="tag">link</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">actual</xsl:with-param>
					<xsl:with-param name="cmd">ls -ald <xsl:value-of select="@file"/> | awk '{print $11}'</xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:cmd"> 
					<xsl:with-param name="tag">repository</xsl:with-param>
					<xsl:with-param name="cmd">ls -ald $SANDBOX<xsl:value-of select="@file"/> | awk '{print $11}'</xsl:with-param>
				</xsl:call-template> 
				<xsl:call-template name="pita:closeTag"> 
					<xsl:with-param name="tag">link</xsl:with-param>
				</xsl:call-template>
			<xsl:call-template name="pita:closeTag"> 
				<xsl:with-param name="tag">file</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="pita:closeTag"> 
			<xsl:with-param name="tag">files</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet> 
