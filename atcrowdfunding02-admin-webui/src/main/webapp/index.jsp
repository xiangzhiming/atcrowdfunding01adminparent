<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}/">
    <script type="text/javascript" src="Jquery/jquery-2.1.1.min.js"></script>
<%--
    <script type="text/javascript" src="layer/layer.js"></script>
--%>
  </head>

  <script type="text/javascript">
    $(function() {
      $("#btn1").click(function () {
          $.ajax({
            "url": "send/array/onw.html",       //请求目标资源的地址
            "type": "post",                 //请求方式
            "data": {                       //要发送的请求参数
              "array": [5,8,12]
            },
            "dataType": "text",             //如何对待服务器返回的数据
            "success": function (response) {  //服务器端成功处理请求后的回调函数
              alert(response)
            },
            "error": function (response) {    //服务器端处理请求失败后调用的回调函数
              alert(response)
            }
          })
      });
    })
    $(function() {
      $("#btn2").click(function () {
        $.ajax({
          "url": "send/array/two.html",       //请求目标资源的地址
          "type": "post",                 //请求方式
          "data": {                       //要发送的请求参数
            "array[0]": 5,
            "array[1]": 8,
            "array[2]": 12,
          },
          "dataType": "text",             //如何对待服务器返回的数据
          "success": function (response) {  //服务器端成功处理请求后的回调函数
            alert(response)
          },
          "error": function (response) {    //服务器端处理请求失败后调用的回调函数
            alert(response)
          }
        })
      });
    })
    $(function() {
      $("#btn3").click(function () {
        //装备好要发送到服务器的json数组
        var array = [5,8,12];
        console.log(array)
        console.log(array.length)

        //将json数组转换成json字符串
        var requestBody = JSON.stringify(array);
        console.log(requestBody)
        console.log(requestBody.length)

        $.ajax({
          url: "send/array/three.html",       //请求目标资源的地址
          type: "post",                 //请求方式
          data: requestBody,                      //要发送的请求参数
          contentType: "application/json;charset=UTF-8",   //设置请求体的内容类型，告诉服务器端本次请求的请求体是JSON数据
          dataType: "text",             //如何对待服务器返回的数据
          succes: function (response) {  //服务器端成功处理请求后的回调函数
            alert(response)
          },
          error: function (response) {    //服务器端处理请求失败后调用的回调函数
            alert(response)
          }
        })
      });
    })
    $(function() {
      $("#btn4").click(function () {
        //准备好要发送到服务器的json数组
        var student={
          stuId: 5,
          stuName: "tom",
          address: {
            province: "四川省",
            city: "广元市",
            street: "苍溪县",
          },
          subjectList: [
            {
              subjectName: "JavaSE",
              subjectScore: "100"
            },{
              subjectName: "SSM",
              subjectScore: "100"
            }
          ],
          map: {
            k1: "v1",
            k2: "v2"
          }
        }
        console.log(student);
        //将json对象转换成json字符串
        var requestBody = JSON.stringify(student)
        console.log(requestBody)
        //发送Ajax请求
        $.ajax({
          url: "/send/compose/object.json",
          type: "post",
          data: requestBody,
          contentType: "application/json;charset=UTF-8",
          dataType: "json",
          success: function (response) {
            alert(response);
            console.log(response)
          },
          error: function (response) {
            alert(response)
            console.log(response);

          }
        })
      });
      /*$("#btn5").click(function () {
        alert("a")
        layer.msg("layer的弹框")
      })*/
    })
  </script>
  <body>
  <a href="test/ssm.html">点我完成跳转</a>
  <br/>
  <button id="btn1">Send One[5,8,12]</button>
  <br/>
  <button id="btn2">Send Two [5,8,12]</button>
  <br/>
  <button id="btn3">Send Three [5,8,12]</button>
  <br/>
  <button id="btn4">Send Three [5,8,12]</button>
  <br/>
  <button id="btn5">点我弹框</button>


  <%response.sendRedirect(request.getContextPath()+"/admin/to/login/page.html"); %>
  </body>
</html>
