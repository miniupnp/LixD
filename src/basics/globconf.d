module basics.globconf;

/* global variables that may change during program run, and are saved
 * to the global config file. The global config file is different from the
 * user config file, it pertains to all users.
 *
 *  void load();
 *  void save();
 *
 *      Load/save the config from/to the global config file.
 */


import std.file;
import std.stdio;

import basics.globals;
import file.io;
import file.log;

string userName          = "";
bool   userNameAsk       = false;

string ipLastUsed        = "127.0.0.1";
string ipCentralServer   = "asdfasdf.ethz.ch";
int    serverPort        = 22934;



void load()
{
    IoLine[] lines;
    try {
        lines = fillVectorFromFile(basics.globals.fileGlobalConfig);
    }
    catch (Exception e) {
        log("Can't load the global configuration:");
        log("    -> " ~ e.msg);
        log("    -> Falling back to the standard global configuration.");
        log("    -> This is normal when you run Lix for the first time.");
    }

    foreach (i; lines) {

    if      (i.text1 == cfgUserName   ) userName    = i.text2;
    else if (i.text1 == cfgUserNameAsk) userNameAsk = i.nr1 > 0;

    else if (i.text1 == cfgIPLastUsed       ) ipLastUsed       = i.text2;
    else if (i.text1 == cfgIPCentralServer  ) ipCentralServer  = i.text2;
    else if (i.text1 == cfgServerPort      ) serverPort         = i.nr1;
    }
    // end foreach
}
// end function load()



void save()
{
    try {
        std.file.mkdirRecurse(fileGlobalConfig.dirRootful);
        std.stdio.File f = std.stdio.File(fileGlobalConfig.rootful, "w");

        f.writeln(IoLine.Dollar(cfgUserName,               userName));
        f.writeln(IoLine.Hash  (cfgUserNameAsk,           userNameAsk));
        f.writeln("");

        f.writeln(IoLine.Dollar(cfgIPLastUsed,            ipLastUsed));
        f.writeln(IoLine.Dollar(cfgIPCentralServer,       ipCentralServer));
        f.writeln(IoLine.Hash  (cfgServerPort,             serverPort));
        f.close();
    }
    catch (Exception e) {
        log(e.msg);
    }
}
