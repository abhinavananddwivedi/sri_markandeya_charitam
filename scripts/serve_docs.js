const http = require("http");
const fs = require("fs");
const path = require("path");
const root = "D:\\Babaji_files\\docs";
const mime = { ".html":"text/html; charset=utf-8", ".css":"text/css", ".jpg":"image/jpeg", ".ttf":"font/ttf" };
http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split("?")[0]);
  if (p === "/") p = "/index.html";
  const fp = path.join(root, p);
  fs.readFile(fp, (err, data) => {
    if (err) { res.writeHead(404); res.end("not found"); return; }
    res.writeHead(200, { "Content-Type": mime[path.extname(fp)] || "application/octet-stream" });
    res.end(data);
  });
}).listen(8731, () => console.log("listening"));
