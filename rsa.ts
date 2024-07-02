import { sign, verify, constants, generateKeyPairSync } from 'crypto';

const { publicKey, privateKey } = generateKeyPairSync("rsa", {
	modulusLength: 2048,
});

const data = "twhy00a6632570b6d4f1476689525d29fd39f23f0d0cb0ee7a7777004d9e273d";

const signature = sign("sha256", Buffer.from(data), {
	key: privateKey,
	padding: constants.RSA_PKCS1_PSS_PADDING,
});

const result = verify(
  'sha256',
  Buffer.from(data),
  {
		key: publicKey,
		padding: constants.RSA_PKCS1_PSS_PADDING,
	},
	signature
);

console.log('verify result: ', result);




