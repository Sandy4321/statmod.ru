<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:co="http://statmod.ru/courses"
	xmlns:pr="http://statmod.ru/staff"
      exclude-result-prefixes="msxsl co pr">

<xsl:include href="resolve_prof.xsl"/>
<xsl:variable name="profs" select="document('../_staff/prof.xml')"/>
<xsl:variable name="specs">
	<specs>
		<spec id="sa">
			<name>САПР</name>
			<xsl:copy-of select="document('sa_spec.xml')"/>
		</spec>
		<spec id="sm">
			<name>СМ</name>
			<xsl:copy-of select="document('sm_spec.xml')"/>
		</spec>
		<spec id="mm">
			<name>ММ</name>
			<xsl:copy-of select="document('mm_spec.xml')"/>
		</spec>
	</specs>
</xsl:variable>

<xsl:variable name="spec" select="/co:courses/@spec"/>
<xsl:variable name="current_year" select="/co:courses/@year"/>

<xsl:template match="/">
   <html>
      <body>

		<table width="100%" border="1" cellspacing="0" class="spectable">
         		<tr>
				<th><spec code="nbsp"/></th>
				<th>преподаватель</th>
				<th>название</th>
				<th>зач./<br/>экз.</th>
				<th><font color="red">вопросы</font></th>
				<th>час.</th>
				<th>длит.</th>
				<th><spec code="nbsp"/></th>
			</tr>
			<xsl:apply-templates select="co:courses"/>
		</table>
      </body>
   </html>
</xsl:template>

<xsl:key name="semester_key" match="@semester" use="."/>

<xsl:template match="co:courses">
		<h2>Специализация <xsl:value-of select="msxsl:node-set($specs)/specs/spec[@id=current()/@spec]/name/node()"/></h2>
		
		<!-- This 'for-each' selects unique semester attribute -->
		<xsl:for-each select="co:course/@semester[generate-id() = generate-id(key('semester_key', .))]">
			<tr>
				<td class="semname" colspan="10"><xsl:value-of select="."/> семестр</td>
			</tr>
	   		<xsl:apply-templates select="../../co:course[@semester=current()]"/>
		</xsl:for-each>
</xsl:template>

<xsl:template match="co:course">
	<tr>
		<td align="right"><xsl:value-of select="@class"/></td>
		<td><xsl:apply-templates select=".//co:prof"/></td>
		<td class="specname"><a href="/3-5/annotations/{$spec}/index.htm#{@alias}"><xsl:value-of select="co:name"/></a></td>
		<td align="right"><xsl:value-of select="@exam"/></td>
		<td align="right">
			<xsl:variable name="questions" select="msxsl:node-set($specs)/specs/spec/co:courses/co:course[@alias = current()/@alias]/co:questions"/>
			<xsl:if test="not($questions and @exam != '')"><spec code="nbsp"/></xsl:if>
			<xsl:if test="$questions and @exam != ''">
				<xsl:apply-templates select="$questions"/>
			</xsl:if>
		</td>
		<td align="right"><xsl:value-of select="@hours"/></td>
		<td align="right">	<xsl:value-of select="@year_equiv"/></td>
		<td align="right"><xsl:value-of select="@extras"/></td>
		
	</tr>	
</xsl:template>

<xsl:template match="co:prof">
	<a href="/chair/prof/{@id}.htm">
	<xsl:apply-templates select="$profs//pr:person[@id = current()/@id]" mode="short_name"/>
	</a>
	<xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

<xsl:template match="co:questions">
	<a href="/_files/questions/{@file}" target="_blank">
		<img alt="{co:file_name}" src="/_img/pdf.png">
			<xsl:variable name="ext" select="substring-after(@file, '.')"/>
			<xsl:attribute name="src">/_img/<xsl:choose>
					<xsl:when test="$ext = 'pdf'"><xsl:value-of select="$ext"/></xsl:when>
					<xsl:otherwise>file</xsl:otherwise>
				</xsl:choose>.png
			</xsl:attribute>
		</img>
	</a>
	<xsl:if test="co:file_name = $current_year">ok</xsl:if>
</xsl:template>



</xsl:stylesheet>
  

  