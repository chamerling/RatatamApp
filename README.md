# TODO
- See https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/CocoaBindingsRef/BindingsText/NSImageView.html
Pass the NSImage as Value binding with a transformer -> Implement asynchronous NSImage loading

- http://www.cocoabuilder.com/archive/cocoa/147015-asynchronous-binding-to-remote-image.html
- http://stackoverflow.com/questions/2542597/valueurl-binding-on-large-arrays-causes-sluggish-user-interface

GoogleFetcher et NSImage + NSView
- https://github.com/nparry/gdata-objectivec-client/blob/0e8ae1f41c131c8ccc12c36ed4869a491d2d3822/Examples/GooglePhotosSample/GooglePhotosSampleWindowController.m

# Comments processing on self photos

1. Get the photos periodically with https://api.instagram.com/v1/users/self/media/recent
2. Compare new photos comments with old photos comments
3. If photo is new and comments are >0 -> Notification
4. If photo is not new but # comment > old # comment -> notification

1. When the comment processor find new comments, get the media comments with https://api.instagram.com/v1/media/{media-id}/comments
2. Compare all the comments with the cached ones to get the new ones.

## Comment format from photo is

"comments":  {
"count": 1,
"data":  [
{
"created_time": "1333051909",
"text": "Je suis jalouse.",
"from":  {
"username": "mr_monsieur",
"profile_picture": "http://images.instagram.com/profiles/profile_11287222_75sq_1318970771.jpg",
"id": "11287222",
"full_name": "Adrien Havet"
},
"id": "157973324336470125"
}
]
},
