#include "log.h"
#include <filesystem>

std::string logger::InternalGetCurrentDateFormatted(std::string s) {
	time_t now = time(0);
	struct tm tstruct;
	char buf[80];
	tstruct = *(localtime(&now));
	if (s == "now")
		strftime(buf, sizeof(buf), "%Y-%m-%d %X", &tstruct);
	else if (s == "date")
		strftime(buf, sizeof(buf), "%Y-%m-%d", &tstruct);
	return std::string(buf);
}

void logger::CreateLogFile(const char* LogFile) {

}

bool logger::CheckLogExist(const char* LogName) {
	return false;
}

bool logger::WriteLogEntry(const char* String) {
	std::ofstream ofs(DEFAULT_LOG, std::ios_base::out | std::ios_base::app);

    ofs << InternalGetCurrentDateFormatted("now") << '\t' << String << '\n';
	return true;
}

bool logger::WriteLogFile(const char* FileName, const char* String) {
	std::ofstream ofs(FileName, std::ios_base::out | std::ios_base::app);

	ofs << String << '\n';
	return true;
}

bool logger::WriteLogFile(const char* FolderName, const char* FileName, const char* String) {
	std::string FilePath = (std::string(FolderName) + "\\" + std::string(FileName));
	std::ofstream ofs(FilePath.c_str(), std::ios_base::out | std::ios_base::app);
	
	namespace fs = std::filesystem;
	fs::create_directories(FolderName);

	ofs << String << '\n';
	return true;
}
