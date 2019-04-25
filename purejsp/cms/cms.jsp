<%@ page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%@ include file="../fn.jsp"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");

	String account = request.getParameter("account");
	
	String sql = "select id, pid, node_name, tag, url from purejsp where class='cms' order by pid, id";
	
	List<String[]> list = query(sql);
	StringBuilder sbMenu = new StringBuilder(list.size()*32);
	int n = 0;
	if( list.size() > 0 ) {
		for(String[] row : list ) {
			if( "lv1".equals( row[3]) ) {
				sbMenu.append("<li class='layui-nav-item");
				if( n == 0 ) {
					sbMenu.append(" layui-this");
					n++;
				}
				
				sbMenu.append("'><a href='")
				.append(row[4].length()==0 ? "#" : row[4])
				.append("'>").append(row[2]).append("</a>");
				
				sbMenu.append(getLv3menu(list, "lv2", toInt(row[0])));
				
				sbMenu.append("</li>");
			}
			
		}
	}

	
	
%>

<!DOCTYPE html> 
<html>
<head>
	<title>PureJSP</title>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<meta name="apple-mobile-web-app-capable" content="yes">
	<link rel="stylesheet" type="text/css" href="../layui/css/layui.css"  media="all" />
	<script src="../layui/jquery1.12.4.min.js" ></script>
	<script src="../layui/layui.js" ></script>


</head>

<body>

<div class="layui-main" style="width:100%">
	<div class="layui-row" >	
		<ul class="layui-nav" lay-filter="">
		
			<% 
			out.println(sbMenu.toString());
			%>
		
	</div>
</div>

<script>
layui.use('element', function(){
  var element = layui.element;
  //…
});
</script>


</body>

</html>

