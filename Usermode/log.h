#pragma once
#include <iostream>

#define ANSI_COLOR_RED		"\x1b[31m"
#define ANSI_COLOR_GREEN	"\x1b[32m"
#define ANSI_COLOR_YELLOW	"\x1b[33m"
#define ANSI_COLOR_CYAN		"\x1b[36m"
#define ANSI_COLOR_RESET	"\x1b[0m"

#define Log( ... )			printf("\x1b[36m[LOG] \x1b[0m" __VA_ARGS__)
#define LogInfo( ... )		printf("\x1b[33m[LOG] \x1b[0m" __VA_ARGS__)
#define LogFailure( ... )	printf("\x1b[31m[LOG] \x1b[0m" __VA_ARGS__)
#define LogSuccess( ... )	printf("\x1b[32m[LOG] \x1b[0m" __VA_ARGS__)