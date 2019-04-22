import vibe.vibe;

void main() {
	auto settings = new HTTPServerSettings;
	settings.port = 3142;
	auto router = new URLRouter;

	router.get("/restart", &restarter);

	listenHTTP(settings, router);
	runApplication();
}

bool checkPassword(string password) {
	import std.digest.md;

	enum hash = "730C1DEAEC465FD08DEC622903BF74EA";

	if (("WoUlD_YoU_LiKe_SoMe_SaLt_WiTh_ThAt_HaSh?"~("mm"~password.md5Of.toHexString~"zz").md5Of.toHexString).md5Of.toHexString == hash) {
		return true;
	}

	return false;
}

void restarter(HTTPServerRequest req, HTTPServerResponse res) {
	import std.process;

	if (!checkPassword(req.query["password"])) {
		res.writeBody("INVALID PASSWORD");
		return;
	}

	executeShell("launchctl unload ~/Library/LaunchAgents/WebShellServerStarter.plist ; sleep 1 ; launchctl load ~/Library/LaunchAgents/WebShellServerStarter.plist");
	res.writeBody("restarted");
}
