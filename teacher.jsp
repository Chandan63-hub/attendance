<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>

<%
    String message = "";
    String messageType = "";

    // ==========================================
    // START / CONDUCT CLASS
    // ==========================================

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String subject = request.getParameter("subject");

        if (subject != null &&
            !subject.trim().equals("")) {

            try {

                ABC db = new ABC();
                Connection con = db.getCon();

                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO class_sessions " +
                    "(subject, class_date) " +
                    "VALUES (?, CURDATE())",
                    Statement.RETURN_GENERATED_KEYS
                );

                ps.setString(1, subject);

                int result = ps.executeUpdate();

                if (result > 0) {

                    ResultSet keys = ps.getGeneratedKeys();

                    int sessionId = 0;

                    if (keys.next()) {
                        sessionId = keys.getInt(1);
                    }

                    keys.close();
                    ps.close();
                    con.close();

                    response.sendRedirect(
                        "qr.jsp?sessionId=" + sessionId
                    );

                    return;
                }

                ps.close();
                con.close();

            } catch (Exception e) {

                message = "Error: " + e.getMessage();
                messageType = "danger";
            }

        } else {

            message = "Please select a subject.";
            messageType = "danger";
        }
    }
%>


<!DOCTYPE html>

<html>

<head>

    <title>Teacher Dashboard | Smart Attendance</title>

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

            padding: 35px 15px;

        }


        /* =====================================
           MAIN CONTAINER
           ===================================== */

        .main-box {

            max-width: 1000px;

            margin: auto;

        }


        /* =====================================
           MAIN CARD
           ===================================== */

        .dashboard-card {

            background: rgba(255,255,255,0.97);

            border-radius: 22px;

            padding: 35px;

            box-shadow:
                0 20px 50px
                rgba(0,0,0,0.22);

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
           HEADER
           ===================================== */

        .dashboard-icon {

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

            font-size: 35px;

            box-shadow:
                0 8px 20px
                rgba(13,110,253,0.30);

        }


        .dashboard-title {

            font-size: 30px;

            font-weight: 700;

            text-align: center;

            color: #212529;

        }


        .dashboard-subtitle {

            text-align: center;

            color: #6c757d;

            margin-bottom: 30px;

        }


        /* =====================================
           SECTION TITLE
           ===================================== */

        .section-title {

            font-weight: 700;

            color: #212529;

            display: flex;

            align-items: center;

            gap: 8px;

        }


        /* =====================================
           START CLASS BOX
           ===================================== */

        .class-box {

            background: #f8f9fa;

            border: 1px solid #e9ecef;

            border-radius: 15px;

            padding: 22px;

        }


        .form-select {

            height: 50px;

            border-radius: 10px;

        }


        .form-select:focus {

            box-shadow:
                0 0 0 3px
                rgba(13,110,253,0.12);

            border-color: #0d6efd;

        }


        /* =====================================
           START BUTTON
           ===================================== */

        .start-btn {

            height: 50px;

            border: none;

            border-radius: 10px;

            font-weight: 600;

            background:
                linear-gradient(
                    135deg,
                    #198754,
                    #20c997
                );

            transition: 0.3s;

        }


        .start-btn:hover {

            transform: translateY(-2px);

            box-shadow:
                0 8px 18px
                rgba(25,135,84,0.25);

        }


        /* =====================================
           PENDING REQUEST
           ===================================== */

        .request-card {

            border: 1px solid #e9ecef;

            border-radius: 14px;

            padding: 18px;

            margin-bottom: 12px;

            background: white;

            transition: 0.25s;

        }


        .request-card:hover {

            transform: translateY(-2px);

            box-shadow:
                0 5px 15px
                rgba(0,0,0,0.08);

        }


        .student-name {

            font-weight: 700;

            color: #212529;

        }


        .student-info {

            line-height: 1.8;

        }


        /* =====================================
           ACCEPT / REJECT BUTTONS
           ===================================== */

        .action-btn {

            min-width: 90px;

            border-radius: 8px;

            font-weight: 600;

        }


        /* =====================================
           OTHER BUTTONS
           ===================================== */

        .dashboard-btn {

            height: 50px;

            border-radius: 10px;

            font-weight: 600;

            transition: 0.3s;

        }


        .dashboard-btn:hover {

            transform: translateY(-2px);

        }


        /* =====================================
           MESSAGE
           ===================================== */

        .alert {

            border-radius: 10px;

        }


        /* =====================================
           DIVIDER
           ===================================== */

        hr {

            opacity: 0.12;

        }


        /* =====================================
           MOBILE
           ===================================== */

        @media (max-width: 576px) {

            body {

                padding: 15px 10px;

            }


            .dashboard-card {

                padding: 22px 17px;

                border-radius: 18px;

            }


            .dashboard-title {

                font-size: 25px;

            }


            .request-card {

                padding: 15px;

            }

        }

    </style>

</head>


<body>


<div class="main-box">


    <div class="dashboard-card">


        <!-- ==================================
             DASHBOARD HEADER
             ================================== -->

        <div class="dashboard-icon">

            <i class="bi bi-person-workspace"></i>

        </div>


        <div class="dashboard-title">

            Teacher Dashboard

        </div>


        <div class="dashboard-subtitle">

            Smart Student Attendance System

        </div>



        <!-- ==================================
             MESSAGE
             ================================== -->

        <% if (!message.equals("")) { %>

            <div class="alert alert-<%= messageType %> text-center">

                <%= message %>

            </div>

        <% } %>



        <!-- ==================================
             START / CONDUCT CLASS
             ================================== -->

        <div class="class-box">


            <h4 class="section-title mb-3">

                <i class="bi bi-play-circle-fill text-success"></i>

                Start / Conduct Class

            </h4>


            <p class="text-muted">

                Select the subject to start today's class
                and generate the attendance QR code.

            </p>


            <form method="post"
                  action="teacher.jsp">


                <!-- SUBJECT -->

                <div class="mb-3">

                    <label class="form-label fw-semibold">

                        Select Subject

                    </label>


                    <select name="subject"
                            class="form-select"
                            required>


                        <option value="">

                            -- Select Subject --

                        </option>


                        <option value="CLOUD COMPUTING">

                            CLOUD COMPUTING

                        </option>


                        <option value="OOPS USING JAVA">

                            OOPS USING JAVA

                        </option>


                        <option value="SOFTWARE TESTING">

                            SOFTWARE TESTING

                        </option>


                        <option value="SYSTEM ADMINISTRATION">

                            SYSTEM ADMINISTRATION

                        </option>


                        <option value="INDIAN CONSTITUTION">

                            INDIAN CONSTITUTION

                        </option>


                    </select>

                </div>



                <!-- START BUTTON -->

                <button type="submit"
                        class="btn btn-success w-100 start-btn">

                    <i class="bi bi-qr-code"></i>

                    &nbsp; Start / Conduct Class

                </button>


            </form>

        </div>



        <hr class="my-4">



        <!-- ==================================
             PENDING ATTENDANCE REQUESTS
             ================================== -->

        <h4 class="section-title mb-3">

            <i class="bi bi-hourglass-split text-warning"></i>

            Pending Attendance Requests

        </h4>


        <%

            boolean hasPending = false;

            try {

                ABC pendingDb = new ABC();

                Connection pendingCon =
                    pendingDb.getCon();


                PreparedStatement psPending =
                    pendingCon.prepareStatement(

                        "SELECT a.id, " +
                        "s.roll_no, " +
                        "s.name, " +
                        "a.subject, " +
                        "a.attendance_time " +

                        "FROM attendance a " +

                        "INNER JOIN students s " +
                        "ON a.student_id = s.id " +

                        "WHERE a.status = 'PENDING' " +
                        "AND a.attendance_date = CURDATE() " +

                        "ORDER BY a.attendance_time ASC"

                    );


                ResultSet rsPending =
                    psPending.executeQuery();


                while (rsPending.next()) {

                    hasPending = true;

        %>


                    <div class="request-card">


                        <div class="row align-items-center">


                            <!-- STUDENT INFORMATION -->

                            <div class="col-md-7">


                                <h5 class="student-name mb-1">

                                    <i class="bi bi-person-circle"></i>

                                    <%= rsPending.getString("name") %>

                                </h5>


                                <div class="student-info text-muted">

                                    <small>

                                        <strong>
                                            Roll No:
                                        </strong>

                                        <%= rsPending.getInt("roll_no") %>

                                        <br>


                                        <strong>
                                            Subject:
                                        </strong>

                                        <%= rsPending.getString("subject") %>

                                        <br>


                                        <strong>
                                            Time:
                                        </strong>

                                        <%= rsPending.getTime("attendance_time") %>

                                    </small>

                                </div>

                            </div>



                            <!-- ACTION BUTTONS -->

                            <div class="col-md-5 text-md-end mt-3 mt-md-0">


                                <!-- ACCEPT -->

                                <form method="post"
                                      action="attendanceAction.jsp"
                                      style="display:inline;">


                                    <input type="hidden"
                                           name="attendanceId"
                                           value="<%= rsPending.getInt("id") %>">


                                    <input type="hidden"
                                           name="action"
                                           value="ACCEPT">


                                    <button type="submit"
                                            class="btn btn-success btn-sm action-btn me-1">

                                        <i class="bi bi-check-lg"></i>

                                        Accept

                                    </button>


                                </form>



                                <!-- REJECT -->

                                <form method="post"
                                      action="attendanceAction.jsp"
                                      style="display:inline;">


                                    <input type="hidden"
                                           name="attendanceId"
                                           value="<%= rsPending.getInt("id") %>">


                                    <input type="hidden"
                                           name="action"
                                           value="REJECT">


                                    <button type="submit"
                                            class="btn btn-danger btn-sm action-btn">

                                        <i class="bi bi-x-lg"></i>

                                        Reject

                                    </button>


                                </form>


                            </div>


                        </div>


                    </div>


        <%

                }


                if (!hasPending) {

        %>


                    <div class="alert alert-info text-center">

                        <i class="bi bi-info-circle-fill"></i>

                        No pending attendance requests.

                    </div>


        <%

                }


                rsPending.close();

                psPending.close();

                pendingCon.close();


            } catch (Exception e) {

        %>


                <div class="alert alert-danger">

                    <i class="bi bi-exclamation-triangle-fill"></i>

                    Error loading attendance requests:

                    <%= e.getMessage() %>

                </div>


        <%

            }

        %>



        <hr class="my-4">



        <!-- ==================================
             OTHER OPTIONS
             ================================== -->

        <h4 class="section-title mb-3">

            <i class="bi bi-grid-fill text-primary"></i>

            Attendance Management

        </h4>


        <div class="d-grid gap-3">


            <!-- HISTORY -->

            <a href="history.jsp"
               class="btn btn-primary dashboard-btn">

                <i class="bi bi-clock-history"></i>

                &nbsp; Attendance History

            </a>



            <!-- PERCENTAGE -->

            <a href="percentage.jsp"
               class="btn btn-info dashboard-btn">

                <i class="bi bi-bar-chart-fill"></i>

                &nbsp; Attendance Percentage

            </a>


        </div>


    </div>

</div>


</body>

</html>