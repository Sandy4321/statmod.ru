<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pr="http://statmod.ru/staff">
<xsl:template match="pr:person" mode="short_name">
<xsl:value-of select="pr:ln/text()"/><spec code="nbsp"/><xsl:value-of select="substring(pr:fn/text(),1,1)"/>.<xsl:value-of select="substring(pr:mn/text(),1,1)"/>.
</xsl:template>
</xsl:stylesheet>

