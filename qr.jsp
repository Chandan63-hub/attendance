<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>

<!DOCTYPE html>
<html>

<head>

    <title>Attendance QR | Smart Attendance</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1">


    <!-- Bootstrap -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css"
          rel="stylesheet">


    <!-- Bootstrap Icons -->

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <!-- QR Code Library -->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>


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

            padding: 35px 15px;

            display: flex;

            align-items: center;

            justify-content: center;

        }


        /* =====================================
           MAIN CONTAINER
           ===================================== */

        .main-container {

            width: 100%;

            max-width: 650px;

        }


        /* =====================================
           MAIN CARD
           ===================================== */

        .qr-card {

            background: rgba(255,255,255,0.97);

            border-radius: 24px;

            padding: 35px;

            text-align: center;

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
           HEADER ICON
           ===================================== */

        .qr-icon {

            width: 75px;

            height: 75px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            margin: 0 auto 15px;

            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

            color: white;

            font-size: 34px;

            box-shadow:
                0 8px 20px
                rgba(13,110,253,0.30);

        }


        /* =====================================
           TITLE
           ===================================== */

        .page-title {

            font-size: 30px;

            font-weight: 700;

            color: #212529;

            margin-bottom: 8px;

        }


        .subtitle {

            color: #6c757d;

            margin-bottom: 25px;

        }


        /* =====================================
           SESSION INFORMATION
           ===================================== */

        .session-box {

            background: #f8f9fa;

            border: 1px solid #e9ecef;

            border-radius: 15px;

            padding: 20px;

            margin-bottom: 25px;

        }


        .subject-name {

            font-size: 22px;

            font-weight: 700;

            color: #0d6efd;

            margin-bottom: 15px;

        }


        .info-item {

            display: inline-block;

            margin: 5px 8px;

            padding: 8px 13px;

            background: white;

            border-radius: 8px;

            border: 1px solid #e9ecef;

            color: #495057;

            font-size: 14px;

        }


        .info-item i {

            color: #0d6efd;

        }


        /* =====================================
           QR AREA
           ===================================== */

        .qr-section {

            background: white;

            border: 2px dashed #dee2e6;

            border-radius: 18px;

            padding: 25px;

            margin-bottom: 20px;

        }


        .qr-heading {

            font-weight: 700;

            color: #212529;

            margin-bottom: 18px;

        }


        #qrcode {

            width: 220px;

            min-height: 220px;

            margin: auto;

            display: flex;

            align-items: center;

            justify-content: center;

            padding: 10px;

            background: white;

            border-radius: 10px;

        }


        #qrcode img {

            max-width: 100%;

            height: auto;

        }


        .scan-text {

            margin-top: 18px;

            margin-bottom: 0;

            color: #6c757d;

            font-size: 14px;

        }


        .scan-text i {

            color: #198754;

        }


        /* =====================================
           QR LINK
           ===================================== */

        .url-box {

            background: #f8f9fa;

            border: 1px solid #e9ecef;

            border-radius: 12px;

            padding: 12px 15px;

            margin-top: 20px;

            text-align: left;

        }


        .url-title {

            font-size: 13px;

            font-weight: 700;

            color: #495057;

            margin-bottom: 5px;

        }


        .url {

            font-size: 12px;

            color: #6c757d;

            word-break: break-all;

            line-height: 1.5;

        }


        /* =====================================
           BACK BUTTON
           ===================================== */

        .back-btn {

            height: 50px;

            border: none;

            border-radius: 10px;

            font-weight: 600;

            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

            transition: 0.3s;

        }


        .back-btn:hover {

            transform: translateY(-2px);

            box-shadow:
                0 8px 18px
                rgba(13,110,253,0.25);

        }


        /* =====================================
           ERROR / INVALID SESSION
           ===================================== */

        .error-icon {

            width: 70px;

            height: 70px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            margin: 0 auto 15px;

            background: #f8d7da;

            color: #dc3545;

            font-size: 30px;

        }


        .error-title {

            font-weight: 700;

            color: #212529;

        }


        /* =====================================
           MOBILE
           ===================================== */

        @media (max-width: 576px) {

            body {

                padding: 15px 10px;

            }


            .qr-card {

                padding: 25px 17px;

                border-radius: 20px;

            }


            .page-title {

                font-size: 25px;

            }


            .subject-name {

                font-size: 19px;

            }


            .qr-section {

                padding: 18px 10px;

            }


            #qrcode {

                width: 210px;

                min-height: 210px;

            }

        }

    </style>

</head>


<body>


<div class="main-container">


    <div class="qr-card">


<%

    String sessionIdText =
        request.getParameter("sessionId");


    if (sessionIdText == null ||
        sessionIdText.trim().equals("")) {

%>


        <!-- ==================================
             INVALID SESSION
             ================================== -->

        <div class="error-icon">

            <i class="bi bi-exclamation-triangle-fill"></i>

        </div>


        <h2 class="error-title">

            Invalid Session

        </h2>


        <p class="text-muted">

            No Session ID was provided.

        </p>


<%

    } else {

        try {

            int sessionId =
                Integer.parseInt(sessionIdText);


            ABC db = new ABC();

            Connection con =
                db.getCon();


            String sql =
                "SELECT id, subject, class_date " +
                "FROM class_sessions " +
                "WHERE id = ?";


            PreparedStatement ps =
                con.prepareStatement(sql);


            ps.setInt(1, sessionId);


            ResultSet rs =
                ps.executeQuery();


            if (rs.next()) {


                String subject =
                    rs.getString("subject");


                String classDate =
                    rs.getString("class_date");


                /*
                 * HTTPS Cloudflare Tunnel URL
                 */

                String publicUrl =
                    "  https://gratuit-meet-homeland-organ.trycloudflare.com";


                String contextPath =
                    request.getContextPath();


                /*
                 * FINAL QR LINK
                 */

                String qrData =
                    publicUrl
                    + contextPath
                    + "/attendance.jsp?sessionId="
                    + sessionId;

%>


        <!-- ==================================
             HEADER
             ================================== -->

        <div class="qr-icon">

            <i class="bi bi-qr-code"></i>

        </div>


        <div class="page-title">

            Attendance QR Code

        </div>


        <div class="subtitle">

            Scan the QR code to mark attendance

        </div>


        <!-- ==================================
             SESSION INFORMATION
             ================================== -->

        <div class="session-box">


            <div class="subject-name">

                <i class="bi bi-book-fill"></i>

                <%= subject %>

            </div>


            <span class="info-item">

                <i class="bi bi-hash"></i>

                Session ID:

                <strong>

                    <%= sessionId %>

                </strong>

            </span>


            <span class="info-item">

                <i class="bi bi-calendar-event"></i>

                Date:

                <strong>

                    <%= classDate %>

                </strong>

            </span>


        </div>


        <!-- ==================================
             QR CODE
             ================================== -->

        <div class="qr-section">


            <div class="qr-heading">

                <i class="bi bi-phone"></i>

                Scan this QR Code

            </div>


            <div id="qrcode"></div>


            <p class="scan-text">

                <i class="bi bi-check-circle-fill"></i>

                Students can scan this QR code
                using their phone.

            </p>


        </div>


        <!-- ==================================
             QR LINK
             ================================== -->

        <div class="url-box">


            <div class="url-title">

                <i class="bi bi-link-45deg"></i>

                QR Link

            </div>


            <div class="url">

                <%= qrData %>

            </div>


        </div>


        <script>

            var qrLink =
                "<%= qrData %>";


            new QRCode(

                document.getElementById("qrcode"),

                {

                    text: qrLink,

                    width: 200,

                    height: 200

                }

            );

        </script>


<%

            } else {

%>


        <!-- ==================================
             SESSION NOT FOUND
             ================================== -->

        <div class="error-icon">

            <i class="bi bi-search"></i>

        </div>


        <h2 class="error-title">

            Session Not Found

        </h2>


        <p class="text-muted">

            The requested attendance session
            could not be found.

        </p>


<%

            }


            rs.close();

            ps.close();

            con.close();


        } catch (Exception e) {

%>


        <!-- ==================================
             ERROR
             ================================== -->

        <div class="error-icon">

            <i class="bi bi-exclamation-triangle-fill"></i>

        </div>


        <h2 class="error-title">

            Error

        </h2>


        <p class="text-danger">

            <%= e.getMessage() %>

        </p>


<%

        }

    }

%>


        <!-- ==================================
             BACK BUTTON
             ================================== -->

        <a href="teacher.jsp"
           class="btn btn-primary w-100 back-btn mt-4">

            <i class="bi bi-arrow-left"></i>

            &nbsp; Back to Teacher Dashboard

        </a>


    </div>

</div>


</body>

</html>