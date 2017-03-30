
Cache is a Swift implementation of a cache mechanism with different replacement policies. To learn more, visit [Cache replacement policies](https://en.wikipedia.org/wiki/Cache_replacement_policies) and [Page replacement algorithm](https://en.wikipedia.org/wiki/Page_replacement_algorithm) pages on Wikipedia.

Currently implemented:

  * Fifo
  * Lifo
  * Least recently used
  * Most recently used
  * Random replacement
  * Segmented least recently used
  * Least frequently used

On the list:

  * Low inter-reference recency set
  * Adaptive replacement cache
  * Second chance
  * Clock
  * Clock with adaptive replacement
  * Two queue
  * Multi queue

After that, I'll start benchmarking the policies in an iOS sample app and later - implementing disk cache. 