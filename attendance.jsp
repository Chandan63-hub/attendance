<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%

    String message = "";
    String messageType = "";

    int attendanceId = 0;
    String attendanceStatus = "";

    String sessionIdParam =
        request.getParameter("sessionId");

    int sessionId = 0;


    // ==========================================
    // CHECK SESSION ID
    // ==========================================

    if (sessionIdParam == null ||
        sessionIdParam.trim().equals("")) {

        message = "Invalid session.";
        messageType = "danger";

    } else {

        try {

            sessionId =
                Integer.parseInt(sessionIdParam);

        } catch (Exception e) {

            message = "Invalid session ID.";
            messageType = "danger";

        }

    }


    // ==========================================
    // SESSION INFORMATION
    // ==========================================

    String subject = "";
    String classDate = "";


    if (sessionId > 0) {

        try {

            ABC db = new ABC();

            Connection con =
                db.getCon();

            PreparedStatement ps =
                con.prepareStatement(
                    "SELECT subject, class_date " +
                    "FROM class_sessions " +
                    "WHERE id=?"
                );

            ps.setInt(
                1,
                sessionId
            );

            ResultSet rs =
                ps.executeQuery();


            if (rs.next()) {

                subject =
                    rs.getString("subject");

                classDate =
                    rs.getString("class_date");

            } else {

                message =
                    "Class session not found.";

                messageType =
                    "danger";

            }


            rs.close();
            ps.close();
            con.close();


        } catch (Exception e) {

            message =
                "Error loading class: "
                + e.getMessage();

            messageType =
                "danger";

        }

    }


    // ==========================================
    // STUDENT SUBMIT
    // ==========================================

    if ("POST".equalsIgnoreCase(
            request.getMethod())) {


        String studentName =
            request.getParameter(
                "studentName"
            );


        if (studentName == null ||
            studentName.trim().equals("")) {

            message =
                "Please enter your name.";

            messageType =
                "danger";

        } else if (sessionId <= 0 ||
                   subject.equals("")) {

            message =
                "Invalid class session.";

            messageType =
                "danger";

        } else {


            try {

                ABC db = new ABC();

                Connection con =
                    db.getCon();


                // ==================================
                // FIND STUDENT
                // ==================================

                PreparedStatement psStudent =
                    con.prepareStatement(

                        "SELECT id " +
                        "FROM students " +
                        "WHERE LOWER(name)=LOWER(?)"

                    );


                psStudent.setString(
                    1,
                    studentName.trim()
                );


                ResultSet rsStudent =
                    psStudent.executeQuery();


                if (!rsStudent.next()) {

                    message =
                        "Student name not found.";

                    messageType =
                        "danger";

                } else {


                    int studentId =
                        rsStudent.getInt("id");


                    // ==================================
                    // CHECK EXISTING ATTENDANCE
                    // ==================================

                    PreparedStatement psDuplicate =
                        con.prepareStatement(

                            "SELECT id, status " +
                            "FROM attendance " +
                            "WHERE student_id=? " +
                            "AND session_id=?"

                        );


                    psDuplicate.setInt(
                        1,
                        studentId
                    );

                    psDuplicate.setInt(
                        2,
                        sessionId
                    );


                    ResultSet rsDuplicate =
                        psDuplicate.executeQuery();


                    if (rsDuplicate.next()) {


                        attendanceId =
                            rsDuplicate.getInt(
                                "id"
                            );


                        attendanceStatus =
                            rsDuplicate.getString(
                                "status"
                            );


                        if ("ACCEPTED".equalsIgnoreCase(
                                attendanceStatus)) {

                            message =
                                "Attendance already accepted.";

                            messageType =
                                "success";

                        }

                        else if ("PENDING".equalsIgnoreCase(
                                attendanceStatus)) {

                            message =
                                "Request already sent. " +
                                "Waiting for teacher approval.";

                            messageType =
                                "warning";

                        }

                        else {

                            message =
                                "Attendance request was rejected.";

                            messageType =
                                "danger";

                        }


                    } else {


                        // ==================================
                        // INSERT PENDING REQUEST
                        // ==================================

                        PreparedStatement psInsert =
                            con.prepareStatement(

                                "INSERT INTO attendance " +
                                "(student_id, attendance_date, " +
                                "attendance_time, subject, " +
                                "session_id, status) " +

                                "VALUES (?, CURDATE(), " +
                                "CURTIME(), ?, ?, 'PENDING')",

                                Statement.RETURN_GENERATED_KEYS

                            );


                        psInsert.setInt(
                            1,
                            studentId
                        );


                        psInsert.setString(
                            2,
                            subject
                        );


                        psInsert.setInt(
                            3,
                            sessionId
                        );


                        psInsert.executeUpdate();


                        ResultSet generatedKeys =
                            psInsert.getGeneratedKeys();


                        if (generatedKeys.next()) {

                            attendanceId =
                                generatedKeys.getInt(1);

                        }


                        generatedKeys.close();
                        psInsert.close();


                        attendanceStatus =
                            "PENDING";


                        message =
                            "Request sent successfully! " +
                            "Waiting for teacher approval.";

                        messageType =
                            "warning";

                    }


                    rsDuplicate.close();
                    psDuplicate.close();

                }


                rsStudent.close();
                psStudent.close();

                con.close();


            } catch (Exception e) {

                message =
                    "Error: "
                    + e.getMessage();

                messageType =
                    "danger";

            }

        }

    }

%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Student Attendance</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1">


    <!-- Bootstrap 5.3.7 -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Bootstrap Icons -->

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">


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

            padding: 25px 15px;

        }


        .attendance-card {

            width: 100%;

            max-width: 520px;

            background: white;

            border-radius: 25px;

            padding: 35px;

            box-shadow:
                0 20px 50px
                rgba(0,0,0,0.25);

        }


        /* =================================
           HEADER ICON
           ================================= */

        .attendance-icon {

            width: 75px;

            height: 75px;

            margin: 0 auto 18px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            color: white;

            font-size: 35px;

            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

        }


        .title {

            text-align: center;

            font-weight: bold;

            color: #222;

            margin-bottom: 8px;

        }


        .subtitle {

            text-align: center;

            color: #777;

            margin-bottom: 25px;

        }


        /* =================================
           CLASS INFORMATION
           ================================= */

        .class-info {

            background: #f4f6ff;

            border-radius: 18px;

            padding: 18px;

            margin-bottom: 25px;

            text-align: center;

        }


        .class-info .subject {

            font-size: 20px;

            font-weight: bold;

            color: #6610f2;

            margin-bottom: 8px;

        }


        .class-info .date {

            color: #555;

            margin: 0;

        }


        /* =================================
           FORM
           ================================= */

        .form-label {

            font-weight: 600;

            color: #333;

        }


        .form-control {

            border-radius: 12px;

            padding: 12px 14px;

            border: 1px solid #ddd;

        }


        .form-control:focus {

            border-color: #6610f2;

            box-shadow:
                0 0 0 0.2rem
                rgba(102,16,242,0.15);

        }


        /* =================================
           SUBMIT BUTTON
           ================================= */

        .submit-btn {

            border: none;

            border-radius: 12px;

            padding: 13px;

            font-size: 16px;

            font-weight: bold;

            color: white;

            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

            transition: 0.2s;

        }


        .submit-btn:hover {

            color: white;

            transform: translateY(-2px);

            box-shadow:
                0 8px 20px
                rgba(13,110,253,0.30);

        }


        /* =================================
           STATUS ALERT
           ================================= */

        .status-alert {

            border-radius: 12px;

            font-weight: 600;

        }


        /* =================================
           WAITING BOX
           ================================= */

        .waiting-info {

            text-align: center;

            margin-top: 18px;

            padding: 15px;

            background: #fff8e1;

            border-radius: 12px;

            color: #856404;

            font-size: 14px;

        }


        /* =================================
           FOOTER
           ================================= */

        .secure-text {

            text-align: center;

            margin-top: 25px;

            color: #999;

            font-size: 13px;

        }


        /* =================================
           MOBILE
           ================================= */

        @media(max-width: 500px) {

            body {

                padding: 15px;

            }

            .attendance-card {

                padding: 25px 20px;

                border-radius: 20px;

            }

            .attendance-icon {

                width: 65px;

                height: 65px;

                font-size: 30px;

            }

            .title {

                font-size: 24px;

            }

        }

    </style>

</head>


<body>


<div class="attendance-card">


    <!-- =================================
         ICON
         ================================= -->

    <div class="attendance-icon">

        <i class="bi bi-person-check-fill"></i>

    </div>


    <!-- =================================
         TITLE
         ================================= -->

    <h2 class="title">

        Student Attendance

    </h2>


    <p class="subtitle">

        Mark your attendance for the current class

    </p>


    <!-- =================================
         CLASS INFORMATION
         ================================= -->

    <div class="class-info">

        <div class="subject">

            <i class="bi bi-book-fill"></i>

            <%= subject %>

        </div>


        <p class="date">

            <i class="bi bi-calendar3"></i>

            <strong>Date:</strong>

            <%= classDate %>

        </p>

    </div>


    <!-- =================================
         MESSAGE
         ================================= -->

    <% if (!message.equals("")) { %>


        <div
            id="statusBox"
            class="alert alert-<%= messageType %> status-alert text-center">

            <%= message %>

        </div>


    <% } else { %>


        <div
            id="statusBox"
            class="alert status-alert text-center"
            style="display:none;">

        </div>


    <% } %>


    <!-- =================================
         ATTENDANCE FORM
         ================================= -->

    <form
        id="attendanceForm"
        method="post"
        action="attendance.jsp?sessionId=<%= sessionId %>">


        <div class="mb-3">

            <label
                class="form-label"
                for="studentName">

                <i class="bi bi-person-fill"></i>

                Enter Your Name

            </label>


            <input
                type="text"
                name="studentName"
                id="studentName"
                class="form-control"
                placeholder="Enter your registered name"
                autocomplete="off"
                required>

        </div>


        <button
            type="submit"
            id="submitButton"
            class="submit-btn w-100">

            <i class="bi bi-send-fill"></i>

            Submit Attendance

        </button>


    </form>


    <!-- =================================
         ATTENDANCE ID
         ================================= -->

    <input
        type="hidden"
        id="attendanceId"
        value="<%= attendanceId %>">


    <!-- =================================
         WAITING INFORMATION
         ================================= -->

    <%
        if ("PENDING".equalsIgnoreCase(
                attendanceStatus)) {
    %>

        <div class="waiting-info">

            <i class="bi bi-hourglass-split"></i>

            Your request is waiting for
            teacher approval.

        </div>

    <%
        }
    %>


    <!-- =================================
         FOOTER
         ================================= -->

    <div class="secure-text">

        <i class="bi bi-shield-check"></i>

        Attendance Request System

    </div>


</div>



<script>


// ==========================================
// ATTENDANCE STATUS
// ==========================================

var attendanceId =
    document.getElementById(
        "attendanceId"
    ).value;


var currentStatus =
    "<%= attendanceStatus %>";



var statusTimer = null;



// ==========================================
// CHECK STATUS
// ==========================================

function checkAttendanceStatus() {


    fetch(
        "attendanceStatus.jsp?attendanceId="
        + attendanceId
    )


    .then(function(response) {

        return response.text();

    })


    .then(function(status) {


        status =
            status.trim().toUpperCase();


        var statusBox =
            document.getElementById(
                "statusBox"
            );


        var form =
            document.getElementById(
                "attendanceForm"
            );


        if (status === "ACCEPTED") {


            statusBox.style.display =
                "block";


            statusBox.className =
                "alert alert-success status-alert text-center";


            statusBox.innerHTML =
                "<i class='bi bi-check-circle-fill'></i> " +
                "Attendance Accepted Successfully!";


            form.style.display =
                "none";


            stopChecking();


        }


        else if (status === "REJECTED") {


            statusBox.style.display =
                "block";


            statusBox.className =
                "alert alert-danger status-alert text-center";


            statusBox.innerHTML =
                "<i class='bi bi-x-circle-fill'></i> " +
                "Attendance Rejected by Teacher.";


            stopChecking();


        }


        else if (status === "PENDING") {


            statusBox.style.display =
                "block";


            statusBox.className =
                "alert alert-warning status-alert text-center";


            statusBox.innerHTML =
                "<i class='bi bi-hourglass-split'></i> " +
                "Request sent successfully! " +
                "Waiting for teacher approval...";

        }


    })


    .catch(function(error) {

        console.log(
            "Status check error:",
            error
        );

    });

}



// ==========================================
// START CHECKING
// ==========================================

function startChecking() {


    if (statusTimer === null) {

        statusTimer =
            setInterval(
                checkAttendanceStatus,
                3000
            );

    }

}



// ==========================================
// STOP CHECKING
// ==========================================

function stopChecking() {


    if (statusTimer !== null) {

        clearIn