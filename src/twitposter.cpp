/* TODO:
 *  - Check web responses when sending tweets. This will involve JSON parsing.
 *    Consider RapidJSON or JsonCPP.
 *  - Account for the fact that links are shortened by Twitter.
 *  - Check if Internet is up before attempting to send a tweet.
 */

#include <iostream>
#include "twitposter.hpp"

TwitPoster::TwitPoster():
	twitterObj() {}

TwitPoster::TwitPoster(std::string consumerKey,
		       std::string consumerSecret,
		       std::string accessTokenKey,
		       std::string accessTokenSecret):
	twitterObj() {
	twitterObj.getOAuth().setConsumerKey(consumerKey);
	twitterObj.getOAuth().setConsumerSecret(consumerSecret);
	twitterObj.getOAuth().setOAuthTokenKey(accessTokenKey);
	twitterObj.getOAuth().setOAuthTokenSecret(accessTokenSecret);
	if (!verifyCreds()) {
		std::string m="TwitPoster::TwitPoster: Invalid credentials";
		throw invalid_creds(m);
	}
}

void TwitPoster::setConsumerKey(std::string consumerKey) {
	twitterObj.getOAuth().setConsumerKey(consumerKey);
}

void TwitPoster::setConsumerSecret(std::string consumerSecret) {
	twitterObj.getOAuth().setConsumerSecret(consumerSecret);
}

void TwitPoster::setAccessTokenKey(std::string accessTokenKey) {
	twitterObj.getOAuth().setOAuthTokenKey(accessTokenKey);
}

void TwitPoster::setAccessTokenSecret(std::string accessTokenSecret) {
	twitterObj.getOAuth().setOAuthTokenSecret(accessTokenSecret);
}

bool TwitPoster::verifyCreds() {
	if (!twitterObj.accountVerifyCredGet()) {
		std::string err;
		twitterObj.getLastCurlError(err);
		std::cerr << "TwitPoster::verifyCreds: "
			  << "twitCurl::accountVerifyCredGet: "
			  << std::endl
			  << err
			  << std::endl;
		return false;
	} else {
		//TODO: check twitCurl::getLastWebResponse()
		return true;
	}
}

void TwitPoster::postTweet(std::string tweet) {
	if (tweet.size() == 0) {
		std::string m="TwitPoster::postTweet: "
			"Tweet is less than 1 character";
		throw bad_tweet(m);
	} else if (tweet.size() > 140) {
		std::string m="TwitPoster::postTweet: "
			"tweet is greater than 140 characters";
		throw bad_tweet(m);
	}

	if (!twitterObj.statusUpdate(tweet)) {
		std::string m="TwitPoster::postTweet: "
			"twitCurl::statusUpdate: "
			"could not post tweet";
		throw bad_tweet(m);
	}
	//TODO: check with twitCurl:getLastWebResponse()
}

std::string TwitPoster::getLastWebResponse() {
	std::string webRespond;
	twitterObj.getLastWebResponse(webRespond);

	return webRespond;
}

TwitPoster::invalid_creds::invalid_creds(std::string m):
	std::runtime_error(m) {}
const char* TwitPoster::invalid_creds::what() const throw() {
	return std::runtime_error::what();
}

TwitPoster::bad_tweet::bad_tweet(std::string m):
	std::runtime_error(m) {}
const char* TwitPoster::bad_tweet::what() const throw() {
        return std::runtime_error::what();
}
