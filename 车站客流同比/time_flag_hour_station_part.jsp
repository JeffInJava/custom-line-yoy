<%@ page contentType="text/html; charset=GBK" language="java" import="java.sql.*,java.lang.*,java.util.*,java.text.*" errorPage="errorpage.jsp" %>
<%@ taglib uri="/WEB-INF/runqianReport4.tld" prefix="report" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
<base href="<%=basePath%>">	
<title>车站客流同比</title>
   <script src="resource/jquery/js/jquery-1.7.2.js" type="text/javascript" charset="UTF-8"></script>
    <script src="resource/jquery/js/jquery-ui-1.8.11.custom.min.js" type="text/javascript" charset="UTF-8"></script>
    <link href="resource/jquery/css/jquery-ui-1.8.11.custom.css" rel="stylesheet" type="text/css" charset="UTF-8"/>
    <script src="resource/jquery/js/jquery.ui.datepicker-zh-CN.js" type="text/javascript" charset="UTF-8"></script>
</head>

<body>
<%
	String start_date1=request.getParameter("start_date1");
	String start_date2=request.getParameter("start_date2");	
 	SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");//设置日期格式     
	if(start_date1==null||start_date1.trim().length()==0){
	   start_date1=df.format(new java.util.Date()); 
    }	   
	if(start_date2==null){
	   Calendar calendar = Calendar.getInstance(); 
                    calendar.setTime(new java.util.Date());
                     calendar.add(Calendar.DAY_OF_MONTH, -1);  
	   start_date2=df.format(calendar.getTime());
    }
	String flag=request.getParameter("flag")==null?"0":request.getParameter("flag");//车站类型
	String rnum=request.getParameter("rnum")==null?"5":request.getParameter("rnum");//前10位，前20位
	String pm=request.getParameter("pm")==null?"zl":request.getParameter("pm");  //排名方式
	String[] enter_flags=request.getParameterValues("enter_flag");
	String enter_flag="";    //进站，出站，换乘
	String fir_hour=request.getParameter("fir_hour")==null?"00":request.getParameter("fir_hour");
	String sec_hour=request.getParameter("sec_hour")==null?"24":request.getParameter("sec_hour");
	String fir_min=request.getParameter("fir_min")==null?"00":request.getParameter("fir_min");
	String sec_min=request.getParameter("sec_min")==null?"00":request.getParameter("sec_min");
	String paramsString="start_date1="+start_date1+";start_date2="+start_date2+";state="+flag;
	String start_time=fir_hour+fir_min+"00";                
	String end_time=("00".equals(sec_hour)?"24":sec_hour)+sec_min+"00";
	 if(enter_flags!=null){
  	  for(String tp:enter_flags){
  		enter_flag+=","+tp;
	   }
	   enter_flag=enter_flag.substring(1);
	 }else{
		 enter_flag="1,3";
	 }
	 String field="";  //查询字段
	 if(enter_flag.indexOf('1')!=-1){
	     field+="+enter_times";
	 }
	 if(enter_flag.indexOf('2')!=-1){
	     field+="+exit_times";
	 }
	 if(enter_flag.indexOf('3')!=-1){
	     field+="+change_times";
	 }
	 field=field.substring(1);
	 String today=df.format(new java.util.Date());
	 String cur_time="2400";
	// if((today.equals(start_date1))||(today.equals(start_date2))){
         //  if("24".equals(sec_hour)){
	//	     Calendar cal=Calendar.getInstance();
	//	     cal.add(Calendar.MINUTE,-30);
            //  SimpleDateFormat sdf = new SimpleDateFormat("HHmm"); 
	//	      end_time=sdf.format(cal.getTime())+"00";
	//	  }
	     
	// }
	String part=request.getParameter("part");
	if(("00".equals(fir_hour))||("24".equals(sec_hour))){
						   start_time="020000";
							 end_time="a020000";
				 }
	 paramsString+=";rnum="+rnum+";pm="+pm+";field="+field+";cur_time="+cur_time;
     paramsString+=";flag="+enter_flag+";start_time="+start_time+";end_time="+end_time+";part="+part;
	//out.println(paramsString);
%>
<form id="form1" action="<%=request.getContextPath()%>/param/time_flag_hour_station_part.jsp">
	<table>
		<td>
			<table border="1">
				<tr>
					<td style="BORDER-RIGHT: #000000 0px solid; BORDER-TOP: #000000 1px; PADDING-LEFT: 3px; FONT-WEIGHT: normal; FONT-SIZE: 12px; VERTICAL-ALIGN: middle; BORDER-LEFT: #000000 1px; COLOR: #000000; BORDER-BOTTOM: #000000 1px; FONT-STYLE: normal; FONT-FAMILY: 宋体; BACKGROUND-COLOR: #ffffff; TEXT-ALIGN: left; TEXT-DECORATION: none">运营日期: </td>
					<td><input type=text name="start_date1" id="start_date1" class="datecla" id="start_date1"></td>
					<td style="BORDER-RIGHT: #000000 0px solid; BORDER-TOP: #000000 1px; PADDING-LEFT: 3px; FONT-WEIGHT: normal; FONT-SIZE: 12px; VERTICAL-ALIGN: middle; BORDER-LEFT: #000000 1px; COLOR: #000000; BORDER-BOTTOM: #000000 1px; FONT-STYLE: normal; FONT-FAMILY: 宋体; BACKGROUND-COLOR: #ffffff; TEXT-ALIGN: left; TEXT-DECORATION: none">对比日期: </td>
					<td><input type=text name="start_date2" id="start_date2" class="datecla"  id="start_date2"></td>
					<td style="BORDER-RIGHT: #000000 0px solid; BORDER-TOP: #000000 1px; PADDING-LEFT: 3px; FONT-WEIGHT: normal; FONT-SIZE: 12px; VERTICAL-ALIGN: middle; BORDER-LEFT: #000000 1px; COLOR: #000000; BORDER-BOTTOM: #000000 1px; FONT-STYLE: normal; FONT-FAMILY: 宋体; BACKGROUND-COLOR: #ffffff; TEXT-ALIGN: left; TEXT-DECORATION: none">车站类型: </td>
					<td>
						<select name='flag' value='2'>
						    <option value='0' <%if("0".equals(flag)){%> selected='selected' <%}%>>全路网</option>
							<option value='1' <%if("1".equals(flag)){%> selected='selected' <%}%>>换乘站</option>
							<option value='2' <%if("2".equals(flag)){%> selected='selected' <%}%>>非换乘站</option>
						</select>
					</td>
					<td colspan="2">
						<input type="checkbox" name="enter_flag" value="1" 
						 <%if(enter_flag.indexOf('1')!=-1){%>checked="checked"<%}%>>进站</input>
						<input type="checkbox" name="enter_flag" value="2" 
                         <%if(enter_flag.indexOf('2')!=-1){%>checked="checked"<%}%>>出站</input>
						<input type="checkbox" name="enter_flag" value="3"
						 <%if(enter_flag.indexOf('3')!=-1){%>checked="checked"<%}%>>换乘</input> 
					</td>
				</tr>
				<tr>
					<td style="BORDER-RIGHT: #000000 0px solid; BORDER-TOP: #000000 1px; PADDING-LEFT: 3px; FONT-WEIGHT: normal; FONT-SIZE: 12px; VERTICAL-ALIGN: middle; BORDER-LEFT: #000000 1px; COLOR: #000000; BORDER-BOTTOM: #000000 1px; FONT-STYLE: normal; FONT-FAMILY: 宋体; BACKGROUND-COLOR: #ffffff; TEXT-ALIGN: left; TEXT-DECORATION: none">开始时间点</td>
					<td>
						<select name="fir_hour" id="fir_hour">
							<option value="00" <%if("00".equals(fir_hour)){%>selected="selected"<%}%>>全天</option>
							<option value="02" 
							<%if("02".equals(fir_hour)){%>selected="selected"<%}%>>02</option>
							<option value="03" 
							<%if("03".equals(fir_hour)){%>selected="selected"<%}%>>03</option>
							<option value="04" 
							<%if("04".equals(fir_hour)){%>selected="selected"<%}%>>04</option>
							<option value="05" 
							<%if("05".equals(fir_hour)){%>selected="selected"<%}%>>05</option>
							<option value="06"
							<%if("06".equals(fir_hour)){%>selected="selected"<%}%>>06</option>
							<option value="07"
							<%if("07".equals(fir_hour)){%>selected="selected"<%}%>>07</option>
							<option value="08"
							<%if("08".equals(fir_hour)){%>selected="selected"<%}%>>08</option>
							<option value="09"
							<%if("09".equals(fir_hour)){%>selected="selected"<%}%>>09</option>
							<option value="10"
							<%if("10".equals(fir_hour)){%>selected="selected"<%}%>>10</option>
							<option value="11"
							<%if("11".equals(fir_hour)){%>selected="selected"<%}%>>11</option>
							<option value="12"
							<%if("12".equals(fir_hour)){%>selected="selected"<%}%>>12</option>
							<option value="13"
							<%if("13".equals(fir_hour)){%>selected="selected"<%}%>>13</option>
							<option value="14"
							<%if("14".equals(fir_hour)){%>selected="selected"<%}%>>14</option>
							<option value="15"
							<%if("15".equals(fir_hour)){%>selected="selected"<%}%>>15</option>
							<option value="16"
							<%if("16".equals(fir_hour)){%>selected="selected"<%}%>>16</option>
							<option value="17"
							<%if("17".equals(fir_hour)){%>selected="selected"<%}%>>17</option>
							<option value="18"
							<%if("18".equals(fir_hour)){%>selected="selected"<%}%>>18</option>
							<option value="19"
							<%if("19".equals(fir_hour)){%>selected="selected"<%}%>>19</option>
							<option value="20"
							<%if("20".equals(fir_hour)){%>selected="selected"<%}%>>20</option>
							<option value="21"
							<%if("21".equals(fir_hour)){%>selected="selected"<%}%>>21</option>
							<option value="22"
							<%if("22".equals(fir_hour)){%>selected="selected"<%}%>>22</option>
							<option value="23"
							<%if("23".equals(fir_hour)){%>selected="selected"<%}%>>23</option>
							<option value="a00"
							<%if("a00".equals(fir_hour)){%>selected="selected"<%}%>>+00</option>
							<option value="a01"
							<%if("a01".equals(fir_hour)){%>selected="selected"<%}%>>+01</option>
							<option value="a02"
							<%if("a02".equals(fir_hour)){%>selected="selected"<%}%>>+02</option>
						</select>
						<select name="fir_min" id="fir_min">
							<option value="00" <%if("00".equals(fir_min)){%>selected="selected"<%}%>>00</option>
							<option value="30" <%if("30".equals(fir_min)){%>selected="selected"<%}%>>30</option>
						</select>
					</td>
					<td style="BORDER-RIGHT: #000000 0px solid; BORDER-TOP: #000000 1px; PADDING-LEFT: 3px; FONT-WEIGHT: normal; FONT-SIZE: 12px; VERTICAL-ALIGN: middle; BORDER-LEFT: #000000 1px; COLOR: #000000; BORDER-BOTTOM: #000000 1px; FONT-STYLE: normal; FONT-FAMILY: 宋体; BACKGROUND-COLOR: #ffffff; TEXT-ALIGN: left; TEXT-DECORATION: none">结束时间点</td>
					<td>
						<select name="sec_hour" id="sec_hour">
							<option value="24" <%if("00".equals(sec_hour)){%>selected="selected"<%}%>>全天</option>
							<option value="02" <%if("02".equals(sec_hour)){%>selected="selected"<%}%>>02</option>
							<option value="03" <%if("03".equals(sec_hour)){%>selected="selected"<%}%>>03</option>
							<option value="04" <%if("04".equals(sec_hour)){%>selected="selected"<%}%>>04</option>
							<option value="05" <%if("05".equals(sec_hour)){%>selected="selected"<%}%>>05</option>
							<option value="06" <%if("06".equals(sec_hour)){%>selected="selected"<%}%>>06</option>
							<option value="07" <%if("07".equals(sec_hour)){%>selected="selected"<%}%>>07</option>
							<option value="08" <%if("08".equals(sec_hour)){%>selected="selected"<%}%>>08</option>
							<option value="09" <%if("09".equals(sec_hour)){%>selected="selected"<%}%>>09</option>
							<option value="10" <%if("10".equals(sec_hour)){%>selected="selected"<%}%>>10</option>
							<option value="11" <%if("11".equals(sec_hour)){%>selected="selected"<%}%>>11</option>
							<option value="12" <%if("12".equals(sec_hour)){%>selected="selected"<%}%>>12</option>
							<option value="12" <%if("12".equals(sec_hour)){%>selected="selected"<%}%>>13</option>
							<option value="13" <%if("13".equals(sec_hour)){%>selected="selected"<%}%>>14</option>
							<option value="15" <%if("15".equals(sec_hour)){%>selected="selected"<%}%>>15</option>
							<option value="16" <%if("16".equals(sec_hour)){%>selected="selected"<%}%>>16</option>
							<option value="17" <%if("17".equals(sec_hour)){%>selected="selected"<%}%>>17</option>
							<option value="18" <%if("18".equals(sec_hour)){%>selected="selected"<%}%>>18</option>
							<option value="19" <%if("19".equals(sec_hour)){%>selected="selected"<%}%>>19</option>
							<option value="20" <%if("20".equals(sec_hour)){%>selected="selected"<%}%>>20</option>
							<option value="21" <%if("21".equals(sec_hour)){%>selected="selected"<%}%>>21</option>
							<option value="22" <%if("22".equals(sec_hour)){%>selected="selected"<%}%>>22</option>
							<option value="23" <%if("23".equals(sec_hour)){%>selected="selected"<%}%>>23</option>
							<option value="a00"<%if("a00".equals(sec_hour)){%>selected="selected"<%}%>>+00</option>
							<option value="a01"<%if("a01".equals(sec_hour)){%>selected="selected"<%}%>>+01</option>
							<option value="a02"<%if("a02".equals(sec_hour)){%>selected="selected"<%}%>>+02</option>
						</select>
						<select name="sec_min" id="sec_min">
							<option value="00" <%if("00".equals(sec_min)){%>selected="selected"<%}%>>00</option>
							<option value="30" <%if("30".equals(sec_min)){%>selected="selected"<%}%>>30</option>
						</select>
					</td>
					<td style="BORDER-RIGHT: #000000 0px solid; BORDER-TOP: #000000 1px; PADDING-LEFT: 3px; FONT-WEIGHT: normal; FONT-SIZE: 12px; VERTICAL-ALIGN: middle; BORDER-LEFT: #000000 1px; COLOR: #000000; BORDER-BOTTOM: #000000 1px; FONT-STYLE: normal; FONT-FAMILY: 宋体; BACKGROUND-COLOR: #ffffff; TEXT-ALIGN: left; TEXT-DECORATION: none">排名: </td>
					<td>
						<select name='rnum'>
 <option value='5' <%if("5".equals(rnum)){%> selected='selected' <%}%>>前5位</option>
						    <option value='10' <%if("10".equals(rnum)){%> selected='selected' <%}%>>前10位</option>
							<option value='20' <%if("20".equals(rnum)){%> selected='selected' <%}%>>前20位</option>
						</select>
					</td>
					<td style="BORDER-RIGHT: #000000 0px solid; BORDER-TOP: #000000 1px; PADDING-LEFT: 3px; FONT-WEIGHT: normal; FONT-SIZE: 12px; VERTICAL-ALIGN: middle; BORDER-LEFT: #000000 1px; COLOR: #000000; BORDER-BOTTOM: #000000 1px; FONT-STYLE: normal; FONT-FAMILY: 宋体; BACKGROUND-COLOR: #ffffff; TEXT-ALIGN: left; TEXT-DECORATION: none">排名方式: </td>
					<td>
						<select name='pm'>
						    <option value='zl' <%if("zl".equals(pm)){%> selected='selected' <%}%>>按增量排序</option>
							<option value='zf' <%if("zf".equals(pm)){%> selected='selected' <%}%>>按增幅排序</option>
						   <option value='jl' <%if("jl".equals(pm)){%> selected='selected' <%}%>>按降量排序</option>
						   <option value='jf' <%if("jf".equals(pm)){%> selected='selected' <%}%>>按降幅排序</option>
						</select>
					</td>
				</tr>
			</table>
		</td>
		<td><input type=button value=表格 onclick="formsubmit();" style="FONT-SIZE: 13px; WIDTH: 40px; COLOR: mediumblue; FONT-FAMILY: 宋体; HEIGHT: 22px; BACKGROUND-COLOR: wheat"></td>
		<td><input type=button value=图表 onclick="showView();"  style="FONT-SIZE: 13px; WIDTH: 40px; COLOR: mediumblue; FONT-FAMILY: 宋体; HEIGHT: 22px; BACKGROUND-COLOR: wheat"></td>
	</table>
	<input type=hidden name=report_name value="<%=(String)request.getParameter("report_name")%>">
	<input type=hidden name=param_type value="<%=(String)request.getParameter("param_type")%>">
	<input type=hidden name=report_name_cn value="<%=(String)request.getAttribute("report_name_cn")%>">
	<input type="hidden" name="part" id="part">
</form>
<script type="text/javascript"> 
	$('.datecla').datepicker();
   	$('.datecla').datepicker('option', 'dateFormat', 'yymmdd');
	
	var start_date1="<%=start_date1%>"; 
	var start_date2="<%=start_date2%>"; 
	if(start_date1){
		$('#start_date1').datepicker('setDate', start_date1);
	}else{
		$('#start_date1').datepicker('setDate', new Date());
	}
	if(start_date2){
   		$('#start_date2').datepicker('setDate', start_date2);
   	}else{
   		$('#start_date2').datepicker('setDate', '-1d');
   	}
	
	var flag='<%=enter_flag%>';
    var flag_box=document.getElementsByName("enter_flag");
   	for(var i=0;i<flag_box.length;i++){
   		if(flag.toString().indexOf(flag_box[i].value)>-1){
   			flag_box[i].checked=true;
   		}else{
   			flag_box[i].checked=false;
   		}
   	}
   	
   	var fir_hour=document.getElementById("fir_hour");
	for(var i=0;i<fir_hour.options.length;i++){
	   if(fir_hour.options[i].value=="<%=fir_hour%>"){
	   	   fir_hour.options[i].selected=true;
	   	   break;
	   }
	}
	
	var fir_min=document.getElementById("fir_min");
	for(var i=0;i<fir_min.options.length;i++){
	   if(fir_min.options[i].value=="<%=fir_min%>"){
	   	   fir_min.options[i].selected=true;
	   	   break;
	   }
	}
	
	var sec_hour=document.getElementById("sec_hour");
	for(var i=0;i<sec_hour.options.length;i++){
	   if(sec_hour.options[i].value=="<%=sec_hour%>"){
	   	   sec_hour.options[i].selected=true;
	   	   break;
	   }
	}
	
	var sec_min=document.getElementById("sec_min");
	for(var i=0;i<sec_min.options.length;i++){
	   if(sec_min.options[i].value=="<%=sec_min%>"){
	   	   sec_min.options[i].selected=true;
	   	   break;
	   }
	}
	function formsubmit(){
	      var date1=document.getElementById("start_date1").value;
	      var date2=document.getElementById("start_date2").value;
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
	function showView(){
		form1.action="/qf_report_new/station_flow_compare.jsp";
 		form1.submit();
	}
</script>
<%if(enter_flags!=null){%>
<report:html name="station_add_part" reportFileName="station_add_part.raq"
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
	saveAsName="车站客流同比"
	useCache="no"
/>
<%}%>
</body>
</html>
