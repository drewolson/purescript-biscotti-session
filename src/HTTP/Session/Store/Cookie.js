exports._decrypt = function (secret) {
  return function (ciphertext) {
    return function (onError, onSuccess) {
      var _sodium = require("libsodium-wrappers");

      _sodium
        .ready
        .then(function () {
          var sodium = _sodium;
          var key = sodium.from_hex(secret);
          var plaintext = decrypt_after_extracting_nonce(sodium, key, ciphertext);

          onSuccess(plaintext);
        })
        .catch(onError);

      return function (cancelError, cancelerError, cancelerSuccess) {
        cancelerSuccess();
      };
    };
  };
};

exports._encrypt = function (secret) {
  return function (plaintext) {
    return function (onError, onSuccess) {
      var _sodium = require("libsodium-wrappers");

      _sodium
        .ready
        .then(function () {
          var sodium = _sodium;
          var key = sodium.from_hex(secret);
          var ciphertext = encrypt_and_prepend_nonce(sodium, key, plaintext);

          onSuccess(ciphertext);
        })
        .catch(onError);

      return function (cancelError, cancelerError, cancelerSuccess) {
        cancelerSuccess();
      };
    };
  };
};

function encrypt_and_prepend_nonce(sodium, key, message) {
  let nonce = sodium.randombytes_buf(sodium.crypto_secretbox_NONCEBYTES);
  let ciphertext = sodium.crypto_secretbox_easy(message, nonce, key);

  let payload = new Uint8Array(nonce.length + ciphertext.length);
  payload.set(nonce);
  payload.set(ciphertext, nonce.length);

  return sodium.to_base64(payload);
}

function decrypt_after_extracting_nonce(sodium, key, payload) {
  let nonce_and_ciphertext = sodium.from_base64(payload);

  if (nonce_and_ciphertext.length < sodium.crypto_secretbox_NONCEBYTES + sodium.crypto_secretbox_MACBYTES) {
    throw "invalid ciphertext length";
  }

  let nonce = nonce_and_ciphertext.slice(0, sodium.crypto_secretbox_NONCEBYTES);
  let ciphertext = nonce_and_ciphertext.slice(sodium.crypto_secretbox_NONCEBYTES);
  let plaintext = sodium.crypto_secretbox_open_easy(ciphertext, nonce, key);

  return sodium.to_string(plaintext);
}
