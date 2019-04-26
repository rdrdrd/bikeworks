#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>

int main()
{
	const int PORT = 8081;

	int sockfd, new_socket, bytes_read;
	struct sockaddr_in address;
	int opt = 1;
	int addrlen = sizeof(address);
	char buffer[1024] = {0};
	char * hello = "Hello from server!\n";

	printf("Creating socket....\n");
	fflush(0);
	if ((sockfd = socket(AF_INET, SOCK_STREAM /* | SOCK_NONBLOCK */, 0)) == 0)
	{
		perror("Socket failed");
		exit(EXIT_FAILURE);
	}
	printf("sockfd created: 0x%x\n", sockfd);
	fflush(0);
	if (setsockopt(sockfd, SOL_SOCKET, SO_SNDBUF, &opt, sizeof(opt)))
	{
		perror("setsockopt failed");
		exit(EXIT_FAILURE);
	}
	printf("setsockopt executed\n");
	fflush(0);
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons( PORT );

	if (bind(sockfd, (struct sockaddr *) & address, sizeof(address)) < 0)
	{
		perror("bind failed");
		exit(EXIT_FAILURE);
	}
	printf("bind completed\n");
	fflush(0);

	if (listen(sockfd, 30) < 0)
	{
		perror("listen failure\n");
		exit(EXIT_FAILURE);
	}
	printf("Started listening for connections....\n");
	fflush(0);
	
	if ((new_socket = accept(sockfd, (struct sockaddr *) & address, (socklen_t*) & addrlen)) < 0)
	{
		perror("accept failure");
		exit(EXIT_FAILURE);
	}
	printf("Connection success\n");
	fflush(0);
	
	while (true)
	{
		bytes_read = read(new_socket, buffer, 1024);
		if (bytes_read)
		{
			printf("Got: %s", buffer);
			fflush(0);
			send(new_socket, buffer, strlen(buffer), 0);
			memset(buffer, 0, bytes_read);
		}
	}
	return 0;

}
