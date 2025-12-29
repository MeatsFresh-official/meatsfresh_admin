document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');

    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            clearErrors();

            // Validate email
            const email = document.getElementById('email');
            if (!email.value || !validateEmail(email.value)) {
                showError(email, 'Please enter a valid email address');
                return;
            }

            // Validate password
            const password = document.getElementById('password');
            if (!password.value) {
                showError(password, 'Please enter your password');
                return;
            }

            // If validations pass, submit the form
            this.submit();
        });
    }

    // Helper functions
    function validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    function showError(input, message) {
        const formGroup = input.closest('.form-group');
        if (!formGroup) return;

        formGroup.classList.add('has-error');

        let errorElement = formGroup.querySelector('.error-message');
        if (!errorElement) {
            errorElement = document.createElement('div');
            errorElement.className = 'error-message';
            formGroup.appendChild(errorElement);
        }

        errorElement.textContent = message;
    }

    function clearErrors() {
        document.querySelectorAll('.form-group').forEach(group => {
            group.classList.remove('has-error');
        });

        document.querySelectorAll('.error-message').forEach(error => {
            error.textContent = '';
        });
    }
});