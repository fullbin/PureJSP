<%@ page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%@ include file="../fn.jsp"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");

	String account = request.getParameter("account");
	
	String sql = "select id, pid, node_name, tag, url from purejsp where class='oa_menu' order by pid, id";
	
	List<String[]> list = query(sql);
	StringBuilder sbMenu = null;
	if( list.size() > 0 ) {
		for(String[] row : list ) {
			if( sbMenu == null ) {
				sbMenu = new StringBuilder(list.size()*32);	
			} else {
				sbMenu.append(',');
			}
			sbMenu.append("{'id':'").append(row[0])
			.append("','parentId': '").append(row[1])
			.append("','title': '").append(row[2])
			.append("','lv': '").append(row[3])
			.append("','url': '").append(row[4])
			.append("'}");
		}
	}

	
	
%>

<!DOCTYPE html>
<html style="height:100%">
<head>
<meta charset="utf-8">
<title>PureJSP</title>
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

<script>
layui.use('element', function(){
  var element = layui.element;
  //…
});
</script>

<script>
function setIframeHeight(iframe) {
	if (iframe) {
		iframe.height = document.documentElement.clientHeight - 80;
	}
};

</script>

<script>
var demoTree = [ 
	<% if ( sbMenu != null ) out.println(sbMenu.toString()); %>
	];

function loadTabA(id) {
	var ins = '';
	var href = '#';
	var n = 0;
	for(var i=0;i<demoTree.length;i++) {
		if( demoTree[i]['lv'] == 'lv1') {
			//href = demoTree[i]['url'] == '' ? '#' : demoTree[i]['url'];
			href = 'javascript:loadTabB('+demoTree[i]['id']+')';
			
			if( i == 0 )
				ins += '<li class="layui-nav-item layui-this"><a href="'+href+'">'+demoTree[i]['title']+'</a></li>';
			else
				ins += '<li class="layui-nav-item"><a href="'+href+'">'+demoTree[i]['title']+'</a></li>';
		}
	}
	$('#mainTab').html(ins);
}

function loadLv3(pid) {
	var s = '';
	var href = '#';
	
	for(var i=0;i<demoTree.length;i++) {
		if( demoTree[i]['lv'] == 'lv3' && demoTree[i]['parentId'] == pid ) {
			href = demoTree[i]['url'] == '' ? '#' : demoTree[i]['url'];
			s += '<dd><a href="'+href+'">'+demoTree[i]['title']+'</a></dd>' 
		}
	}
	
	if( s != '' ) {
		return '<dl class="layui-nav-child">'+s+'</dl>'; 
	}
	return '';  
}

function loadTabB(pid) {
	var ins = '';
	var href = '#';
	
	for(var i=0;i<demoTree.length;i++) {
		if( demoTree[i]['lv'] == 'lv2' && demoTree[i]['parentId'] == pid ) {
			var lv3str = loadLv3( demoTree[i]['id'] );
			if( lv3str != '' ) {
				href = '#';
			} else {
				if( demoTree[i]['url'] == '' ) 
					href = '#';
				else
					href = 'javascript:show(\''+demoTree[i]['url']+'\');';
			}
			
			ins += '<li class="layui-nav-item layui-nav-itemed"><a href="'+href+'">'+demoTree[i]['title']+'</a>'+lv3str+'</li>';
		}
	}
	
	$('#leftTab').html(ins);
}

function loadTab() {
	//There's something to be perfected.
	loadTabA();
	loadTabB(demoTree[0]['id']);
}

function show(url) {
	$('#mainFrame').attr('src', url);
}
</script>


<div class="layui-main" style="width:100%">
	<div class="layui-row" >


<ul id='mainTab' class="layui-nav layui-bg-blue" >
  <li class="layui-nav-item layui-this"><a href="">最新活动</a></li>
  <li class="layui-nav-item "><a href="">产品</a></li>
  <li class="layui-nav-item"><a href="">大数据</a></li>
  <li class="layui-nav-item">
    <a href="javascript:;">解决方案</a>
    <dl class="layui-nav-child"> <!-- 二级菜单 -->
      <dd><a href="">移动模块</a></dd>
      <dd><a href="">后台模版</a></dd>
      <dd><a href="">电商平台</a></dd>
    </dl>
  </li>
  <li class="layui-nav-item"><a href="">社区</a></li>
</ul>


	</div>
	
	<div class="layui-row" style="">
	
		<table width="100%">
			<tr>
				<td width="200" style="vertical-align: top;background-color:rgb(0,150,136);">
				
<ul id='leftTab' class="layui-nav layui-nav-tree layui-bg-green" >
  <li class="layui-nav-item layui-nav-itemed">
    <a href="javascript:;">默认展开</a>
    <dl class="layui-nav-child">
      <dd><a href="javascript:;">选项1</a></dd>
      <dd><a href="javascript:;">选项2</a></dd>
      <dd><a href="">跳转</a></dd>
    </dl>
  </li>
  <li class="layui-nav-item">
    <a href="javascript:;">解决方案</a>
    <dl class="layui-nav-child">
      <dd><a href="">移动模块</a></dd>
      <dd><a href="">后台模版</a></dd>
      <dd><a href="">电商平台</a></dd>
    </dl>
  </li>
  <li class="layui-nav-item"><a href="">产品</a></li>
  <li class="layui-nav-item"><a href="">大数据</a></li>
</ul>
				</td>
				
				<td>
					<script>loadTab();</script>
				
					<iframe id="mainFrame" src="" frameborder="0" scrolling="no" width="100%" onload="setIframeHeight(this)" />
				</td>
				
			</tr>
		</table>

	</div>
</div>



</body>
</html>