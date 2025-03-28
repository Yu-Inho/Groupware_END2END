<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="login.css">
  <title>Login</title>
</head>

<body>
<form action="/member/login" method="post">
  <div class="container">
    <div class="header">
      <img src="로그인로고.PNG">
    </div>
    <div class="body">
      <input type="text" name="id" id="id" placeholder="사번 입력"><br>
      <input type="password" name="pw" id="pw" placeholder="패스워드 입력"><br>
      <input type="checkbox" id="check"> 사번 저장하기<br>
      <button id="loginBtn">Login</button>
    </div>
  </div>
</form>
</body>
</html>
