﻿<%@ page contentType="text/html;charset=utf-8" language="java" import="java.util.*,java.lang.*,java.sql.*,java.text.*,java.io.*"  errorPage="" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/runqianReport4.tld" prefix="report" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String baseUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
%>

<html>
<% 
 
				String start_date1=request.getParameter("start_date1");
				String start_date2=request.getParameter("start_date2");
				String[] flags=request.getParameterValues("flag");
				String model_id=request.getParameter("model_id");
				String viewFlag=request.getParameter("viewFlag");
				String flag="";
				String urlString="";
				String paramsString="";	
				String addr_id="";	
                String fir_hour=request.getParameter("fir_hour");
				String fir_min=request.getParameter("fir_min");
			    String sec_hour=request.getParameter("sec_hour");
			    String sec_min=request.getParameter("sec_min");		  
			    String addr=request.getParameter("addr_id");
			    String selType=request.getParameter("selType");
				if(addr!=null){
				   addr_id=new String(addr.getBytes("iso-8859-1"),"utf-8");
				}
				java.sql.Connection con=null;
	 			java.sql.Statement st=null;
	 			java.sql.ResultSet rs=null;	
				
				if(flags!=null){
				   for(String tp:flags){	  
					 flag+=","+tp;
				   }
				}else{
					flag="1,3";
				}
              
	 			SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");  
				if(start_date2==null){
	  				start_date2=df.format(new java.util.Date()); 
      			}   
				Calendar calendar = Calendar.getInstance(); 
	 			if(start_date1==null){
        			calendar.setTime(new java.util.Date());
        			calendar.add(Calendar.DAY_OF_MONTH, -6);  
	    			start_date1=df.format(calendar.getTime());
                }  
				String com_date1=request.getParameter("com_date1");
				String com_date2=request.getParameter("com_date2");
				if(com_date1==null){
					calendar.setTime(new java.util.Date());
        			calendar.add(Calendar.DAY_OF_MONTH, -13);  
	    			com_date1=df.format(calendar.getTime());
				}
				if(com_date2==null){
					calendar.setTime(new java.util.Date());
        			calendar.add(Calendar.DAY_OF_MONTH, -7);  
	    			com_date2=df.format(calendar.getTime());
				}
                String today=df.format(new java.util.Date());

			    String start_time=request.getParameter("start_time");
			    String end_time=request.getParameter("end_time");
			    String cur_time="a0200";
			    
			    if("00".equals(fir_hour)||"24".equals(sec_hour)){                              
				    start_time="0200";
				    end_time="a0200";
				    if(Integer.parseInt(today)<=Integer.parseInt(start_date1)
					  ||Integer.parseInt(today)<=Integer.parseInt(start_date2)
					  ||Integer.parseInt(today)<=Integer.parseInt(com_date1)
					  ||Integer.parseInt(today)<=Integer.parseInt(com_date2)){
					     Calendar cal=Calendar.getInstance();
					     cal.add(Calendar.MINUTE,-30);
					     SimpleDateFormat sdf=new SimpleDateFormat("HHmm");
					     cur_time=sdf.format( cal.getTime());
				   }
			    }
                
			    String part=request.getParameter("part");
			    
			    urlString="station.jsp?start_date1="+start_date1+"&start_date2="+start_date2+"&selType="+selType+"&start_time="+start_time
			    		+"&end_time="+end_time+"&part="+part+"&cur_time="+cur_time;
                              
				paramsString="start_date1="+start_date1+";start_date2="+start_date2+";selType="+selType+";start_time="+start_time
						+";end_time="+end_time+";part="+part+";cur_time="+cur_time;
				
				if(flag!=null&&flag.length()>1){
					  urlString+="&flag="+flag.substring(1);
					  paramsString+=";flag="+flag.substring(1);	
			    }
			  
				if(addr_id!=null){
					  urlString+="&addr_id="+addr_id;
					  paramsString+=";addr_id="+addr_id;
		  	    }	
				if(model_id!=null){
					  urlString+="&model_id="+model_id;
					  paramsString+=";model_id="+model_id;
				}
				
				String date_flag=request.getParameter("date_flag");
				String avg_total=request.getParameter("avg_total");
				if(avg_total==null){
					avg_total="avg";
				}
				paramsString+=";com_date1="+com_date1+";com_date2="+com_date2+";date_flag="+date_flag+";avg_total="+avg_total+";cur_date="+today;
			 //out.println(paramsString+"<br>"+flag);
	 			request.setCharacterEncoding("utf-8");	
				
			try{

                Properties properties = new Properties(); 
	    		String paths = Thread.currentThread().getContextClassLoader().getResource("").toString();
	    		paths=paths.replace("classes/", "config.properties");
	    		paths=paths.replace("file:", "");
	    		InputStream inputStream = new FileInputStream(paths); 
	    		properties.load(inputStream); 
	    		inputStream.close();
				Class.forName(properties.getProperty("db.driver"));
    		 	con=DriverManager.getConnection(properties.getProperty("db.url"),properties.getProperty("db.user"),properties.getProperty("db.pass"));		  
		      	st=con.createStatement();
		      	String sqlStr="select distinct model_id, trim(model_name)  model_name,trim(sub_model_name) addr_name from TBL_METRO_MODEL_STATION  order by model_id ";		              			 
		      	rs=st.executeQuery(sqlStr);
		   
      		}catch(Exception e){ 
				e.printStackTrace();
		    }
	  
		%>

<script>
   var where=new Array(100);
   function construct(model_id,model_name,addr_name){
       this.model_id=model_id;
	   this.model_name=model_name;
	   this.addr_name=addr_name;
   }
 <%
	  int j=0;
	 while(rs.next()){
 %>
   where[<%=j++%>]=new construct("<%=rs.getString("model_id")%>","<%=rs.getString("model_name")%>","<%=rs.getString("addr_name")%>");
 <%}%>
	     var r=<%=j%>;
			 function aa(){	
			 	var m_id=where[0].model_id;
					for(var i=0;i<r;i++){
						if(m_id!=where[i].model_id||i==0){
							m_id=where[i].model_id;
							var m_name=where[i].model_name;	
							var optionObj = new Option(m_name,m_id); 
					 		document.getElementById("model_id").options.add(optionObj);
							}    			                			
						}
					
                                                                                 var sselect=document.getElementById("model_id");
                    				 for(var n=0;n<sselect.options.length;n++){			
			           			 if(sselect.options[n].value=='<%=model_id%>'){                                                                  		
			              				sselect.options[n].selected =true;
						}
				   
		           			  }
                             			change();
                      			var ssel=document.getElementById("addr_id");
                     			for(var n=0;n<ssel.options.length;n++){
			           		 if(ssel.options[n].value=='<%=addr_id%>'){
			              			ssel.options[n].selected =true;
						}
				   
		            			 }                                 
				}
            function change(){
				 var  myselect=document.getElementById("model_id");
				 var index=myselect.selectedIndex ;             
				 var select_id=myselect.options[index].value;
				 document.getElementById("addr_id").innerHTML="";
				 var obj = new Option("全部","全部"); 
				 	document.getElementById("addr_id").options.add(obj);
				for(var j=0;j<r;j++){
					if(where[j].model_id==select_id){
						var a_name=where[j].addr_name;				
						var optionObj = new Option(a_name,a_name); 
						document.getElementById("addr_id").options.add(optionObj);
					}				    			                			
				}

		  }
</script>

<head>
	<title>自定义车站客流</title>
	 <base href="<%=basePath%>">	
   <script src="resource/jquery/js/jquery-1.7.2.js" type="text/javascript" charset="UTF-8"></script>
    <script src="resource/jquery/js/jquery-ui-1.8.11.custom.min.js" type="text/javascript" charset="UTF-8"></script>
    <link href="resource/jquery/css/jquery-ui-1.8.11.custom.css" rel="stylesheet" type="text/css" charset="UTF-8"/>
    <script src="resource/jquery/js/jquery.ui.datepicker-zh-CN.js" type="text/javascript" charset="UTF-8"></script>
</head>
<body onload='aa();'>
<form  name="form1" action="<%=request.getContextPath()%>/param/station_pass_show_model.jsp"  id="form1">
   <table border="1px">
	 <tr>
		<td>
			查询日期：
				<input type=text name="start_date1" id="start_date1" style="width:80px;">-<input type=text name="start_date2" id="start_date2" style="width:80px;">
		 </td>
		 <td>
			对比日期：
				<input type=text name="com_date1" id="com_date1" style="width:80px;">-<input type=text name="com_date2" id="com_date2" style="width:80px;">
		 </td>
		  <td>
				模板：<select name="model_id" id="model_id" onchange="change();">  
					         
				</select>
				<input type="hidden" name="viewFlag" id="viewFlag">
		  </td>
		  <td>
				二级模板：<select name="addr_id"  id="addr_id" >  
					  <option value="全部">全部</option>
				</select>
		  </td>
		  <td>
				日期类型：<select name="date_flag"  id="date_flag" >  
					  <option value="">全部</option>
					  <option value="1">工作日</option>
					  <option value="2">双休日</option>
				</select>
		  </td>
      </tr>
	  <tr>
		   <td >开始时间点：
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
						<select name="fir_min" id="fir_min" onchange="setintervalf(this.value);">
							<option value="00">00</option>
							<option value="30">30</option>
						</select>
		 </td>
		 <td >结束时间点：
						<select name="sec_hour" id="sec_hour">
							<option value="24">全天</option>
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
						<select name="sec_min" id="sec_min" onchange="setintervals(this.value);">
							<option value="00">00</option>
							<option value="30">30</option>
						</select>
		</td>
	    <td>
                 <input type="checkbox" name="flag" value="1"  <%if(flag.indexOf('1')!=-1){%> checked="checked"<%}%>>进站</input>
				 <input type="checkbox" name="flag" value="2"  <%if(flag.indexOf('2')!=-1){%> checked="checked"<%}%>>出站</input>
				 <input type="checkbox" name="flag" value="3" <%if(flag.indexOf('3')!=-1){%> checked="checked"<%}%>>换乘</input> 
				 <select name="selType" id="selType" style="float:right;">
				 	<option value="60">一小时</option>
				 	<option value="30">半小时</option>
				 </select>
		</td>
		<td>
				值类型：<select name="avg_total"  id="avg_total" >  
					  <option value="avg">均值</option>
					  <option value="total">总和</option>
				</select>
		</td>
		<td>
          <input type="button" value="表格" onclick="reportshow();">    
          <input type="button" value="编辑模板" onclick='preadd();'>
          <input type="button" value="图表" onclick='viewshow();'>
        </td>
	</tr>
  </table>
       <input type="hidden" name="start_time"  id="start_time" >
	   <input type="hidden" name="end_time"  id="end_time">	
	   <input type="hidden" name="part" id="part">
</form>
	<div id="passwordId" align="center" style="z-index:2;display:none;background-color:#393939;width:100%;height:100%;position:fixed;filter:alpha(opacity:60);opacity:0.6;">
		<div style="width:300px;height:150px;border:1px solid #E3E3E3;background-color:#F5F5F5;margin-top:10px">
			<div style="font-weight: bolder;margin-top:15px;">输入编辑模板密码</div>
			<div style="font-size:14px;font-weight:normal;font-family:'Microsoft YaHei','微软雅黑','宋体';padding:20px">
				密码:<input type="password" id="passwordVal" style="width:170px;"/>
			</div>
			<div>
				<input type="button" value="关闭" onclick="closediv()"/>&nbsp;&nbsp;
				<input type="button" value="确定" onclick="add()"/>
			</div>
		</div>
		<script type="text/javascript">
			var start_date1="<%=start_date1%>";
			var start_date2="<%=start_date2%>";
			var com_date1="<%=com_date1%>";
			var com_date2="<%=com_date2%>";
			$('#start_date1,#start_date2,#com_date1,#com_date2').datepicker();
   			$('#start_date1,#start_date2,#com_date1,#com_date2').datepicker('option', 'dateFormat', 'yymmdd');
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
			$('#com_date1').datepicker('setDate', com_date1);
			$('#com_date2').datepicker('setDate', com_date2);
			
			$("#date_flag").val("<%=date_flag%>");
			$("#fir_hour").val("<%=fir_hour%>");
			$("#fir_min").val("<%=fir_min%>");
			$("#sec_hour").val("<%=sec_hour%>");
			$("#sec_min").val("<%=sec_min%>");
			$("#selType").val("<%=selType%>");
			$("#avg_total").val("<%=avg_total%>");

			function setintervalf(v){
				$("#selType").val(v);
			}
			function setintervals(v){
				$("#selType").val(v);
			}
			function preadd(){
		  	 	document.getElementById("passwordId").style.display="";
		  	}
			function closediv(){
				document.getElementById("passwordId").style.display="none";
			}
			function add(){
				var temp=document.getElementById("passwordVal").value;
				var date=new Date();
				var mm=date.getMonth()+1;
				var dd=date.getDate();
				if(mm<10){mm="0"+mm;}
				if(dd<10){dd="0"+dd;}
				if("metro"+date.getFullYear()+mm+dd==temp){
					document.getElementById("passwordId").style.display="none";
					document.form1.action="<%=baseUrl%>/qf_report_view/pages/module/add_model.jsp";
		  	  		document.form1.submit();
				}else{
					alert("密码输入错误，请重新输入！");
				}
		  	}
			function viewshow(){
				document.form1.action="/qf_report_new/station_flow_model_new.jsp";
		  	  	document.form1.submit();
			}
			function reportshow(){
				 var fir_hour=document.getElementById("fir_hour").value;
				 var fir_min=document.getElementById("fir_min").value;
				 var start_time=fir_hour+fir_min;
				 var sec_hour=document.getElementById("sec_hour").value;
				 var sec_min=document.getElementById("sec_min").value;
				 var end_time=sec_hour+sec_min;
				 document.getElementById("start_time").value=start_time;
				 document.getElementById("end_time").value=end_time;
				 if(start_time>end_time){
				 alert("结束时间点不能早于开始时间点");
				 return;
				 }
				 var date1=document.getElementById("start_date1").value;
	             var date2=document.getElementById("start_date2").value;
	             var d1=new Date(date1.substr(0,4),date1.substr(4,2),date1.substr(6,2));
	             var d2=new Date(date2.substr(0,4),date2.substr(4,2),date2.substr(6,2));
		         var gap=(d1-d2)/(24*60*60*1000);
	             if(gap>60){
	                document.getElementById("part").value="0";  
	             }else{
				    document.getElementById("part").value="1"; 
				 }
				document.getElementById("viewFlag").value="1";
				document.form1.submit();
			}
		</script>
	</div>

<%if(flags!=null&&"1".equals(viewFlag)){%>
<report:html name="station_pass_show_part" reportFileName="model_flux.raq"
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
	saveAsName="自定义车站客流"
	useCache="no"
/>
<%}%>

<%
	     if(rs != null){   // 关闭记录集    
        try{    
				rs.close() ;    
			}catch(Exception e){    
				e.printStackTrace() ;    
			}    
          }    
    if(st != null){   // 关闭声明    
        try{    
				st.close() ;    
			}catch(Exception e){    
				e.printStackTrace() ;    
			}    
        }    
          if(con != null){  // 关闭连接对象    
         try{    
				con.close() ;    
			}catch(Exception e){    
				e.printStackTrace() ;    
			}    
       }  
%>
</body>
</html>