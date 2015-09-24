#include "twitposter.hpp"

std::string consumerKey       = "TODO";
std::string consumerSecret    = "TODO";
std::string accessTokenKey    = "TODO";
std::string accessTokenSecret = "TODO";

int main(int argc, char **argv) {
	if (argc == 1) {
	        std::cerr << argv[0]
			  << ": too few arguments"
			  << std::endl;
		exit(EXIT_FAILURE);
	}
	try {
		TwitPoster twitPosterObj(consumerKey, consumerSecret,
					 accessTokenKey, accessTokenSecret);
		twitPosterObj.postTweet(std::string(argv[1]));
		//DEBUG
		std::cout << twitPosterObj.getLastWebResponse() << std::endl;
		//EOF DEBUG
	} catch (std::runtime_error& e) {
		std::cerr << argv[0]
			  << ": "
			  << e.what()
			  << std::endl;
	}

	return 0;
}
