const WebSocket = require('ws');
const http = require('http');
const net = require('net');

function handleWebsockify(wsconn) {
  const d = new net.Dialer();
  const address = 'localhost:5900';
  const conn = d.dial('tcp://' + address, {
    context: wsconn._socket._handle.context
  }, () => {
    wsconn._socket._handle.setKeepAlive(true);
    wsconn._socket._handle.setNoDelay(true);
    wsconn._socket._handle.resume();
  });

  wsconn.on('message', (data) => {
    conn.write(data);
  });
  conn.on('data', (data) => {
    wsconn.send(data);
  });
  wsconn.on('close', () => {
    conn.end();
  });
}

function handleAudio(conn, writers) {
  const ch = [];
  writers.set(conn, ch);
  conn.on('message', (data) => {
    ch.forEach((c) => {
      if (c !== ch) {
        c.push(data);
      }
    });
  });
  conn.on('close', () => {
    writers.delete(conn);
  });
}

function runJsmpegUDP(address, writer) {
  const udpSocket = new net.Socket();
  udpSocket.bind(address, () => {
    console.log('Jsmpeg UDP listening on ' + address);
  });
  udpSocket.on('data', (data) => {
    writer.write(data);
  });
}

const writers = new Map();
const server = http.createServer((req, res) => {
  res.writeHead(404);
  res.end();
});
const wss = new WebSocket.Server({server});

wss.on('connection', handleWebsockify);

wss.on('error', (err) => {
  console.error(err);
});

server.on('upgrade', (req, socket, head) => {
  if (req.url === '/audio') {
    const conn = new WebSocket(req, null, {
      perMessageDeflate: false,
      maxPayload: 512,
    });
    handleAudio(conn, writers);
  } else {
    socket.destroy();
  }
});

const address = '0.0.0.0:8080';
server.listen(address, () => {
  console.log('HTTP listening on ' + address);
});

runJsmpegUDP('0.0.0.0:1234', {
  write: (data) => {
    writers.forEach((ch) => {
      ch.forEach((c) => {
        if (c !== ch) {
          c.write(data);
        }
      });
    });
  }
});
