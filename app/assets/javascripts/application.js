// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require cuil_autocomplete

async function doPost(url, body = {}, headers = {}, options= {}) {
  if(!headers.hasOwnProperty('Content-Type')) 
    headers['Content-Type'] = 'application/json';

  try {
    response = await fetch(url, {
      method: "POST",
      headers: headers,
      body: JSON.stringify(body)
    });
    r = await response.json();
    if (!response.ok) {
      createApiResponse("warning", r);
      return null;
    }
    else {
      createApiResponse("success", r);
      return r.data;
    }
  } catch(error) {
    console.error(error);
    createApiResponse("error", "No se pudo procesar la solicitud");
  }
}
async function doGet(url, headers = {}) {
  if (!headers.hasOwnProperty('Content-Type')) {
    headers['Content-Type'] = 'application/json';
  }

  try {
    const response = await fetch(url, {
      method: "GET",
      headers: headers,
    });

    if (response.ok) {
      const r = await response.json();
      return r.data; // Devuelve r.data solo si la solicitud fue exitosa
    } else {
      const errorResponse = await response.json();
      console.log(errorResponse);
      return null; // Devuelve null si la solicitud no fue exitosa
    }
  } catch (error) {
    console.error(error);
    return createApiResponse("error", "No se pudo procesar la solicitud");
  }
}

function createApiResponse(status, response) {
  cleanApiResponse();

  if(response.hasOwnProperty("messages")) {
    ul = $("<ul></ul>");
    $.each( response.messages, function( _, value ) {
      ul.append($("<li></li>").html(value))
    });
    $("#responses").html(ul);
  }
  else {
    $("#responses").html(response.message)
  }
  switch (status) {
    case "error": $("#responses").addClass("alert alert-danger"); break;
    case "success": $("#responses").addClass("alert alert-success"); break;
    case "warning": $("#responses").addClass("alert alert-warning"); break;
    default: $("#responses").addClass("alert alert-info");
  }

  $("#responses").show();
  document.getElementById("responses").scrollIntoView({ behavior: "smooth" });
}
function cleanApiResponse() {
  $("#responses").removeClass().html("").hide();
}
