<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*,java.util.*,java.lang.*,java.text.*" errorPage="errorpage.jsp" %>
<%@ taglib uri="/WEB-INF/runqianReport4.tld" prefix="report" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>	
   <base href="<%=basePath%>">
   <script src="resource/jquery/js/jquery-1.7.2.js" type="text/javascript" charset="UTF-8"></script>
    <script src="resource/jquery/js/jquery-ui-1.8.11.custom.min.js" type="text/javascript" charset="UTF-8"></script>
    <link href="resource/jquery/css/jquery-ui-1.8.11.custom.css" rel="stylesheet" type="text/css" charset="UTF-8"/>
    <script src="resource/jquery/js/jquery.ui.datepicker-zh-CN.js" type="text/javascript" charset="UTF-8"></script>
</head>
<body>
<%
	String start_date1=(String)request.getParameter("start_date1");
	
	String start_date2=(String)request.getParameter("start_date2");
	
	String com_date1=(String)request.getParameter("com_date1");
	
	String com_date2=(String)request.getParameter("com_date2");
	
	String date_flag=(String)request.getParameter("date_flag");
	
	String avg_total=(String)request.getParameter("avg_total");
	
	String rank_method=(String)request.getParameter("rank_method");
	
	String[] lines = request.getParameterValues("lines");
	
	String strline="";
		if(lines!=null){
			for(String tp:lines){
				strline+=",'"+new String(tp.getBytes("iso-8859-1"), "utf-8")+"'";
			}
		}
		if (strline.length() > 1) {
			strline=strline.substring(1);
		}
		strline=strline.replaceAll("'","");

	SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");//设置日期格式
        
	if(start_date1==null){
	  start_date1=df.format(new java.util.Date()); 
    }
	if(start_date2==null){
	  start_date2=start_date1; 
    }	
	if(com_date1==null){
	    Calendar calendar = Calendar.getInstance(); 
        calendar.setTime(new java.util.Date());
        calendar.add(Calendar.DAY_OF_MONTH, -1);  
	    com_date1=df.format(calendar.getTime());
     }
	 if(com_date2==null){
	  com_date2=com_date1; 
    }
	 
	 String[] flags=request.getParameterValues("flag");
	 String flag="";
	 if(flags!=null){
	   	  for(String tp:flags){
		      flag+=","+tp;
		  }
		  flag=flag.substring(1);
	 }else{
		 flag="1,3";
	 }
     String today=df.format(new java.util.Date());
	 String fir_hour=request.getParameter("fir_hour")==null?"00":request.getParameter("fir_hour");
	 String sec_hour=request.getParameter("sec_hour")==null?"00":request.getParameter("sec_hour");
	 String fir_min=request.getParameter("fir_min")==null?"00":request.getParameter("fir_min");
	 String sec_min=request.getParameter("sec_min")==null?"00":request.getParameter("sec_min");
	 String start_time=fir_hour+fir_min+"00";
	 String end_time=sec_hour+sec_min+"00";
	 String part=request.getParameter("part");
     if(("00".equals(fir_hour))||("00".equals(sec_hour))){
         start_time="s020000";
         end_time="a020000";
     }
	 String paramsString="start_date1="+start_date1+";com_date1="+com_date1+";flag="+flag;
	 paramsString+=";start_time="+start_time+";end_time="+end_time+";part="+part+";start_date2="+start_date2+";com_date2="+com_date2;
	 paramsString+=";avg_total="+avg_total+";lines="+lines+";rank_method="+rank_method;
//out.println(paramsString);

		

%>
<form id="form1" action="<%=request.getContextPath()%>/param/custom_line_yoy.jsp">
	<table>
		<tr>
			<td>
				<table border="1">
					<tr>
						<td>查询日期：<input type=text name="start_date1" style="width:80px;" id="start_date1">-<input type=text name="start_date2" id="start_date2" style="width:80px;"> </td>
						<td>对比日期：<input type=text name="com_date1" style="width:80px;" id="com_date1">-<input type=text name="com_date2" id="com_date2" style="width:80px;"></td>
						<td>日期类型：<select name="date_flag"  id="date_flag" >  
								  <option value="">全部</option>
								  <option value="1">工作日</option>
								  <option value="2">双休日</option>
							</select>
						</td>
						<td>开始时间点：
							<select name="fir_hour" id="fir_hour">
								<option value="00">全天</option>
								<option value="02">02</option>
								<option value="03">03</option>
								<option value="04">04</option>
								<option value="05">05</option>
								<option value="06">06</option>
								<option value="07">07</option>
								<option value="08">08</option>
								<option value="09">09</option>
								<option value="10">10</option>
								<option value="11">11</option>
								<option value="12">12</option>
								<option value="13">13</option>
								<option value="14">14</option>
								<option value="15">15</option>
								<option value="16">16</option>
								<option value="17">17</option>
								<option value="18">18</option>
								<option value="19">19</option>
								<option value="20">20</option>
								<option value="21">21</option>
								<option value="22">22</option>
								<option value="23">23</option>
								<option value="a00">+00</option>
								<option value="a01">+01</option>
								<option value="a02">+02</option>
							</select>
							<select name="fir_min" id="fir_min">
								<option value="00">00</option>
								<option value="05">05</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25">25</option>
								<option value="30">30</option>
								<option value="35">35</option>
								<option value="40">40</option>
								<option value="45">45</option>
								<option value="50">50</option>
								<option value="55">55</option>
							</select>
						</td>
						<td>结束时间点：
							<select name="sec_hour" id="sec_hour">
								<option value="00">全天</option>
								<option value="02">02</option>
								<option value="03">03</option>
								<option value="04">04</option>
								<option value="05">05</option>
								<option value="06">06</option>
								<option value="07">07</option>
								<option value="08">08</option>
								<option value="09">09</option>
								<option value="10">10</option>
								<option value="11">11</option>
								<option value="12">12</option>
								<option value="13">13</option>
								<option value="14">14</option>
								<option value="15">15</option>
								<option value="16">16</option>
								<option value="17">17</option>
								<option value="18">18</option>
								<option value="19">19</option>
								<option value="20">20</option>
								<option value="21">21</option>
								<option value="22">22</option>
								<option value="23">23</option>
								<option value="a00">+00</option>
								<option value="a01">+01</option>
								<option value="a02">+02</option>
							</select>
							<select name="sec_min" id="sec_min">
								<option value="00">00</option>
								<option value="05">05</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25">25</option>
								<option value="30">30</option>
								<option value="35">35</option>
								<option value="40">40</option>
								<option value="45">45</option>
								<option value="50">50</option>
								<option value="55">55</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="flag" value="1">进站</input>
							<input type="checkbox" name="flag" value="2">出站</input>
							<input type="checkbox" name="flag" value="3">换乘</input> 
						</td>
						<td>
								值类型：<select name="avg_total"  id="avg_total" >  
									  <option value="avg">均值</option>
									  <option value="total">总和</option>
								</select>
						</td>
						<td>排序方式：
							<select name="rank_method" id="rank_method">
								<option value='xl'>按线路顺序</option>
								<option value='kl'>按客流排名顺序</option>
								<option value='zl'>按增量排序</option>
								<option value='zf'>按增幅排序</option>
							</select>
						</td>
					</tr>
					<tr>
						<td id="line_show" colspan="4">
							
						</td>
						<td>
							<input type="button" value="选择线路" onclick='preadd();'>
							<input type=button value=表格 onclick="formsubmit();" style="FONT-SIZE: 13px; WIDTH: 40px; COLOR: mediumblue; FONT-FAMILY: 宋体; HEIGHT: 22px; BACKGROUND-COLOR: wheat">
						</td>
					</tr>
				</table>
			</td>
		<tr>
	</table>
	<input type=hidden name=report_name value="<%=(String)request.getParameter("report_name")%>">
	<input type=hidden name=param_type value="<%=(String)request.getParameter("param_type")%>">
	<input type=hidden name=report_name_cn value="<%=(String)request.getAttribute("report_name_cn")%>">
<input type=hidden name=part  id=part>
</form>
<div id="select_line" align="center"
			style="z-index:3; display: none; background-color: #393939; width: 100%; height: 100%; position: fixed; filter: alpha(opacity:60); opacity: 0.6;">
			<div style="width: 600px; height:500px; border: 1px solid #E3E3E3; background-color: #F5F5F5; margin-top: 10px;color:#000;">
				<div style="font-weight: bolder; margin-top:5px;">
					请选择线路
				</div>
				<div style="font-size: 14px; font-weight: normal; font-family: 'Microsoft YaHei', '微软雅黑', '宋体'; padding:0px 20px;color:#000;">
					<table align="left" style="color:#000;">
						<tr>
							<td>
								<div id="all_lines" style="border:solid #000 1px;height:400;width:240px;overflow:auto">
									<div style='width:150px'><input value='00' type='checkbox'><span class='lbl'>全路网</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='01' type='checkbox'><span class='lbl'>轨道交通01号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='02' type='checkbox'><span class='lbl'>轨道交通02号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='03' type='checkbox'><span class='lbl'>轨道交通03号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='04' type='checkbox'><span class='lbl'>轨道交通04号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='05' type='checkbox'><span class='lbl'>轨道交通05号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='06' type='checkbox'><span class='lbl'>轨道交通06号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='07' type='checkbox'><span class='lbl'>轨道交通07号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='08' type='checkbox'><span class='lbl'>轨道交通08号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='09' type='checkbox'><span class='lbl'>轨道交通09号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='10' type='checkbox'><span class='lbl'>轨道交通10号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='11' type='checkbox'><span class='lbl'>轨道交通11号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='12' type='checkbox'><span class='lbl'>轨道交通12号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='13' type='checkbox'><span class='lbl'>轨道交通13号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='16' type='checkbox'><span class='lbl'>轨道交通16号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='17' type='checkbox'><span class='lbl'>轨道交通17号线</span>&nbsp;&nbsp;</div>
									<div style='width:150px'><input value='41' type='checkbox'><span class='lbl'>轨道交通41号线</span>&nbsp;&nbsp;</div>
								</div>
							</td>
							<td width="80" align="center">
								<input type="button" value=">" onclick="addCheckedLine()" style="font-size:16px;font-weight: bolder"/><br><br>
								<input type="button" value="<" onclick="remCheckedLine()" style="font-size:16px;font-weight: bolder"/>
							</td>
							<td>
								<div id="select_lines" style="border:solid #000 1px;height:400;width:240px;overflow:auto">
								
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="3" style="text-align: center;">
								<input type="button" value="关闭" onclick="closediv()" />&nbsp;&nbsp;
								<input type="button" value="确定" onclick="add()" />
							</td>
						</tr>
					</table>
				</div>
			</div>
<script type="text/javascript"> 

	$('.datecla').datepicker();
   	$('.datecla').datepicker('option', 'dateFormat', 'yymmdd');
	
	$('#start_date1').val("<%=start_date1%>");
	$('#com_date1').val("<%=com_date1%>");
	
	$('#start_date2').val("<%=start_date2%>");
	$('#com_date2').val("<%=com_date2%>");
	
	$("#date_flag").val("<%=date_flag%>");
	
	$("#avg_total").val("<%=avg_total%>");
	
	$("#rank_method").val("<%=rank_method%>");
	
	var flag='<%=flag%>';
    var flag_box=document.getElementsByName("flag");
   	for(var i=0;i<flag_box.length;i++){
   		if(flag.toString().indexOf(flag_box[i].value)>-1){
   			flag_box[i].checked=true;
   		}else{
			flag_box[i].checked=false;
		}
   	}
   	
	var selLine = "<%=strline%>";
	if(selLine){
		var selLines=selLine.split(",");
		var tp_ht="";
		var flagall = false;
		$(selLines).each(function(i, v) {
			if(v=='00'){
				flagall = true;
			}
			tp_ht+="轨道交通"+v+"号线;&nbsp;&nbsp;<input type='hidden' name='lines' value='"+v+"'>";
		});
		
		if(flagall){
			$("#line_show").html("全路网<input type='hidden' name='lines' value='00'>");
		}else{
			$("#line_show").html(tp_ht);
		}
		
	}
	
   	$('#fir_hour').val("<%=fir_hour%>");
   	$('#fir_min').val("<%=fir_min%>");
   	$('#sec_hour').val("<%=sec_hour%>");
   	$('#sec_min').val("<%=sec_min%>");
	
	

   	function formsubmit(){
	   var date1=document.getElementById("start_date1").value;
	   var date2=document.getElementById("com_date1").value;
	   var d1=new Date(date1.substr(0,4),date1.substr(4,2),date1.substr(6,2));
	    var d2=new Date(date2.substr(0,4),date2.substr(4,2),date2.substr(6,2));
		var gap=(d1-d2)/(24*60*60*1000);
	   if(gap>60){
	        document.getElementById("part").value="0";
		    form1.submit();     
	   }else{
			document.getElementById("part").value="1";
		 	form1.submit();     
	   }
	}
	
		//添加选中的线路
	function addCheckedLine() {
		//获取选中的线路
		var lines = $("#all_lines input[type='checkbox']:checked");
		if (lines && lines.length > 0) {
			
			lines.each(function(i, v) {
						var flag = true;
						$("#select_lines input[type='checkbox']").each(
								function(j, l) {
									if (v.value == l.value) {
										flag = false;
									}
								});
						if (flag) {
							var tp = "";
							if(v.value=='00'){
								tp = "<div style='width:150px'><input value='"+ v.value
									+ "' type='checkbox'><span class='lbl'>全路网</span>&nbsp;&nbsp;</div>";
							}else{
								tp = "<div style='width:150px'><input value='"+ v.value
									+ "' type='checkbox'><span class='lbl'>轨道交通"+ v.value
									+ "号线</span>&nbsp;&nbsp;</div>";
							}
							$("#select_lines").append(tp);
						}
					});
		} else {
			alert("请选择要添加的线路！");
		}
	}
	//移除选中的线路
	function remCheckedLine() {
		//获取选中的线路
		var lines = $("#select_lines input[type='checkbox']:checked");
		if (!(lines && lines.length > 0)) {
			alert("请选择要移除的线路！");
		}
		lines.each(function(i, v) {
			$(this).parent().remove();
		});
	}
	//弹出线路选项
	function preadd() {
		$("#select_line").show();
	}
	//关闭线路选项
	function closediv() {
		$("#select_line").hide();
	}
	//选择线路
	function add() {
		$("#select_line").hide();
		var lines = $("#select_lines input[type='checkbox']");
		var tp_ht="";
		var flagall = false;
		lines.each(function(i, v) {
			if(v.value=='00'){
				flagall = true;
			}
			tp_ht+="轨道交通"+v.value+"号线;&nbsp;&nbsp;<input type='hidden' name='lines' value='"+v.value+"'>";
		});
		if(flagall){
			$("#line_show").html("全路网<input type='hidden' name='lines' value='00'>");
		}else{
			$("#line_show").html(tp_ht);
		}
		
	}

</script>
<%if(flags!=null){%>
<report:html name="line_add_part" reportFileName="custom_line_yoy.raq"
	funcBarLocation="boTh"
	needPageMark="yes" 
	scale="1"
	functionBarColor="#fff5ee"
	funcBarFontSize="9pt"
	funcBarFontColor="blue"
	separator="&nbsp;&nbsp;"
	needSaveAsExcel="yes"
	needSaveAsPdf="yes"
	needPrint="yes"
	pageMarkLabel="页号{currpage}/{totalPage}"
	printLabel="打印"
	displayNoLinkPageMark="yes"
	params="<%=paramsString%>"
	saveAsName="线路客流同比"
	useCache="no"
/>
<%}%>
</body>
</html>
