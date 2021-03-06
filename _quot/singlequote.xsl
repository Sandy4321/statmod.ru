﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
	<xsl:variable name="specs">	
		<specs>		
			<spec id="sm">СМ</spec>
			<spec id="sa">САПР</spec>
 			<spec id="mm">ММ</spec>
		</specs>		
	</xsl:variable>	

	<xsl:template match="quote" mode="insert_quote">
	    <p>
			<span class="quote_head">
	     			<xsl:value-of select="@year"/>(<xsl:value-of select="msxsl:node-set($specs)/specs/spec[@id=current()/@spec]/node()"/>):
			</span>
			<span class="quote_body">
				<spec code="quot"/><xsl:copy-of select="node()"/><spec code="quot"/>
			</span>
		</p>
	</xsl:template>
</xsl:stylesheet>
