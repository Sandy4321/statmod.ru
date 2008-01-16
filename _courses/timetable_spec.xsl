﻿<?xml version="1.0" encoding="UTF-8"?>
	<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
      xmlns:pr="http://statmod.ru/staff">
	<xsl:import href="mergecells.xsl"/>
	<xsl:include href="gen_lesson_table.xsl"/>
	<xsl:include href="resolve_prof.xsl"/>
	<xsl:param name="loc_param"/>
	<xsl:variable name="no_width" select="10"/>
	<xsl:variable name="spec_width" select="214"/>
	<xsl:variable name="cell_height" select="36"/>

	<xsl:variable name="two_hours_names" select="document('../_courses/two_hours.xml')"/>

	<xsl:variable name="specs">
		<specs>
			<spec id="sa">
				<name>САПР</name>
			</spec>
			<spec id="sm">
				<name>СМ</name>
			</spec>
			<spec id="mm">
				<name>ММ</name>
			</spec>
		</specs>
	</xsl:variable>
	<xsl:variable name="weekdays">
		<week>
			<day id="mon">Понедельник</day>
			<day id="tue">Вторник</day>
			<day id="wed">Среда</day>
			<day id="thu">Четверг</day>
			<day id="fri">Пятница</day>
			<day id="sat">Суббота</day>
		</week>
	</xsl:variable>
	<xsl:variable name="specs_count" select="1"/>

	<!-- Match the root node -->
	<xsl:template match="/timetable">
<xsl:variable name="tt" select="."/>
		<span class="remove">
<h2><xsl:value-of select="ceiling(@semester div 2)"/>-й курс,
<xsl:value-of select="msxsl:node-set($specs)/specs/spec[@id=$loc_param/@spec]"/>,
<xsl:choose>
<xsl:when test="@semester mod 2 = 0">
весенний семестр 
<xsl:value-of select="@year - 1"/>-<xsl:number value="@year mod 100" format="01"/>
</xsl:when>
<xsl:otherwise>
осенний семестр 
<xsl:value-of select="@year"/>-<xsl:number value="(@year + 1) mod 100" format="01"/>
</xsl:otherwise>
</xsl:choose>
</h2>

<style>
.fortnightly .biginfo { font: 13px Tahoma }
.fortnightly .smallinfo { font: 10px Tahoma }
.common .biginfo { font: 13px Tahoma }
.common .smallinfo { font: 11px Tahoma }
</style>

			<table border="2">
			<tr valign="top">
<td></td>
<td></td>
<xsl:for-each select="msxsl:node-set($weekdays)/week/day[position() &lt;= 3]" >
<td><img src="/_img/spacer.gif" height="1" width="180"/></td>
</xsl:for-each>
			</tr>
			<tr valign="top">
<td></td>
<td></td>
<xsl:for-each select="msxsl:node-set($weekdays)/week/day[position() &lt;= 3]" >
<td style="font: 13px Tahoma"><xsl:value-of select="text()"/></td>
</xsl:for-each>
			</tr>
<xsl:for-each select="$two_hours_names//two_hours">
<xsl:variable name="no" select="@no"/>
			<tr valign="middle" height="40px">
<td><img src="/_img/spacer.gif" width="1" height="70"/></td>
<td class="common" valign="top">
<span class="biginfo"><xsl:value-of select="@no"/></span>
<span class="smallinfo"><br/><br/><xsl:value-of select="@start_time"/><spec code="nbsp"/>-<br/> 
<xsl:value-of select="@end_time"/></span></td>
<xsl:for-each select="msxsl:node-set($weekdays)/week/day[position() &lt;= 3]" >
<td>
<xsl:apply-templates select="$tt/weekday[@id = current()/@id]/two_hours[@no=$no]"/>
</td>
</xsl:for-each>
			</tr>

</xsl:for-each>
			<tr valign="top">
<td></td>
<td></td>
<xsl:for-each select="msxsl:node-set($weekdays)/week/day[position() > 3]" >
<td style="font: 13px Tahoma"><xsl:value-of select="text()"/></td>
</xsl:for-each>
			</tr>
<xsl:for-each select="$two_hours_names//two_hours">
<xsl:variable name="no" select="@no"/>
			<tr valign="middle" height="40px">
<td><img src="/_img/spacer.gif" width="1" height="70"/></td>
<td class="common" valign="top">
<span class="biginfo"><xsl:value-of select="@no"/></span>
<span class="smallinfo"><br/><br/><xsl:value-of select="@start_time"/><spec code="nbsp"/>-<br/> 
<xsl:value-of select="@end_time"/></span></td>
<xsl:for-each select="msxsl:node-set($weekdays)/week/day[position() > 3]" >
<td>
<xsl:apply-templates select="$tt/weekday[@id = current()/@id]/two_hours[@no=$no]"/>
</td>
</xsl:for-each>
			</tr>

</xsl:for-each>
			</table>
		</span>
	</xsl:template>
	
	<xsl:template match="two_hours">
		<xsl:variable name="filtered_lessons" >
			<lessons><xsl:copy-of select="lesson[@spec = 'all' or contains(@spec, $loc_param/@spec)]"/></lessons>
		</xsl:variable>
		<xsl:variable name="this_error_location" select="concat('Weekday:', ../@id, ', Two hours: ', @no)"/>
		<xsl:variable name="les_cnt" select="count(msxsl:node-set($filtered_lessons)/lessons/lesson) "/>

		<xsl:choose>
			<xsl:when test="$les_cnt = 0">
<table><tr><td></td></tr></table>
			</xsl:when>
			<xsl:when test="msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly]">
				<xsl:if test="msxsl:node-set($filtered_lessons)/lessons/lesson[not(fortnightly)] 				or (count(msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly/@type=1]) &gt; 1) or (count(msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly/@type=2]) &gt; 1)">
					<xsl:message terminate="yes">	
						Lessons can't overlap. Occured at <xsl:value-of select="$error_location"/>.
					</xsl:message>
				</xsl:if>
<table border="0" cellspacing="0" cellpadding="0" width="100%"><tr><td class="fortnightly"><xsl:apply-templates select="msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly/@type=1]"/></td></tr>
<tr><td><hr/></td></tr><tr><td class="fortnightly">
<xsl:apply-templates select="msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly/@type=2]"/></td></tr></table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$les_cnt &gt; 1">
					<xsl:message terminate="yes">	
						Too many lessons. Occured at <xsl:value-of select="$error_location"/>.
					</xsl:message>
				</xsl:if>
<table border="0" cellspacing="0" cellpadding="0"><tr><td class="common">
<xsl:apply-templates select="msxsl:node-set($filtered_lessons)/lessons/lesson"/>
</td></tr></table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="lesson">
<span class="biginfo">		<b>
			<xsl:for-each select="location"><xsl:value-of select="text()"/><xsl:if test="position()!=last()">,<spec code="nbsp"/></xsl:if></xsl:for-each>
		</b>
 <spec code="#32"/><xsl:copy-of select="course/prof/node()"/></span><br/>
<span class="smallinfo"><xsl:value-of select="course/name/text()"/></span>
	</xsl:template>
		
	
</xsl:stylesheet>
