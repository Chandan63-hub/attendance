<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String selectedDate = request.getParameter("attendanceDate");
    String selectedSubject = request.getParameter("subject");

    ABC db = new ABC();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String sql =
        "SELECT a.id, s.roll_no, s.name, a.subject, " +
        "a.attendance_date, a.attendance_time " +
        "FROM attendance a " +
        "INNER JOIN students s ON a.student_id = s.id " +
        "WHERE a.status = 'ACCEPTED' ";

    if (selectedDate != null && !selectedDate.trim().equals("")) {
        sql += "AND a.attendance_date = ? ";
    }

    if (selectedSubject != null && !selectedSubject.trim().equals("")) {
        sql += "AND a.subject = ? ";
    }

    sql += "ORDER BY s.roll_no ASC";

    try {
        con = db.getCon();

        ps = con.prepareStatement(sql);

        int parameterIndex = 1;

        if (selectedDate != null && !selectedDate.trim().equals("")) {
            ps.setString(parameterIndex, selectedDate);
            parameterIndex++;
        }

        if (selectedSubject != null && !selectedSubject.trim().equals("")) {
            ps.setString(parameterIndex, selectedSubject);
            parameterIndex++;
        }

        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Attendance History</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

    <style>

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

            padding: 40px 15px;
        }

        .main-card {
            max-width: 1100px;
            margin: auto;

            background: white;

            border-radius: 25px;

            padding: 30px;

            box-shadow:
                0 20px 50px rgba(0,0,0,0.25);
        }

        .page-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header-icon {
            width: 70px;
            height: 70px;

            margin: auto;
            margin-bottom: 15px;

            border-radius: 50%;

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

            font-size: 32px;
        }

        .page-header h2 {
            font-weight: bold;
            color: #222;
        }

        .page-header p {
            color: #777;
            margin-bottom: 0;
        }

        .filter-box {
            background: #f5f7ff;

            border-radius: 18px;

            padding: 20px;

            margin-bottom: 25px;
        }

        .filter-title {
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
        }

        .form-label {
            font-weight: 600;
        }

        .btn-search {
            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

            border: none;
            color: white;
            font-weight: bold;
        }

        .btn-search:hover {
            color: white;
            opacity: 0.9;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 15px;
        }

        table {
            min-width: 800px;
        }

        thead th {
            background:
                linear-gradient(
                    135deg,
                    #0d6efd,
                    #6610f2
                );

            color: white !important;

            text-align: center;

            padding: 14px !important;
        }

        tbody td {
            text-align: center;
            vertical-align: middle;
            padding: 13px !important;
        }

        tbody tr:hover {
            background-color: #f5f7ff;
        }

        .roll-badge {
            background: #e8f0ff;
            color: #0d6efd;

            padding: 6px 12px;

            border-radius: 20px;

            font-weight: bold;
        }

        .subject-badge {
            background: #f0e9ff;
            color: #6610f2;

            padding: 6px 12px;

            border-radius: 20px;

            font-weight: 600;
        }

        .clear-btn {
            border-radius: 10px;
            font-weight: 600;
        }

        .bottom-buttons {
            margin-top: 25px;

            display: flex;
            justify-content: center;

            gap: 12px;

            flex-wrap: wrap;
        }

        .no-record {
            text-align: center;

            padding: 40px;

            color: #777;
        }

        .no-record i {
            font-size: 45px;
            color: #999;
        }

        .filter-badge {
            display: inline-block;

            background: #eef2ff;

            color: #4b4ded;

            padding: 7px 12px;

            border-radius: 20px;

            margin: 3px;

            font-size: 14px;

            font-weight: 600;
        }

        .print-title {
            display: none;
        }

        @media print {

            body {
                background: white;
                padding: 0;
            }

            .main-card {
                box-shadow: none;
                max-width: 100%;
                padding: 10px;
            }

            .no-print {
                display: none !important;
            }

            .print-title {
                display: block;
                text-align: center;
                margin-bottom: 20px;
            }

            table {
                min-width: 100%;
            }

            thead th {
                background: #ddd !important;
                color: black !important;
            }

        }

        @media(max-width:600px) {

            body {
                padding: 15px 8px;
            }

            .main-card {
                padding: 20px 12px;
                border-radius: 18px;
            }

            .page-header h2 {
                font-size: 24px;
            }

        }

    </style>

</head>

<body>

<div class="main-card">

    <!-- HEADER -->

    <div class="page-header">

        <div class="header-icon">
            <i class="bi bi-clock-history"></i>
        </div>

        <h2>Attendance History</h2>

        <p>
            View accepted student attendance records
        </p>

    </div>


    <!-- FILTER -->

    <div class="filter-box no-print">

        <div class="filter-title">
            <i class="bi bi-funnel-fill"></i>
            Filter Attendance
        </div>

        <form method="get" action="history.jsp">

            <div class="row g-3">

                <!-- DATE -->

                <div class="col-md-5">

                    <label class="form-label">
                        Attendance Date
                    </label>

                    <input
                        type="date"
                        name="attendanceDate"
                        class="form-control"
                        value="<%= selectedDate == null ? "" : selectedDate %>">

                </div>


                <!-- SUBJECT -->

                <div class="col-md-5">

                    <label class="form-label">
                        Subject
                    </label>

                    <select
                        name="subject"
                        class="form-select">

                        <option value="">
                            All Subjects
                        </option>

                        <option value="CLOUD COMPUTING"
                            <%= "CLOUD COMPUTING".equals(selectedSubject) ? "selected" : "" %>>
                            CLOUD COMPUTING
                        </option>

                        <option value="OOPS USING JAVA"
                            <%= "OOPS USING JAVA".equals(selectedSubject) ? "selected" : "" %>>
                            OOPS USING JAVA
                        </option>

                        <option value="SOFTWARE TESTING"
                            <%= "SOFTWARE TESTING".equals(selectedSubject) ? "selected" : "" %>>
                            SOFTWARE TESTING
                        </option>

                        <option value="SYSTEM ADMINISTRATION"
                            <%= "SYSTEM ADMINISTRATION".equals(selectedSubject) ? "selected" : "" %>>
                            SYSTEM ADMINISTRATION
                        </option>

                        <option value="INDIAN CONSTITUTION"
                            <%= "INDIAN CONSTITUTION".equals(selectedSubject) ? "selected" : "" %>>
                            INDIAN CONSTITUTION
                        </option>

                    </select>

                </div>


                <!-- SEARCH -->

                <div class="col-md-2 d-flex align-items-end">

                    <button
                        type="submit"
                        class="btn btn-search w-100">

                        <i class="bi bi-search"></i>
                        Search

                    </button>

                </div>

            </div>

        </form>


        <!-- SELECTED FILTERS -->

        <div class="mt-3">

            <%
                if (selectedDate != null &&
                    !selectedDate.trim().equals("")) {
            %>

                <span class="filter-badge">
                    <i class="bi bi-calendar3"></i>
                    Date: <%= selectedDate %>
                </span>

            <%
                }

                if (selectedSubject != null &&
                    !selectedSubject.trim().equals("")) {
            %>

                <span class="filter-badge">
                    <i class="bi bi-book"></i>
                    Subject: <%= selectedSubject %>
                </span>

            <%
                }
            %>

        </div>

    </div>


    <!-- TABLE -->

    <div class="table-container">

        <table class="table table-bordered table-hover">

            <thead>

                <tr>

                    <th>#</th>

                    <th>
                        Roll No
                    </th>

                    <th>
                        Student Name
                    </th>

                    <th>
                        Subject
                    </th>

                    <th>
                        Date
                    </th>

                    <th>
                        Time
                    </th>

                    <th class="no-print">
                        Action
                    </th>

                </tr>

            </thead>

            <tbody>

            <%
                int count = 0;

                while (rs.next()) {

                    count++;

                    int attendanceId =
                        rs.getInt("id");

                    int rollNo =
                        rs.getInt("roll_no");

                    String studentName =
                        rs.getString("name");

                    String subject =
                        rs.getString("subject");

                    String attendanceDate =
                        rs.getString("attendance_date");

                    String attendanceTime =
                        rs.getString("attendance_time");
            %>

                <tr>

                    <td>
                        <strong><%= count %></strong>
                    </td>

                    <td>
                        <span class="roll-badge">
                            <%= rollNo %>
                        </span>
                    </td>

                    <td>
                        <strong>
                            <%= studentName %>
                        </strong>
                    </td>

                    <td>
                        <span class="subject-badge">
                            <%= subject %>
                        </span>
                    </td>

                    <td>
                        <%= attendanceDate %>
                    </td>

                    <td>
                        <%= attendanceTime %>
                    </td>

                    <td class="no-print">

                        <form
                            method="post"
                            action="clearAttendance.jsp"
                            style="display:inline;">

                            <input
                                type="hidden"
                                name="attendanceId"
                                value="<%= attendanceId %>">

                            <input
                                type="hidden"
                                name="attendanceDate"
                                value="<%= selectedDate == null ? "" : selectedDate %>">

                            <input
                                type="hidden"
                                name="subject"
                                value="<%= selectedSubject == null ? "" : selectedSubject %>">

                            <button
                                type="submit"
                                class="btn btn-danger btn-sm clear-btn"
                                onclick="return confirm('Are you sure you want to remove this attendance?');">

                                <i class="bi bi-trash3"></i>
                                Clear

                            </button>

                        </form>

                    </td>

                </tr>

            <%
                }

                if (count == 0) {
            %>

                <tr>

                    <td
                        colspan="7"
                        class="no-record">

                        <i class="bi bi-calendar-x"></i>

                        <h5 class="mt-3">
                            No Attendance Found
                        </h5>

                        <p>
                            No accepted attendance records
                            match the selected filter.
                        </p>

                    </td>

                </tr>

            <%
                }
            %>

            </tbody>

        </table>

    </div>


    <!-- PRINT TITLE -->

    <div class="print-title">

        <h2>Attendance History</h2>

        <p>
            Accepted Attendance Records
        </p>

    </div>


    <!-- BUTTONS -->

    <div class="bottom-buttons no-print">

        <button
            onclick="window.print()"
            class="btn btn-dark">

            <i class="bi bi-printer-fill"></i>
            Print

        </button>


        <a
            href="history.jsp"
            class="btn btn-outline-secondary">

            <i class="bi bi-arrow-clockwise"></i>
            Clear Filters

        </a>


        <a
            href="teacher.jsp"
            class="btn btn-primary">

            <i class="bi bi-speedometer2"></i>
            Teacher Dashboard

        </a>

    </div>

</div>

</body>
</html>

<%
    } catch (Exception e) {
%>

<!DOCTYPE html>
<html>
<head>

    <title>Attendance History Error</title>

    <style>

        body {
            font-family: Arial;
            background: #f5f5f5;
            padding: 40px;
        }

        .error-box {
            max-width: 700px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px #ccc;
        }

        h2 {
            color: #dc3545;
        }

        pre {
            background: #f1f1f1;
            padding: 15px;
            overflow-x: auto;
        }

    </style>

</head>

<body>

<div class="error-box">

    <h2>
        <i>Database Error</i>
    </h2>

    <p>
        Something went wrong while loading attendance history.
    </p>

    <pre><%= e.getMessage() %></pre>

    <a href="teacher.jsp">
        Back to Teacher Dashboard
    </a>

</div>

</body>
</html>

<%
    } finally {

        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception ex) {
        }

        try {
            if (ps != null) {
                ps.close();
            }
        } catch (Exception ex) {
        }

        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception ex) {
        }
    }
%>