```q
.req.VERBOSE:1b
req:use`ws.reQ
req.g"https://edgebin.liujiacai.net/get?a=123"
req.g"https://edgebin.liujiacai.net/ip"
req.g"https://edgebin.liujiacai.net/headers"
req.g"https://edgebin.liujiacai.net/user-agent"
req.g"https://edgebin.liujiacai.net/uuid"
req.g"https://edgebin.liujiacai.net/status/200"
req.g"https://user:pass@edgebin.liujiacai.net/basic-auth/user/pass"
// req.g"https://user:pass@edgebin.liujiacai.net/proxy-auth/user/pass" // don't work
req.g"https://user:pass@edgebin.liujiacai.net/cookies/set/session/12345"


```