<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>

<%
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {

            ABC db = new ABC();
            Connection con = db.getCon();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM teachers " +
                "WHERE username = ? AND password = ?"
            );

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                session.setAttribute("teacherLoggedIn", true);

                session.setAttribute(
                    "teacherUsername",
                    rs.getString("username")
                );

                rs.close();
                ps.close();
                con.close();

                response.sendRedirect("teacher.jsp");
                return;

            } else {

                message = "Invalid Username or Password";

            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            message = "Database Error: " + e.getMessage();

        }
    }
%>


<!DOCTYPE html>

<html>

<head>

    <title>Teacher Login | Smart Attendance</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1">


    <!-- Bootstrap -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css"
          rel="stylesheet">


    <!-- Bootstrap Icons -->

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <style>

        * {
            box-sizing: border-box;
        }


        body {

            margin: 0;

            min-height: 100vh;

            font-family: Arial, sans-serif;

            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

            display: flex;

            align-items: center;

            justify-content: center;

            padding: 20px;

        }


        /* =====================================
           LOGIN CARD
           ===================================== */

        .login-card {

            width: 100%;

            max-width: 430px;

            background: rgba(255,255,255,0.97);

            border-radius: 22px;

            padding: 40px;

            box-shadow:
                0 20px 50px
                rgba(0,0,0,0.25);

            animation: appear 0.6s ease;

        }


        @keyframes appear {

            from {

                opacity: 0;

                transform: translateY(25px);

            }

            to {

                opacity: 1;

                transform: translateY(0);

            }

        }


        /* =====================================
           ICON
           ===================================== */

        .login-icon {

            width: 85px;

            height: 85px;

            border-radius: 50%;

            margin: 0 auto 20px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

            color: white;

            font-size: 40px;

            box-shadow:
                0 8px 20px
                rgba(13,110,253,0.35);

        }


        /* =====================================
           TITLE
           ===================================== */

        .login-title {

            font-size: 28px;

            font-weight: 700;

            color: #212529;

            margin-bottom: 5px;

        }


        .subtitle {

            color: #6c757d;

            font-size: 14px;

            margin-bottom: 30px;

        }


        /* =====================================
           INPUT
           ===================================== */

        .input-group-text {

            background: white;

            border-right: none;

            color: #0d6efd;

        }


        .input-group .form-control {

            border-left: none;

        }


        .input-group .form-control:focus {

            box-shadow: none;

            border-color: #dee2e6;

        }


        .input-group:focus-within {

            box-shadow:
                0 0 0 3px
                rgba(13,110,253,0.12);

            border-radius: 8px;

        }


        .form-control {

            height: 50px;

        }


        /* =====================================
           LOGIN BUTTON
           ===================================== */

        .login-btn {

            height: 52px;

            border: none;

            border-radius: 10px;

            font-size: 16px;

            font-weight: 600;

            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

            transition: 0.3s;

        }


        .login-btn:hover {

            transform: translateY(-2px);

            box-shadow:
                0 8px 20px
                rgba(13,110,253,0.30);

        }


        /* =====================================
           ERROR
           ===================================== */

        .error-box {

            border-radius: 10px;

            font-size: 14px;

        }


        /* =====================================
           FOOTER
           ===================================== */

        .footer {

            margin-top: 25px;

            text-align: center;

            font-size: 13px;

            color: #6c757d;

        }


        .secure {

            display: inline-flex;

            align-items: center;

            gap: 5px;

            color: #198754;

            font-weight: 500;

        }


        /* =====================================
           MOBILE
           ===================================== */

        @media (max-width: 480px) {

            .login-card {

                padding: 30px 22px;

            }


            .login-title {

                font-size: 24px;

            }

        }

    </style>

</head>


<body>


<!-- ==========================================
     LOGIN CARD
     ========================================== -->

<div class="login-card">


    <!-- ICON -->

    <div class="login-icon">

        <i class="bi bi-person-badge-fill"></i>

    </div>


    <!-- TITLE -->

    <div class="text-center">

        <div class="login-title">

            Teacher Login

        </div>


        <div class="subtitle">

            Smart Student Attendance System

        </div>

    </div>



    <!-- ======================================
         ERROR MESSAGE
         ====================================== -->

    <% if (!message.equals("")) { %>

        <div class="alert alert-danger error-box text-center">

            <i class="bi bi-exclamation-triangle-fill"></i>

            <%= message %>

        </div>

    <% } %>



    <!-- ======================================
         LOGIN FORM
         ====================================== -->

    <form method="post"
          action="loginTeachers.jsp">


        <!-- USERNAME -->

        <div class="mb-3">

            <label class="form-label fw-semibold">

                Username

            </label>


            <div class="input-group">

                <span class="input-group-text">

                    <i class="bi bi-person-fill"></i>

                </span>


                <input type="text"
                       name="username"
                       class="form-control"
                       placeholder="Enter your username"
                       required>

            </div>

        </div>



        <!-- PASSWORD -->

        <div class="mb-4">

            <label class="form-label fw-semibold">

                Password

            </label>


            <div class="input-group">

                <span class="input-group-text">

                    <i class="bi bi-lock-fill"></i>

                </span>


                <input type="password"
                       name="password"
                       id="password"
                       class="form-control"
                       placeholder="Enter your password"
                       required>


                <button type="button"
                        class="btn btn-outline-secondary"
                        onclick="togglePassword()">

                    <i class="bi bi-eye"
                       id="eyeIcon"></i>

                </button>

            </div>

        </div>



        <!-- LOGIN BUTTON -->

        <button type="submit"
                class="btn btn-primary w-100 login-btn">

            <i class="bi bi-box-arrow-in-right"></i>

            &nbsp; Login as Teacher

        </button>


    </form>



    <!-- ======================================
         FOOTER
         ====================================== -->

    <div class="footer">

        <div class="secure">

            <i class="bi bi-shield-check"></i>

            Secure Teacher Access

        </div>


        <div class="mt-2">

            Smart Student Attendance System

        </div>

    </div>


</div>



<!-- ==========================================
     SHOW / HIDE PASSWORD
     ========================================== -->

<script>

function togglePassword() {

    var password =
        document.getElementById("password");

    var eyeIcon =
        document.getElementById("eyeIcon");


    if (password.type === "password") {

        password.type = "text";

        eyeIcon.className =
            "bi bi-eye-slash";

    } else {

        password.type = "password";

        eyeIcon.className =
            "bi bi-eye";

    }

}

</script>


</body>

</html>