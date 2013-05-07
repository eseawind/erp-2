<!--
 *this file is part of nseer erp
 *Copyright (C)2006-2010 Nseer(Beijing) Technology co.LTD/http://www.nseer.com 
 *
 *This program is free software; you can redistribute it and/or
 *modify it under the terms of the GNU General Public License
 *as published by the Free Software Foundation; either
 *version 2 of the License, or (at your option) any later version.
 -->
<%@page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,include.nseer_cookie.*" import="java.util.*" import="java.io.*" import="include.nseer_cookie.exchange" import ="include.nseer_db.*,java.text.*"%>
<jsp:useBean id="validata" scope ="page" class ="validata.ValidataNumber"/>
<%nseer_db stock_db = new nseer_db((String)session.getAttribute("unit_db_name"));%>
<%nseer_db stock_db1 = new nseer_db((String)session.getAttribute("unit_db_name"));%>
<jsp:useBean id="query" scope="page" class="include.query.getRecordCount"/>
<%@ taglib uri="/WEB-INF/mytag.tld" prefix="page"%>
<%@include file="../include/head_list.jsp"%>
<jsp:useBean id="demo" class="include.tree_index.businessComment" scope="page"/>
<jsp:useBean id="NseerSql" class="include.query.NseerSql" scope="page"/>
<jsp:useBean id="mask" class="include.operateXML.Reading"/>
<jsp:setProperty name="mask" property="file" value="xml/stock/stock_balance.xml"/>
<% 
try{
	String tablename="stock_balance";
DealWithString DealWithString=new DealWithString(application);
String mod=request.getRequestURI();
	 demo.setPath(request);
	 String handbook=demo.businessComment(mod,"您正在做的业务是：","document_main","reason","value");%>
  <table <%=TABLE_STYLE2%> class="TABLE_STYLE2">
 <tr <%=TR_STYLE1%> class="TR_STYLE1">
 <td <%=TD_HANDBOOK_STYLE1%> class="TD_HANDBOOK_STYLE1"><div class="div_handbook"><%=handbook%></div></td>
 </tr>
 </table>
<script language="javascript" src="../../javascript/winopen/winopen.js"></script>
<%
String condition="";
String register_ID=(String)session.getAttribute("human_IDD");
String realname=(String)session.getAttribute("realeditorc");
String condition0="address_group!=''";
String queue="order by chain_id";
String validationXml="../../xml/stock/stock_balance.xml";
String nickName="动态库存";
String fileName="queryBalance_list.jsp";
String rowSummary=demo.getLang("erp","符合条件的产品总数");
int k=1;
%>
<%@include file="../../include/search_a.jsp"%>
<%
condition=condition0;
%>
<%@include file="../../include/search_b.jsp"%>
<%
ResultSet rs1 = stock_db.executeQuery(sql_search);
otherButtons="&nbsp;<input type=\"button\" "+BUTTON_STYLE1+" class=\"BUTTON_STYLE1\" id=\"select_all\" value=\""+demo.getLang("erp","打印")+"\"  onclick=\"javascript:winopen('queryBalance_list_print.jsp')\">";

int n=0;
int m=0;
double amount=0.0d;
while(rs1.next()){
	amount+=rs1.getDouble("amount");
String sql2="select min_amount,max_amount from stock_cell where product_ID='"+rs1.getString("product_ID")+"'";
ResultSet rs2=stock_db1.executeQuery(sql2);
if(rs2.next()){
	if(rs1.getDouble("amount")>rs2.getDouble("max_amount")){
	n++;
	}
	if(rs1.getDouble("amount")<rs2.getDouble("min_amount")){
	m++;
	}
}
}
rs1 = stock_db.executeQuery(sql_search);
%>

<script type="text/javascript">
function load_ajax() {
	var xmlhttp;
	if (window.XMLHttpRequest) {
		xmlhttp=new XMLHttpRequest();
	}
	else {
		xmlhttp=new ActiveObject("Microsotf.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function(){
		if (xmlhttp.readyState==4 && xmlhttp.status==200){
			alert(xmlhttp.responseText);
			var jsonString=xmlhttp.responseText;
			var data=eval("("+jsonString+")");
			//alert("ok");
			//alert(data[1]);
			load_div_data(data);
			//document.getElementById("ajax_text_div").innerHTML=xmlhttp.responseText;
		}
	}
	xmlhttp.open("GET", "queryBalance_list_ajax.jsp", true);
	xmlhttp.send();
}

function load_div_data(parse_json_data) {
	var nseer_grid = new nseergrid();
	nseer_grid.callname = "nseer_grid";
	nseer_grid.parentNode = nseer_grid.$("nseer_grid_div");
	nseer_grid.columns =[
					   {name: '<%=demo.getLang("erp","产品分类")%>'},
                       {name: '<%=demo.getLang("erp","产品编号/名称")%>'},
	                   {name: '<%=demo.getLang("erp","库存数量")%>'},
                       {name: '<%=demo.getLang("erp","安全库存上限")%>'},
	                   {name: '<%=demo.getLang("erp","安全库存下限")%>'},
	                   {name: '<%=demo.getLang("erp","质检不合格数")%>'}
	]
	nseer_grid.column_width=[300,200,100,100,100,100];
	nseer_grid.auto='<%=demo.getLang("erp","产品编号/名称")%>';
	
	//nseer_grid.data need this!
	parse_json_data.push(['']);
	nseer_grid.data = parse_json_data;
	
	nseer_grid.init();
}
</script>
<table>
  <tr>
    <td><input type="text" onclick="load_ajax();"></td>
  </tr>
</table>

<div id="ajax_text_div">
</div>

<div>
	<input type="button" <%=BUTTON_STYLE1%> class="BUTTON_STYLE1" value="<%=demo.getLang("erp","图表显示")%>" onClick="winopen('../monitor/query.jsp')"/>
</div>
<div id="nseer_grid_div"></div>
<script type="text/javascript">
function id_link(link){
document.location.href=link;
}
</script>
<div id="drag_div"></div>
<div id="point_div_t"></div>
<div id="point_div_b"></div>
<%@include file="../../include/search_bottom.jsp"%>
<page:updowntag num="<%=intRowCount%>" file="<%=fileName%>"/>
<%
stock_db.close();	
stock_db1.close();
}catch(Exception e){e.printStackTrace();}	
%>
<%@include file="../../include/head_msg.jsp"%>