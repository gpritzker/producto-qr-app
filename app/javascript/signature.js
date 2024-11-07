// app/javascript/signature.js
import SignaturePad from 'signature_pad';

document.addEventListener("DOMContentLoaded", () => {
  const canvas = document.getElementById("signature-pad");
  if (canvas) {
    const signaturePad = new SignaturePad(canvas);

    document.getElementById("clear-signature").addEventListener("click", () => {
      signaturePad.clear();
    });

    document.getElementById("save-signature").addEventListener("click", () => {
      if (!signaturePad.isEmpty()) {
        const dataURL = signaturePad.toDataURL();
        document.getElementById("signature-data").value = dataURL;
      } else {
        alert("Por favor, firme antes de guardar.");
      }
    });
  }
});
