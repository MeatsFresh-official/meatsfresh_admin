<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Access Denied</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6 text-center">
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <h3>Access Denied</h3>
                    </div>
                    <div class="card-body">
                        <p>You don't have permission to access this page.</p>
                        <a href="/dashboard" class="btn btn-primary">Back to Dashboard</a>
                        <a href="/logout" class="btn btn-secondary">Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>