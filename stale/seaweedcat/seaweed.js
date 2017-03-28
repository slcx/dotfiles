// vim: set ts=2 sts=2 sw=2 et:

let is_handling_password = false;

window.show_prompt = function(text, type) {
  // switch the main text entry box to another
  // type
  
  console.log(`show_prompt: text=${text} type=${type}`);

  switch (type) {
    // entering password, focus the password
    // field and disable username
    case 'password':
      is_handling_password = true;
      $('#username').attr('disabled', true);
      $('#password').attr('disabled', false).focus();
      break;
    case 'text':
      is_handling_password = false;
      $('#username').attr('disabled', false).focus();
      $('#password').attr('disabled', true);
      break;
  }
};

/**
 * authentication_complete callback.
 */
window.authentication_complete = function() {
  if (lightdm.is_authenticated) {
    console.log('authentication completed -- transitioning to session');
    lightdm.start_session_sync();
  } else {
    console.log('authentication failed');
    $('#username, #password').val('');
    $('#password').attr('disabled', true);
    $('#username').attr('disabled', false).focus();
    setTimeout(start_authentication, 1000);
  }
};

window.start_authentication = function() {
  lightdm.authenticate();
};

window.handle_input = function(val) {
  if (is_handling_password) $('#password').attr('disabled', true);
  lightdm.respond(val);
};

window.addEventListener("load", function() {
  // give the correct handler
  start_authentication();

  $('input').on('keydown', function(event) {
    // 13 = enter, 9 = tab
    if (event.which === 13 || event.which === 9) handle_input($(this).val());
  });
});
