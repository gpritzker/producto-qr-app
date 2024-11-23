document.addEventListener('DOMContentLoaded', function() {
    const cuilInput = document.querySelector('[data-cuil-autocomplete]');
  
    if (cuilInput) {
      cuilInput.addEventListener('input', function(e) {
        let value = e.target.value.replace(/[^0-9]/g, ''); // Elimina todo lo que no sean números
        if (value.length > 2) value = `${value.slice(0, 2)}-${value.slice(2)}`;
        if (value.length > 11) value = `${value.slice(0, 11)}-${value.slice(11)}`;
        e.target.value = value;
      });
    }
  });