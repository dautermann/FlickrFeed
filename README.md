FlickrFeed
==========

FlickrFeed

Bitcasa Coding Exercise 19

iPhone/iPad Photo Viewer

Objective: 

To build a native iOS application (target either iPhone or iPad or both, but please specify). 

Guidelines:

	Please use the flickr public api directly from your app to source images:

http://api.flickr.com/services/feeds/photos_public.gne

	The final app should have a minimum of two pages.

The overview page: Should show the user thumbnails of each of the photos in the stream in a nicely organized fashion. This page should automatically refresh as the RSS stream updates. Tapping on any given picture should take you to screen 2. This view should include the feed name and update time.

The photo page: This is the full screen view of the photo. It should include the title of the photo and the author name. From this view, the user should be able to navigate to the preceding or following photos in the feed and remain in the photo page view.

Submission:

	Please submit:

Your xcode project – either Zip it up or post it to a repository on bitbucket.org or assembla.com. Please comment your code.
A short readme describing the app
Your resume

Evaluation:

You will be evaluated in 3 areas

Code quality
Functional completion versus requirements
Usability and aesthetics (including performance)

==========

What this app does:

1) It fetches from the Flickr feed and displays thumbnails of these pictures in a table view.  These update every five seconds.

2) Touching a picture in the scrolling table will take you to the full size version of that picture.  You can then pop back to the list of pictures or step up and down through the list of pictures via arrow button icons.

3) It's a universal binary.  It should work (and roughly look) the same for both iPad and iPhone.

What this app doesn't do (and should do pretty soon, once I get around to clearing my other work so I can get back to this):

1) It's still missing some functionality that should be straightforward to put into place (the arrows should enable and disable based on where one is inspecting within the list of images; displaying the "feed name" in the table -- speaking of that, if the feed is static, should the name even be displayed or what should be displayed for a "feed name"?).

2) Right now I'm loading each picture synchronously via a background thread.  If I have time, I would enhance this to do lazy loading in the background.  

3) The memory requirements explode the longer the app is running (as it loads 20 new images every five seconds).  I could put either a) an upper bound on the possible number of pictures or b) write the full resolution image data to a cache file, or some combination of both.  My guess is that the app will crash (after running out of memory) a few minutes after it's launched.

4) I'm not checking the feed for duplicate pictures. Taking care of #3 up above may help me to fully implement duplicate checking.
