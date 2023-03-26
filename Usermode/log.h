#pragma once
#include <iostream>
#include <fstream>
#include <ostream>

#define ANSI_COLOR_RED		"\x1b[31m"
#define ANSI_COLOR_GREEN	"\x1b[32m"
#define ANSI_COLOR_YELLOW	"\x1b[33m"
#define ANSI_COLOR_CYAN		"\x1b[36m"
#define ANSI_COLOR_RESET	"\x1b[0m"

#define Log( ... )			printf("\x1b[36m[LOG] \x1b[0m" __VA_ARGS__)
#define LogInfo( ... )		printf("\x1b[33m[LOG] \x1b[0m" __VA_ARGS__)
#define LogFailure( ... )	printf("\x1b[31m[LOG] \x1b[0m" __VA_ARGS__)
#define LogSuccess( ... )	printf("\x1b[32m[LOG] \x1b[0m" __VA_ARGS__)

#define DEFAULT_LOG "log.txt"

namespace logger {
	std::string InternalGetCurrentDateFormatted(std::string s);

	void CreateLogFile(const char* LogFile);
	bool CheckLogExist(const char* LogName);
	bool WriteLogEntry(const char* String);
	bool WriteLogFile(const char* FileName, const char* String);
	bool WriteLogFile(const char* FolderName, const char* FileName, const char* String);
}