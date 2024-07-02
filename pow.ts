import { createHash, randomBytes } from 'crypto';

const username = 'twhy';

function pow(nzero: number = 4) {
  if (nzero < 1) {
    throw new Error('Invalid n zeros');
  }
  const zeros = new Array(nzero).fill(0).join('');
  const start = +new Date();
  while (true) {
    const nonce = randomBytes(30).toString('hex');
    const data = username + nonce;
    const hash = createHash('sha256').update(data).digest('hex');
    if (hash.startsWith(zeros)) {
      const end = +new Date();
      const time = end - start;
      return { time, data, hash };
    }
  }
}

function log(time: number, data: string, hash: string) {
  console.log('Time: ', `${(time / 1000).toFixed(2)}s`);
  console.log('Data: ', data);
  console.log('Hash: ', hash);
}

function main() {
  const four = pow(4);
  log(four.time, four.data, four.hash);
  const five = pow(5);
  log(five.time, five.data, five.hash);
}

main();
