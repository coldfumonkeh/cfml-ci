var WinHttpReq = new ActiveXObject("WinHttp.WinHttpRequest.5.1");
// arg 0 = website URL
// arg 1 = filename
WinHttpReq.Open("GET", WScript.Arguments(0), /*async=*/false);
WinHttpReq.Send();

BinStream = new ActiveXObject("ADODB.Stream");
BinStream.Type = 1;
BinStream.Open();
BinStream.Write(WinHttpReq.ResponseBody);
BinStream.SaveToFile(WScript.Arguments(1));