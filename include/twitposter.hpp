#ifndef TWITPOSTER_H
#define TWITPOSTER_H

#include <exception>
#include <string>
#include "twitcurl.h"

class TwitPoster {
public:
	/* Initializes a twitter bot/poster that targets one individual
	 * Twitter account.
	 */
	TwitPoster();
	
	/* Initializes a twitter poster with authentication parameters
	 * and checks for their validity. An TwitPoster::invalid_creds
	 * is thrown if the authentication parameters are incorrect.
	 *
	 * @param consumerKey Consumer key.
 	 * @param consumerSecret Consumer secret.
	 * @param accessTokenKey Access token key.
	 * @param accessTokenSecret Access token secret.
	 */
	TwitPoster(std::string consumerKey,
		   std::string consumerSecret,
		   std::string accessTokenKey,
		   std::string accessTokenSecret);

	/* Sets the consumer key.
	 *
	 * @param consumerKey Consumer key.
	 */
	void setConsumerKey(std::string consumerKey);

	/* Sets the consumer secret.
	 *
	 * @param consumerKey Consumer secret.
	 */
	void setConsumerSecret(std::string consumerSecret);

	/* Sets the access token key.
	 *
	 * @param accessTokenKey Acces token key.
	 */
	void setAccessTokenKey(std::string accessTokenKey);
	
	/* Sets the access token secret.
	 *
	 * @param accessToken Consumer secret.
	 */
	void setAccessTokenSecret(std::string accessTokenSecret);

	/* Verifies account credentials (keys and secrets).
	 * Prints an error to std::cerr if credentials are invalid.
	 *
	 * @return True if credentials are verified. False if they are not.
	 */
	bool verifyCreds();

	/* Posts a tweet. This will not work if account credentials are not
	 * valid. If the tweet cannot be posted, an TwitPoster::bad_tweet will
	 * be thrown.
	 *
	 * @param tweet Status update to post. If the tweets character length
	 * does not fall within the range [1,140], a TwitPoster::bad_tweet
	 * will be thrown.
	 */
	void postTweet(std::string tweet);
	
	/* Gets the last web response from Twitter. Useful for debugging
	 * verification and posting issues.
	 *
	 * @return Last web response.
	 */
	std::string getLastWebResponse();

	class invalid_creds: public std::runtime_error {
	public:
		invalid_creds(std::string m);
		virtual const char* what() const throw();
	};

	class bad_tweet: public std::runtime_error {
	public:
	        bad_tweet(std::string m);
		virtual const char* what() const throw();
	};
private:
	twitCurl twitterObj;
};

#endif //TWITPOSTER_H
