<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ead="urn:isbn:1-931666-22-9" 
	ead:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	ead:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xlink="http://www.w3.org/1999/xlink"
>
<xsl:include href="ss-committee-container.xsl" />

<xsl:strip-space elements="*"/>
<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

	<!-- ****************************************************************************************** -->
	<!-- ************************************* Overall Styles ************************************* -->
	<xsl:template match="ead:p"><xsl:if test="text()"><p><xsl:apply-templates /></p></xsl:if></xsl:template>
	<xsl:template match="*[@render='italic']"><i><xsl:apply-templates /></i></xsl:template>
	<xsl:template match="*[@render='underline']"><span class="underlined"><xsl:apply-templates /></span></xsl:template>
	<xsl:template match="*[@render='doublequote']"><xsl:text>"</xsl:text><xsl:apply-templates /><xsl:text>"</xsl:text></xsl:template>
	<xsl:template match="*[@render='singlequote']"><xsl:text>'</xsl:text><xsl:apply-templates /><xsl:text>'</xsl:text></xsl:template>
	<xsl:template match="*[@render='bolddoublequote']"><b><xsl:text>"</xsl:text><xsl:apply-templates /><xsl:text>"</xsl:text></b></xsl:template>
	<xsl:template match="*[@render='boldsinglequote']"><b><xsl:text>'</xsl:text><xsl:apply-templates /><xsl:text>'</xsl:text></b></xsl:template>
	<xsl:template match="*[@render='boldsinglequote']"><b><xsl:text>'</xsl:text><xsl:apply-templates /><xsl:text>'</xsl:text></b></xsl:template>
	<xsl:template match="*[@render='super']"><sup><xsl:apply-templates /></sup></xsl:template>
	<xsl:template match="*[@render='sub']"><sub><xsl:apply-templates /></sub></xsl:template>
	<xsl:template match="*[@render='boldunderline']"><span class="underlined"><b><xsl:apply-templates /></b></span></xsl:template>
	<xsl:template match="*[@render='bold']"><b><xsl:apply-templates /></b></xsl:template>
	<xsl:template match="*[@render='bolditalic']"><b><i><xsl:apply-templates /></i></b></xsl:template>
	<xsl:template match="*[@render='boldsmcaps']"><span class="smcaps"><b><xsl:apply-templates /></b></span></xsl:template>
	<xsl:template match="*[@render='smcaps']"><span class="smcaps"><xsl:apply-templates /></span></xsl:template>
	<xsl:template match="*[@render='nonproport']"><span class="nonproport"><xsl:apply-templates /></span></xsl:template>
	
		<!-- altrender="nodisplay": Don't display anything for elements with this attribute set.  Intentionally not 
		selecting or calling apply-templates here.
		Don't display: subject[@source='UMAbroad'|@source='umabroad'] and subject[@source='UMAnarrow'|@source='umanarrow']
		-->
	<xsl:template match="*[@altrender='nodisplay'] 
		|*[@altrender='nodisplay']//*
		|subject[@source='UMAbroad' or @source='umabroad']
		|subject[@source='UMAnarrow' or @source='umanarrow']"
	/>
	
	<xsl:template match="ead:address"><address><xsl:apply-templates /></address></xsl:template>
	<xsl:template match="ead:addressline"><xsl:apply-templates /><br /></xsl:template>
	<xsl:template match="ead:blockquote"><blockquote><xsl:apply-templates /></blockquote></xsl:template>
	
	<xsl:template match="ead:list[@type='deflist']">
		<xsl:apply-templates select="ead:head" />
			<table class="list">
				<xsl:apply-templates select="ead:listhead" />
				<xsl:apply-templates select="ead:item|ead:defitem"/>
			</table>
	</xsl:template>

	<xsl:template match="ead:list[@type='simple' or @type='marked']">
		<xsl:apply-templates select="ead:head" />
		<ul>
			<xsl:if test="@type='marked'">
				<xsl:attribute name="class">marked</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="ead:item">
				<li><xsl:apply-templates select="."/></li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="ead:defitem">
		<tr>
			<td class="item01"><xsl:apply-templates select="ead:label" /></td>
			<td class="item02"><xsl:apply-templates select="ead:item" /></td>
		</tr>
	</xsl:template>
	
		<!-- External references -->
	<xsl:template match="ead:extref"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ead:extref[@xlink:href]">
		<xsl:if test="not(self::*[@xlink:show]) or @xlink:show!='none'">
			<a>
				<xsl:attribute name="href"><xsl:value-of select="@xlink:href" /></xsl:attribute>
				<xsl:if test="@xlink:show='new'">
					<xsl:attribute name="target">_blank</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates />
			</a>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ead:relatedmaterial//ead:extrefloc[@xlink:href]">
		<xsl:if test="not(self::*[@xlink:show]) or @xlink:show!='none'">
			<a>
				<xsl:attribute name="href"><xsl:value-of select="@xlink:href" /></xsl:attribute>
				<xsl:if test="@xlink:show='new'">
					<xsl:attribute name="target">_blank</xsl:attribute>
				</xsl:if>
				View related images
			</a>
		</xsl:if>
	</xsl:template>
	
	<!-- ****************************************************************************************** -->
	<!-- ************************************ Main Stylesheet ************************************* -->
	<xsl:template match="ead:ead">
				<!--<xsl:call-template name="mwdl_portlet" />-->
				<link rel="stylesheet" type="text/css" href="/ead/stylesheet-committee.css" />
				<xsl:comment><![CDATA[[if lt IE 7]><link rel="stylesheet" type="text/css" href="/ead/stylesheet-committee-IE.css" /><![endif]]]></xsl:comment>
				<link rel="stylesheet" type="text/css" media="print" href="/ead/stylesheet-committee-print.css" />
				<div id="EAD_wrapper">
					<div id="EAD_header">
						<h1><xsl:apply-templates select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper" /> <br />
							<xsl:apply-templates select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:date" />
						</h1>
					</div><!-- end div EAD_header -->
					<div id="EAD_body">
						<table id="EAD_body_table">
							<tr>
								<td class="EAD_toc">
									<!-- 
									<div id="EAD_search">
										<h2>Search</h2>
										<form action="" method="get">
											<input type="text" name="searchterm" class="inputtext" /><br />
											<input type="submit" value="Search" />
										</form>
									</div>
									-->
									<h2>Table of Contents</h2>
									<xsl:call-template name="toc" />
								</td><!-- End TOC -->
								<td class="EAD_content">
									<!-- Collection Overview -->
									<a name="section_overview"></a>
									<h2>Collection Overview <a href="javascript:;" onclick="toggle_element('EAD_overview');" class="toggle_btn">+/-</a></h2>
									<div class="EAD_section" id="EAD_overview">
										<xsl:call-template name="overview" />
									</div>
									
									<!-- Collection Inventory -->
									<xsl:if test="ead:archdesc/ead:dsc">
										<a name="section_inventory"></a>
										<h2>Collection Inventory <a href="javascript:;" onclick="toggle_element('EAD_inventory');" class="toggle_btn">+/-</a></h2>
										<div class="EAD_section" id="EAD_inventory">
											<xsl:apply-templates select="ead:archdesc/ead:dsc" />
										</div>
									</xsl:if>
									
									<!-- Biographical/Historical Note -->
									<xsl:if test="ead:archdesc/ead:bioghist">
										<a name="section_bioghist"></a>
										<h2>Biographical Note/Historical Note <a href="javascript:;" onclick="toggle_element('EAD_biognote');" class="toggle_btn">+/-</a></h2>
										<div class="EAD_section" id="EAD_biognote">
											<xsl:call-template name="biognote" />
										</div>
									</xsl:if>
									
									<!-- Content Description -->
									<a name="section_description"></a>
									<h2>Content Description <a href="javascript:;" onclick="toggle_element('EAD_content_description');" class="toggle_btn">+/-</a></h2>
									<div class="EAD_section" id="EAD_content_description">
										<xsl:call-template name="contentdesc" />
									</div>
									
									<!-- Collection Use -->
									<xsl:if test="ead:archdesc/ead:accessrestrict|ead:archdesc/ead:userestrict|ead:archdesc/ead:prefercite">
										<a name="section_use"></a>
										<h2>Collection Use <a href="javascript:;" onclick="toggle_element('EAD_use');" class="toggle_btn">+/-</a></h2>
										<div class="EAD_section" id="EAD_use">
											<xsl:call-template name="use" />
										</div>
									</xsl:if>
									
									<!-- Administrative Information -->
									<a name="section_admin"></a>
									<h2>Administrative Information <a href="javascript:;" onclick="toggle_element('EAD_admin_info');" class="toggle_btn">+/-</a></h2>
									<div class="EAD_section" id="EAD_admin_info">
										<xsl:call-template name="admin" /> 
									</div>

									<!-- Subjects -->
									<xsl:if test="ead:archdesc/ead:controlaccess/ead:corpname|ead:archdesc/ead:controlaccess/ead:subject
										|ead:archdesc/ead:controlaccess/ead:genreform|ead:archdesc/ead:controlaccess/ead:persname
										|ead:archdesc/ead:controlaccess/ead:famname|ead:archdesc/ead:controlaccess/ead:geogname
										|ead:archdesc/ead:controlaccess/ead:occupation
									">
										<a name="section_subjects"></a>
										<h2>Subjects <a href="javascript:;" onclick="toggle_element('EAD_subjects');" class="toggle_btn">+/-</a></h2>
										<div class="EAD_section" id="EAD_subjects">
											<xsl:call-template name="subjects" />
										</div>
									</xsl:if>
									
								</td><!-- End Content -->
							</tr>
						</table><!-- End main layout split (2 cols - TOC and content) -->
					</div><!-- end div EAD_body -->
				</div><!-- end div EAD_wrapper -->

				<script type="text/javascript">
					<xsl:text>
						function toggle_element(elem_id)
						{
							elem = document.getElementById(elem_id);
							if( elem ) 
							{
								elem.style.display = ('none' == elem.style.display) ? 'block' : 'none';
							}
						}
					</xsl:text>
				</script>
	</xsl:template><!-- End template for root "ead" element -->
		
	<!-- ****************************************************************************************** -->
	<!-- ****************************** TOC (Table of Contents) templates ************************* -->
	<xsl:template name="toc">
		<!-- Collection Overview -->
		<h3><a href="#section_overview">Collection Overview</a></h3>
		
		<!-- Collection Inventory -->
		<xsl:if test="ead:archdesc/ead:dsc">
			<h3><a href="#section_inventory">Collection Inventory</a> <a href="javascript:;" onclick="toggle_element('toc_containers');" class="toggle_btn">+/-</a></h3>
			<div id="toc_containers">
				<ul><xsl:call-template name="toc_containers" /></ul>
			</div>
		</xsl:if>
		
		<!-- Biographical / Historical Note -->
		<xsl:if test="ead:archdesc/ead:bioghist">
			<h3><a href="#section_bioghist">Biographical Note/Historical Note</a></h3>
		</xsl:if>
		
		<!-- Content Description -->
		<h3><a href="#section_description">Content Description</a></h3>
		
		<!-- Collection Use -->
		<xsl:if test="ead:archdesc/ead:accessrestrict|ead:archdesc/ead:userestrict|ead:archdesc/ead:prefercite">
			<h3><a href="#section_use">Collection Use</a></h3>
		</xsl:if>
		
		<!-- Administrative Information -->
		<h3><a href="#section_admin">Administrative Information</a></h3>
		
		<!-- Subjects -->
		<xsl:if test="ead:archdesc/ead:controlaccess/ead:corpname|ead:archdesc/ead:controlaccess/ead:subject
									|ead:archdesc/ead:controlaccess/ead:genreform|ead:archdesc/ead:controlaccess/ead:persname
									|ead:archdesc/ead:controlaccess/ead:famname|ead:archdesc/ead:controlaccess/ead:geogname
									|ead:archdesc/ead:controlaccess/ead:occupation
		">
			<h3><a href="#section_subjects">Subjects</a></h3>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="toc_containers">
		<xsl:for-each select="ead:archdesc/ead:dsc/ead:c01|ead:archdesc/ead:dsc/ead:c02|ead:archdesc/ead:dsc/ead:c03|ead:archdesc/ead:dsc/ead:c04">
			<li><xsl:call-template name="toc_container" />
				<xsl:if test="ead:c02">
					<ul id="toc_{generate-id(.)}">
						<xsl:for-each select="ead:c02">
							<li><xsl:call-template name="toc_container" />
								<!-- NKP 2009-03-03:  Removing c03 and c04 elements from Table of Contents as per Sandra.
								<xsl:if test="ead:c03">
									<ul id="toc_{generate-id(.)}">
										
										<xsl:for-each select="ead:c03">
											<li><xsl:call-template name="toc_container" />
												<xsl:if test="ead:c04">
													<ul>
														<xsl:for-each select="ead:c04">
															<li><xsl:call-template name="toc_container" /></li>
														</xsl:for-each>
													</ul>
												</xsl:if>
											</li>
										</xsl:for-each>
										
									</ul>
								</xsl:if>
								NKP 2009-03-03: End of commented TOC sub-levels.-->
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
			</li>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="toc_container">
		<xsl:if test="(self::ead:c01 | self::ead:c02) and (descendant::ead:c02 | descendant::ead:c03)">
			<a href="javascript:;" onclick="toggle_element('toc_{generate-id(.)}');" class="toggle_btn">+/-</a>
		</xsl:if>
		<a href="#{generate-id(.)}"><xsl:call-template name="toc_container_name"/></a>
	</xsl:template>
	
	<xsl:template name="toc_container_name">
		<xsl:choose>
			<xsl:when test="ead:did/ead:unittitle/text()">
				<xsl:apply-templates select="ead:did/ead:unittitle" />
			</xsl:when>
			<xsl:when test="ead:did/ead:container">
				<xsl:apply-templates select="ead:did/ead:container" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@level" />
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="not(ead:did/ead:unittitle/text())">
			
		</xsl:if>
	</xsl:template>
	
	<!-- ****************************************************************************************** -->
	<!-- *********************** Individual Tags / General Formatting Rules *********************** -->
	<xsl:template match="ead:head">
		<xsl:if test="../list | ../bioghist | ../odd"><p class="label"><xsl:apply-templates /></p></xsl:if>
	</xsl:template>
		
	<xsl:template match="ead:repository/ead:corpname|ead:repository/ead:name">
		<xsl:apply-templates />
		<xsl:if test="following-sibling::*"><br /></xsl:if>
	</xsl:template>
	
	<xsl:template match="ead:archdesc/ead:did/ead:unitdate">
		<p class="label">Dates: </p>
		<p>
			<xsl:for-each select="ead:archdesc/ead:did/ead:unitdate">
				<xsl:apply-templates /><xsl:if test="@type"> ( <xsl:value-of select="@type"/> ) </xsl:if>
				<xsl:if test="following-sibling::ead:unitdate"> <br /></xsl:if>
			</xsl:for-each>
		</p>
	</xsl:template>
	
	<xsl:template match="ead:scopecontent">
		<xsl:if test="ancestor::ead:c01">
			<p class="label">Content Description</p>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="ead:titleproper/ead:date" /><!-- Intentionally not displaying titleproper/date, its text() is selected where desired. -->
	
	<!-- Label, than <br /> tag added after, if the item has following siblings -->
	<xsl:template match="ead:repository/ead:subarea">
		<p class="label">
			<xsl:choose>
				<xsl:when test="self::ead:subarea">Subarea: </xsl:when>
			</xsl:choose>
		</p>
		<xsl:apply-templates />
		<xsl:if test="following-sibling::*"><br /></xsl:if>
	</xsl:template>
	
	<!-- Label, then item (with its own <p> tags) -->
	<xsl:template match="ead:accessrestrict|ead:userestrict|ead:prefercite|ead:custodhist|
		ead:arrangement|ead:acqinfo|ead:processinfo|ead:separatedmaterial|ead:accruals|ead:relatedmaterial
	">
		<p class="label">
			<xsl:choose>
				<xsl:when test="self::ead:accessrestrict">Restrictions on Access: </xsl:when>
				<xsl:when test="self::ead:userestrict">Restrictions on Use: </xsl:when>
				<xsl:when test="self::ead:prefercite">Preferred Citation: </xsl:when>
				<xsl:when test="self::ead:custodhist">Custodial History: </xsl:when>
				<xsl:when test="self::ead:arrangement">Arrangement: </xsl:when>
				<xsl:when test="self::ead:acqinfo">Acquisition Information: </xsl:when>
				<xsl:when test="self::ead:processinfo">Processing Note: </xsl:when>
				<xsl:when test="self::ead:separatedmaterial">Separated Material: </xsl:when>
				<xsl:when test="self::ead:accruals">Accruals: </xsl:when>
				<xsl:when test="self::ead:relatedmaterial">Related Material: </xsl:when>
			</xsl:choose>
		</p>
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- Labelled, all sub-items wrapped in a single <p> tag -->
	<xsl:template match="ead:langusage|ead:langmaterial|ead:repository|ead:legalstatus|ead:author|
		ead:profiledesc/ead:creation/ead:date|ead:profiledesc/ead:descrules"
	>
		<p class="label">
			<xsl:choose>
				<xsl:when test="self::ead:repository">Repository: </xsl:when>
				<xsl:when test="self::ead:legalstatus">Legal Status: </xsl:when>
				<xsl:when test="self::ead:langusage">Language of the Finding Aid: </xsl:when>
				<xsl:when test="self::ead:langmaterial">Language: </xsl:when>
				<xsl:when test="self::ead:author">Author of the Finding Aid: </xsl:when>
				<xsl:when test="self::ead:date">EAD Creation Date: </xsl:when>
				<xsl:when test="self::ead:descrules">Standard: </xsl:when>
			</xsl:choose>
		</p>
		<p><xsl:apply-templates /></p>
	</xsl:template>
	
	<!-- Labelled, each individual sub-item wrapped in a <p> tag -->
	<xsl:template match="ead:origination">
		<p class="label">
			<xsl:choose>
				<xsl:when test="self::ead:origination">Creator: </xsl:when>
			</xsl:choose>
		</p>
		<xsl:for-each select="*">
			<p><xsl:apply-templates /></p>
		</xsl:for-each>
	</xsl:template>
			
	<!-- <controlaccess> tag -->
	<xsl:template match="ead:controlaccess">
		<xsl:if test="ead:corpname">
			<p class="label">Corporate Names: </p>
			<p>
				<xsl:for-each select="ead:corpname">
					<xsl:apply-templates select="." />
					<br />
				</xsl:for-each>
			</p>
		</xsl:if>
		<xsl:if test="ead:subject[not(@altrender)] | ead:subject[@altrender!='nodisplay']">
			<p class="label">Subject Terms: </p>
			<p>
				<xsl:for-each select="ead:subject[not(@altrender)] | ead:subject[@altrender!='nodisplay']">
					<xsl:apply-templates select="." />
					<br />
				</xsl:for-each>
			</p>
		</xsl:if>
		<xsl:if test="ead:genreform">
			<p class="label">Form or Genre Terms: </p>
			<p>
				<xsl:for-each select="ead:genreform">
					<xsl:apply-templates select="." />
					<br />
				</xsl:for-each>
			</p>
		</xsl:if>
		<xsl:if test="ead:persname[@encodinganalog='creator']">
			<p class="label">Other Creators: </p>
			<p>
				<xsl:for-each select="ead:persname[@encodinganalog='creator']">
					<xsl:apply-templates select="." />
					<br />
				</xsl:for-each>
			</p>
		</xsl:if>
		<xsl:if test="ead:persname[@encodinganalog!='creator']">
			<p class="label">Personal Names: </p>
			<p>
				<xsl:for-each select="ead:persname[@encodinganalog!='creator']">
					<xsl:apply-templates select="." />
					<br />
				</xsl:for-each>
			</p>
		</xsl:if>
		<xsl:if test="ead:famname">
			<p class="label">Family Names: </p>
			<p>
				<xsl:for-each select="ead:famname">
					<xsl:apply-templates select="." />
					<br />
				</xsl:for-each>
			</p>
		</xsl:if>
		<xsl:if test="ead:geogname">
			<p class="label">Geographical Names: </p>
			<p>
				<xsl:for-each select="ead:geogname">
					<xsl:apply-templates select="." />
					<br />
				</xsl:for-each>
			</p>
		</xsl:if>
		<xsl:if test="ead:occupation">
			<p class="label">Occupations: </p>
			<p>
				<xsl:for-each select="ead:occupation">
					<xsl:apply-templates select="." />
					<br />
				</xsl:for-each>
			</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ead:physdesc">
		<xsl:if test="ead:extent">
			<p class="label">Quantity: </p>
			<p>
				<xsl:for-each select="ead:extent">
					<xsl:apply-templates />
					<xsl:if test="following-sibling::*">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ead:archdesc/ead:did/ead:repository">
		<xsl:apply-templates select="*[not(self::ead:address)]" />
	</xsl:template>
	<xsl:template match="ead:archdesc/ead:did/ead:unitdate"><xsl:apply-templates /></xsl:template>
	
	<!-- ****************************************************************************************** -->
	<!-- ***************************** Main Layout Sections *************************************** -->
	<!-- Collection Overview -->
	<xsl:template name="overview">
		<table>
			<!-- Title -->
			<xsl:if test="ead:archdesc/ead:did/ead:unittitle">
				<tr>
					<td class="label">Title: </td>
					<td><xsl:apply-templates select="ead:archdesc/ead:did/ead:unittitle" /></td>
				</tr>
			</xsl:if>
			
			<!-- Dates -->
			<xsl:if test="ead:archdesc/ead:did/ead:unitdate">
				<tr>
					<td class="label">Dates: </td>
					<td>
						<xsl:for-each select="ead:archdesc/ead:did/ead:unitdate">
							<xsl:apply-templates /> (<xsl:value-of select="@type"/>)
							<xsl:if test="following-sibling::ead:unitdate"> <br /></xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>
			
			<!-- Collection Number -->
			<xsl:if test="ead:archdesc/ead:did/ead:unitid">
				<tr>
					<td class="label">Collection Number: </td>
					<td><xsl:apply-templates select="ead:archdesc/ead:did/ead:unitid" /></td>
				</tr>
			</xsl:if>
			
			<!-- Summary -->
			<xsl:if test="ead:archdesc/ead:did/ead:abstract/text()">
				<tr>
					<td class="label">Summary: </td>
					<td><xsl:apply-templates select="ead:archdesc/ead:did/ead:abstract" /></td>
				</tr>
			</xsl:if>
			
			<!-- Repository -->
			<xsl:if test="ead:archdesc/ead:did/ead:repository">
				<tr>
					<td class="label">Repository: </td>
					<td><xsl:call-template name="overview_repository" /></td>
				</tr>
			</xsl:if>
			
			<!-- Repository / Address -->
			<xsl:if test="ead:archdesc/ead:did/ead:repository/ead:address">
				<tr>
					<td class="label">Address: </td>
					<td><xsl:apply-templates select="ead:archdesc/ead:did/ead:repository/ead:address" /></td>
				</tr>
			</xsl:if>
			
			<!-- Sponsor 
			<xsl:if test="ead:eadheader/ead:filedesc/ead:titlestmt/ead:sponsor">
				<tr>
					<td class="label">Sponsor: </td>
					<td><xsl:call-template name="sponsors" /></td>
				</tr>
			</xsl:if>
			-->
		</table>
	</xsl:template> <!-- end template "overview" -->
	
	<!-- Special template for "Collection Overview" -> "Repository" area.  Needed because Collection Overview 
		labels things differently from the other sections (in a table) and because the same elements are used again in 
		"Administrative Information".
	-->
	<xsl:template name="overview_repository"> 
		<xsl:apply-templates select="ead:archdesc/ead:did/ead:repository/ead:corpname|ead:archdesc/ead:did/ead:repository/ead:name" />
		<!-- NKP 2008-08-25: Removed subarea from the Collection Overview repository section, 
		as per Dan Davis (usu, w/ LSTA stylesheet committee. daniel.davis@usu.edu .)  
		<xsl:if test="ead:archdesc/ead:did/ead:repository/ead:subarea">
			<xsl:value-of select="ead:archdesc/ead:did/ead:repository/ead:subarea" /><br />
		</xsl:if>
		-->
	</xsl:template>
	
	<xsl:template name="sponsors">
		<xsl:if test="ead:eadheader/ead:filedesc/ead:titlestmt/ead:sponsor/text()">
			<p class="label">Sponsor: </p>
			<xsl:for-each select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:sponsor">
				<p><xsl:apply-templates /></p>			
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	<!-- Biographical / Historical Note -->
	<xsl:template name="biognote">
		<xsl:apply-templates select="ead:archdesc/ead:bioghist" />
	</xsl:template>

	<!-- Content Description -->
	<xsl:template name="contentdesc">
		<xsl:apply-templates select="ead:archdesc/ead:scopecontent" />
	</xsl:template>
	
	<!-- Collection Use -->
	<xsl:template name="use">
		<xsl:apply-templates select="ead:archdesc/ead:accessrestrict" />
		<xsl:apply-templates select="ead:archdesc/ead:userestrict" />
		<xsl:apply-templates select="ead:archdesc/ead:prefercite" />
	</xsl:template>
	
	<!-- Administrative Information -->
	<xsl:template name="admin">
		<!-- Arrangement -->
		<xsl:apply-templates select="ead:archdesc/ead:arrangement" />
		<!-- Custodial History -->
		<xsl:apply-templates select="ead:archdesc/ead:custodhist" />
		<!-- Acquisition Information -->
		<xsl:apply-templates select="ead:archdesc/ead:acqinfo" />
		<!-- Processing Note -->
		<xsl:apply-templates select="ead:archdesc/ead:processinfo" />
		<!-- Creator -->
		<xsl:apply-templates select="ead:archdesc/ead:did/ead:origination" />
		<!-- Language -->
		<xsl:apply-templates select="ead:archdesc/ead:did/ead:langmaterial" />
		<!-- Sponsor -->
		<xsl:call-template name="sponsors" />
		<!-- Quantity -->
		<xsl:apply-templates select="ead:archdesc/ead:did/ead:physdesc" />
		<!-- Language of the Finding Aid -->
		<xsl:apply-templates select="ead:eadheader/ead:profiledesc/ead:langusage" />
		<!-- Author of the Finding Aid -->
		<xsl:apply-templates select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:author" />
		<!-- EAD Creation Date -->
		<xsl:apply-templates select="ead:eadheader/ead:profiledesc/ead:creation/ead:date" />
		<!-- Standard -->
		<xsl:apply-templates select="ead:eadheader/ead:profiledesc/ead:descrules" />
		<!-- Subarea -->
		<xsl:apply-templates select="ead:archdesc/ead:did/ead:repository/ead:subarea" />		
		<!-- Related Materials -->
		<xsl:apply-templates select="ead:archdesc/ead:relatedmaterial" />
	</xsl:template>
	
	<!-- Subjects -->
	<xsl:template name="subjects">
		<xsl:apply-templates select="ead:archdesc/ead:controlaccess" />
	</xsl:template>
</xsl:stylesheet>
