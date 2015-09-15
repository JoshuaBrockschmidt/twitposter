#include "twitposter.hpp"

std::string consumerKey       = "TODO";
std::string consumerSecret    = "TODO";
std::string accessTokenKey    = "TODO";
std::string accessTokenSecret = "TODO";

int main() {
	TwitPoster twitPosterObj(consumerKey, consumerSecret,
			      accessTokenKey, accessTokenSecret);
	twitPosterObj.postTweet("This tweet was sent via TwitPoster");
	try {
		twitPosterObj.postTweet("");
	} catch (TwitPoster::bad_tweet& e) {
		std::cout << "This error should be thrown: "
			  << e.what()
			  << std::endl;
	}
	try {
		twitPosterObj.postTweet("This status update exceeds the 140 character limit. Thus an instance of TwitPoster::bad_tweet should be thrown when this string is passed as a parameter of TwitPoster::postTweet. If a section of this tweet is posted to Twitter, then something has gone wrong");
	} catch (TwitPoster::bad_tweet& e) {
		std::cout << "This error should be thrown: "
			  << e.what()
			  << std::endl;
	}

	return 0;
}
