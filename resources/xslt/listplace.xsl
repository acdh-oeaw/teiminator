<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:param name="entiyID"/>
    <xsl:template match="/"><!-- Modal -->
        <div class="modal" id="myModal" role="dialog">
            <div class="modal-dialog"><!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span class="fa fa-times"/>
                        </button>
                        <h4 class="modal-title">
                            <xsl:value-of select="//tei:place[@xml:id=$entiyID]/tei:placeName[@type='pref']"/>
                        </h4>
                    </div>
                    <div class="modal-body">
                        <table class="table table-boardered table-hover">
                            <tr>
                                <th>Alternative Schreibweisen</th>
                                <td>
                                    <xsl:for-each select="//tei:place[@xml:id=$entiyID]//tei:placeName[@type='alt']">
                                        <li>
                                            <xsl:value-of select="."/>
                                        </li>
                                    </xsl:for-each>
                                </td>
                            </tr>
                            <xsl:choose>
                                <xsl:when test=".//tei:place[@xml:id=$entiyID]//tei:location">
                                    <tr>
                                        <th>GPS-Coordinates</th>
                                        <td>
                                            <xsl:value-of select=".//tei:place[@xml:id=$entiyID]//tei:location"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Getty-ID</th>
                                        <td>
                                            <xsl:value-of select=".//tei:place[@xml:id=$entiyID]//tei:idno"/>
                                        </td>
                                    </tr>
                                </xsl:when>
                            </xsl:choose>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(window).load(function(){
            $('#myModal').modal('show');
            });
        </script>
    </xsl:template>
</xsl:stylesheet>