 
function UserLoginValidate(event) {
    // Prevent form submission
    if (event) event.preventDefault();

    // Remove previous validation states
    document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

    let isValid = true;

    // Helper to mark field invalid
    function markInvalid(id) {
        const input = document.getElementById(id);
        const label = document.querySelector(`label[for="${id}"]`);
        if (input) input.classList.add('is-invalid');
        if (label) label.classList.add('is-invalid');
    }

    // Validate Email
    const email = document.getElementById('inputEmail');
    const emailValue = email.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailValue || !emailRegex.test(emailValue)) {
        markInvalid('inputEmail');
        isValid = false;
    }

    // Validate Password
    const password = document.getElementById('inputPassword');
    if (!password.value.trim()) {
        markInvalid('inputPassword');
        isValid = false;
    }

    if (isValid) {
        console.log("Login form is valid. Proceeding...");
        return true;
        // document.querySelector('.global-form').submit();
    } else {
        return false;
        console.log("Login form invalid. Check highlighted fields.");
        exit;
    }
}

 function runRecaptcha(event) {
    event.preventDefault();
    if (UserLoginValidate(event) != false) {
        grecaptcha.ready(function() {
            grecaptcha.execute('3XAMPL3CAPCH4C0D3', {
                action: 'LOGIN'
            }).then(function(token) {
                // Send token to backend
                fetch('CAPCHA/verify-captcha.php', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: 'recaptcha_token=' + encodeURIComponent(token)
                    })
                    .then(res => res.text())
                    .then(data => {
                        // Save the response to a variable
                        let serverResponse = data;
                        console.log("Server response:", serverResponse);

                        // You can now use `serverResponse` here or call another function with it
                        handleCaptchaResponse(serverResponse, event);
                    });
            });
        });
    }
}
