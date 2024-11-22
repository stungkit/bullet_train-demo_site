NOTE: These images are referred to by the upgrade documentation at https://bullettrain.co/docs/upgrades.

Those docs are provided by the `bullet_train` gem in the `core` repo, which means that they also ship
with every Bullet Train app. These images live here, in the demo site repo, so that we don't have to
ship these images in the `bullet_train` gem.

These images are served without being precompiled or fingerprinted, so they could potentially be cached
by browsers (or intermediaries) for a long time. If you need to change one of the images you should
add a new image with a new filename so that it ends up at a unique URL.
