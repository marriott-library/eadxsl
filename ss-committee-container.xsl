<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ead="urn:isbn:1-931666-22-9" 
	ead:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	ead:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xlink="http://www.w3.org/1999/xlink"
>

	<xsl:template match="ead:archdesc/ead:dsc">
		<div class="dsc">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:strip-space elements="*"/>

	<xsl:template match="ead:c01 | ead:c02 | ead:c03 | ead:c04 | ead:c05 | ead:c06 ">
		<a name="{generate-id(.)}"></a>
		<div>
			<xsl:attribute name="class">container <xsl:value-of select="name()" /></xsl:attribute>
			<!-- Add a label for the c0* @level if there aren't any containers in it, otherwise use the container's label. -->
			<xsl:call-template name="container-title" />
			<xsl:text> </xsl:text><xsl:apply-templates select="ead:did/ead:daogrp" />
			<div class="contents">
				<xsl:call-template name="container-contents" />
			</div>
		</div>
	</xsl:template>

	<xsl:template name="container-title">
		<span class="label">
			<xsl:if test="not(ead:did/ead:container)">
				<xsl:value-of select="@level" />
			</xsl:if>
			<xsl:if test="ead:did/ead:container">
				<xsl:apply-templates select="ead:did/ead:container" />
			</xsl:if>
			<xsl:if test="ead:did/ead:unitid">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="ead:did/ead:unitid" />
			</xsl:if>
			<xsl:text>: </xsl:text>
		</span>
		
		<xsl:if test="ead:did/ead:unittitle">
			<xsl:apply-templates select="ead:did/ead:unittitle" />
		</xsl:if>
		
		<xsl:if test="ead:did/ead:unitdate/text()">
			<xsl:apply-templates select="ead:did/ead:unitdate" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="container-contents">
		<xsl:for-each select="*[not(ead:unitid) and not(ead:unittitle) and not(ead:container)]">
			<xsl:apply-templates select="." />
		</xsl:for-each>
		
	<!-- <xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="ead:container">
		<xsl:value-of select="@type" />
		<xsl:text> </xsl:text>
		<xsl:apply-templates />
		<!-- Separate multiple containers in the same c0x with ", ". -->
		<xsl:if test="following-sibling::ead:container">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ead:dsc//ead:unitdate"> (<xsl:apply-templates />)</xsl:template>

	<xsl:template match="ead:dsc//ead:scopecontent"><xsl:apply-templates /></xsl:template>
	<!-- <span style="color: #ff00ff; font-weight: bold;"></span> -->
	
	<!-- Code adapted from http://staff.washington.edu/carlsonm/daogrpcode.html -->
	<xsl:variable name="pathToIcon"><!-- put data here --></xsl:variable>
	<!-- Set this variable to the filename of the icon image, e.g. icon.jpg -->
	<xsl:variable name="iconFilename"><!-- put data here --></xsl:variable>

	<xsl:template match="ead:did/ead:daogrp">
		<xsl:choose>
		
			<!-- First, check whether we are dealing with one or two <arc> elements -->
			<xsl:when test="ead:arc[2]">
				<a>
				<xsl:if test="ead:arc[2]/@show='new'">
					<xsl:attribute name="target">_blank</xsl:attribute>
				</xsl:if>

				<xsl:for-each select="daoloc">
					<!-- This selects the <daoloc> element that matches the @label attribute from <daoloc> and the @to attribute
					from the second <arc> element -->
					<xsl:if test="@label = following::ead:arc[2]/@to">
						<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
					</xsl:if>
				</xsl:for-each>

				<xsl:for-each select="daoloc">
					<xsl:if test="@label = following::ead:arc[1]/@to">
						<img src="{@href}" class="daoimage" border="0">
							<xsl:if test="following::ead:arc[1]/@title">
								<xsl:attribute name="title"><xsl:value-of select="following::arc[1]/@title"/></xsl:attribute>
								<xsl:attribute name="alt"><xsl:value-of select="following::arc[1]/@title"/></xsl:attribute>					
							</xsl:if>
						</img>	
						<xsl:if test="string(daodesc)">
							<br/><span class="daodesc"><xsl:apply-templates/></span>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
				</a>
			</xsl:when>
			<!-- i.e. no second <arc> element -->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ead:arc[1][@show='embed'] and ead:arc[1][@actuate='onload']">
						<xsl:for-each select="daoloc">
							<xsl:if test="@label = following-sibling::ead:arc[1]/@to">
								<img src="{@href}" class="daoimage" border="0">
									<xsl:if test="following::ead:arc[1]/@title">
									<xsl:attribute name="title"><xsl:value-of select="following::ead:arc[1]/@title"/></xsl:attribute>
									<xsl:attribute name="alt"><xsl:value-of select="following::ead:arc[1]/@title"/></xsl:attribute>					
									</xsl:if>			
								</img>
								<xsl:if test="string(daodesc)">
									<br/><span class="daodesc"><xsl:apply-templates/></span>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="(ead:arc[1]/@show='replace' or ead:arc[1]/@show='new') and ead:arc[1]/@actuate='onrequest'">
						<a>
						<xsl:choose>
						<!-- when a textual hyperlink is desired, i.e. <resource> element contains data -->
							<xsl:when test="string(ead:resource)">
								<xsl:for-each select="ead:daoloc">
									<xsl:if test="@label = following::ead:arc[1]/@to">
										<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
										<xsl:if test="following::ead:arc[1]/@show='new'">
											<xsl:attribute name="target">_blank</xsl:attribute>
										</xsl:if>
									</xsl:if>
								</xsl:for-each>
								<xsl:apply-templates/>
							</xsl:when>
							<xsl:otherwise>
						<!-- if <resource> element is empty, produce an icon that can be used to traverse the link -->
								<xsl:for-each select="ead:daoloc">
									<xsl:if test="@label = following::ead:arc[1]/@to">
										<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
										<xsl:if test="following::ead:arc[1]/@show='new'">
											<xsl:attribute name="target">_blank</xsl:attribute>
										</xsl:if>
									</xsl:if>
									<img src="{$pathToIcon}{$iconFilename}" border="0">
									<xsl:if test="following::ead:arc[1]/@title">
										<xsl:attribute name="title"><xsl:value-of select="following::ead:arc[1]/@title"/></xsl:attribute>
										<xsl:attribute name="alt"><xsl:value-of select="following::ead:arc[1]/@title"/></xsl:attribute>					
									</xsl:if>
									</img>					
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						</a>				
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
</xsl:stylesheet>
