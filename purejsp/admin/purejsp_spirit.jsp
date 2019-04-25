<%--
/**
 * @Name PuseJsp 
 * @Author sinmax32
 * @Project https://github.com/sinmax32/purejsp/
 */
--%>
 
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%@ include file="../fn.jsp"%>


<%
	
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");

	Map<String,String> lang = getCfgLang();
	
	String account = (String)request.getSession().getAttribute("Account");
	if( account == null ) {
		out.println(returnStr(3, lang.get("info_login"),  "login.jsp"));
		return;
	}
	
	String nodeName = request.getParameter("node_name");
	if( nodeName != null )
		nodeName = nodeName.trim();
	else {
		nodeName = "";
	}
	
	String[] fields = "pid,create_time,update_time,node_name,class,tag,type,flag,url,json_str,ext_str,int_val,float_val,str_val,remark,account,pwd,title,content,sort,valid".split(",");
	String[] values = new String[fields.length]; 
	
	int n = 0;
	for(String f : fields) {		
		values[n] = request.getParameter(f);
		if( values[n] == null ) {
			values[n] = "";
		}
		n++;
	}
	
	String _ID = request.getParameter("_ID");
	if( _ID == null )
		_ID = "";
	
	
	String action = request.getParameter("action");
	String sql = null;
	String hint = null;
	String spId = "0";
		
	if( "save".equals(action) ) {  //判定为新增或修改
		int id = 0;
		try {
			id =  Integer.valueOf(_ID.trim());
		} catch (Exception e ) {
			id = 0;
		}
		
		if( values[1].equals("") ) 
			values[1] = getDateStr(null);
		
		if( values[2].equals("") ) 
			values[2] = getDateStr(null);
		
		int[] fieldType = new int[]{0,5,5,5,5,5,5,0,5,5,5,0,0,5,5,5,5,5,5,0,0};
		
		//Tip : SQL inject problems
		
		StringBuilder sb = new StringBuilder(); 
		if( id == 0 ) { //insert			
			sb.append("insert into purejsp(");
			sb.append(fields[0]);
			for(int i=1;i<fields.length;i++) {
				sb.append(',').append(fields[i]);
			}			
			sb.append(")values(");
			sb.append(values[0]);
			for(int i=1;i<values.length;i++) {
				sb.append(',');
				if( fieldType[i] < 5 ) {
					sb.append(values[i].equals("") ? 0 : values[i]);
				} else {
					sb.append('\'').append(values[i]).append('\'');	
				}				
			}
			sb.append(')');		
			
			sql = sb.toString();
			//System.out.println(sql);
			if( execUpdate(sql) > -1 ) {
			//if( 1 > -1 ) {
				hint = "Save success";
			} else {
				out.println(returnStr(1, "something wrong", null));
				return;
			}
			
			spId = values[0];
			
		} else if( id > 0 ) { //update
			sb.append("update purejsp set ");
			sb.append(fields[0]).append('=').append('\'').append(values[0]).append('\'');
			for(int i=1;i<fields.length;i++) {
				sb.append(',');
				if( fieldType[i] < 5 ) {
					 if( !values[i].equals("") ) {
						 sb.append(fields[i]).append('=').append(values[i]);
					 }
				} else {
					sb.append(fields[i]).append('=').append('\'').append(values[i]).append('\'');
				}				

			}			
			sb.append(" where id=").append(id);
			
			sql = sb.toString();
			
			//System.out.println(sql);
			if( execUpdate(sql) > -1 ) {
			//if( 1 > -1 ) {
				hint = "Save success";
			} else {
				out.println(returnStr(1, "something wrong", null));
				return;
			}
			
			spId = String.valueOf(id);
		}
	
	}

	//load tree data	
	sql = "select id, pid, node_name from purejsp";
	
	
	List<String[]> list = query(sql);
	
	StringBuilder sbTree = null;
	if( list.size() > 0 ) {
		for(String[] row : list ) {
			if( sbTree == null ) {
				sbTree = new StringBuilder(list.size()*32);	
			} else {
				sbTree.append(',');
			}
			sbTree.append("{'id':'").append(row[0]).append("','parentId': '").append(row[1]).append("','title': '").append(row[2]).append("'}");
		}
	}
		
	String s_options = lang.get("ps_options");
	String s_refresh = lang.get("ps_refresh");
	String s_new = lang.get("ps_new");
	String s_logout = lang.get("ps_logout");

%>

<!DOCTYPE html> 
<html>
<head>
	<title>PureJsp</title>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />	
	<link rel="stylesheet" type="text/css" href="../layui/css/layui.css"  media="all" />
	<script src="../layui/jquery1.12.4.min.js" ></script>
	<script src="../layui/layui.all.js" ></script>	
	
	<link rel="stylesheet" href="../layui_ext/dtree/dtree.css">
	<link rel="stylesheet" href="../layui_ext/dtree/font/dtreefont.css">
	<link rel="stylesheet" href="../layui_ext/dtree/dtree.js">

<style>
.layui-tree-skin-blue .layui-tree-branch{color: #0000FF;}     
</style>
</head>

<body>

<div class="layui-container">
	<blockquote class="layui-elem-quote">
		<%=s_options%>
		<a class="layui-btn layui-btn-primary" href="?" ><%=s_refresh%></a>&nbsp;
		<a class="layui-btn" href="javascript:doNew()"><%=s_new%></a>&nbsp;
		<a class="layui-btn layui-btn-normal" href="login.jsp"><%=s_logout%></a>&nbsp;
	</blockquote>
	
	<div class="layui-row layui-col-space15" >
		<div class="layui-col-md5" >
			<div class="layui-card"" style="border:1px solid">
				<%-- <ul id="demo" ></ul>  --%>
				<ul id="demoTree" class="dtree" data-id="0"></ul>
			</div>
		</div>
		
		<div class="layui-col-md7" >
			<div class="layui-card"  style="border:1px solid blue">
				<div class="layui-card-header">
					<a class="layui-btn layui-btn-normal" href="javascript:doSave(0)"><%=lang.get("ps_save")%></a>					
					<a class="layui-btn layui-btn-warm"  href="javascript:rm()"><%=lang.get("ps_remove")%></a>
					<a class="layui-btn" href="javascript:doSave(1)"><%=lang.get("ps_saveasnew")%></a>
					<br><br>
				</div>
				
				<form id="frm" action="?" method="post" >
				<input type="hidden" id="action" name="action" />
			
				<div class="layui-card-body" style="height:500px;overflow-y:scroll">
					<div class="layui-form-item">
						<label class="layui-form-label">ID</label>
						<div class="layui-input-inline">
							<input id="_ID" type="text" name="_ID" autocomplete="off" placeholder="ID" class="layui-input" style="background-color:#ffffc0" readonly>
						</div>
					</div>
				
				<% 
				
				StringBuffer sb = new StringBuffer();
				for( int i=0;i<fields.length;i++) {
					sb.append("<div class=layui-form-item><label class=layui-form-label>");
					sb.append( lang.get("f_"+fields[i]) );
					sb.append("</label><div class=layui-input-block><input id=_");
					sb.append(fields[i]);
					sb.append(" type=text name="+fields[i]+" autocomplete=off placeholder=");
					sb.append(fields[i]);
					sb.append(" value='"+values[i]+"'");
					
					if( i == 1 || i == 2 ) {
						sb.append(" readonly style='background-color:#F0F0E0'  ");
					} else if( i == 3 ) {
						sb.append(" style='color:#0000FF'  ");
					}
					sb.append(" class='layui-input'></div></div>");
				}
				
				out.println(sb.toString());
				%>		
				
				</div>
				
				</form>
				
			</div>
		</div>
		
	</div>
	
</div>

<script>
var demoTree = [ 
	<% if ( sbTree != null ) out.println(sbTree.toString()); %>
	];

function getPid(id) {
	for(var i=0;i<demoTree.length;i++) {		
		//console.log(demoTree[i]["id"]);
		if( demoTree[i]["id"] == id ) {
			return demoTree[i]["parentId"];
		}
	}
}

function depthSpread(tree, id) {
	while ( id != '0' ) {
		tree.clickSpread(tree.getNode(id));
		id = getPid(id);
	}
}

layui.extend({
	dtree: '{/}../layui_ext/dtree/dtree'  //实际情况下将该路径指定为自己的路径
}).use(['element','layer', 'table', 'code' ,'util', 'dtree'], function(){
	 var dtree = layui.dtree, layer = layui.layer, $ = layui.jquery;
	    var DemoTree = dtree.render({
	      elem: "#demoTree",
	      data: demoTree,
	      //accordion:true,
	      //toolbar:true,
	      dataFormat:"list",
	      type: "all",	      
	      initLevel: "1"
	    });
	    
	    dtree.on("node('demoTree')" ,function(obj){
	      //layer.msg(obj.param);
	      getData(obj.param.nodeId);
	    });
	    
	    setTimeout(function() {
	    	var spId = "<%=spId%>";
	    	
	    	if( spId ) {
	    		depthSpread(DemoTree, spId);
		    	dtree.click(DemoTree, spId);
	    	}
	    	
	    	/*
	    	DemoTree.clickSpread(DemoTree.getNode("1"));
	    	DemoTree.clickSpread(DemoTree.getNode("2"));
	    	DemoTree.clickSpread(DemoTree.getNode("3"));
	    	dtree.click(DemoTree, "3");
	    	*/
	    
	    	//console.log(DemoTree.getNode("3")[0]);
	    }, 300);
	    
});
  
</script>

<script>
function gid(k) {
	return document.getElementById(k);
}

function gidv(k) {
	return gid(k).value;
}

function doSave(f) {
	var frm = gid('frm');
	var node_name = gidv('_node_name');
	if( node_name == '' ) {
		alert('please input the value of node_name')
		return;
	}
	var pid = gidv('_pid');
	if( pid == '' ) {
		alert('please input the value of pid')
		return;
	}
	
	if( f == 1 ) {
		gid('_ID').value = 0;
	}
	
	frm["action"].value="save";
	frm.submit();
}

function getData(nodeId) {
	$.ajax({url:"nodeData.jsp?id="+nodeId,success:function(s){
		var p = s.split('\t');
		console.log(p.length);
		gid('_ID').value = p[1];
		
		var st = 2;
		var k;
		for(var i=0;i<p.length;i++) {
			if( i < st ) continue;
			if( i % 2 == 0 ) {
				k = p[i];
			} else {
				gid('_'+k).value = p[i]; 
			}
		}
	}}); 
}

function rm() {
	layer.msg("do nothing");	
}

function doNew() {	
	var pid = gid('_ID').value;
	$('.layui-input').each(function(n, t){
		t.value='';
	});
	
	gid('_pid').value = pid;	
	gid('_node_name').focus();
	
	
}

<%
if( hint != null && hint.length() > 0 ) {
	out.println("layer.msg('"+hint+"');");
}
%>




</script>

</body>

</html>

