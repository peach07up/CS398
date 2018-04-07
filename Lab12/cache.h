typedef struct cache_block {
  unsigned tag;
  bool valid;
  // no need to store actual data
  // same with dirty bits

  unsigned last_access_time;  // easy way to implement LRU
} cache_block_t;
  
typedef struct cache {
  cache_block_t *blocks;     // the blocks themsleves

  // the configuration of the cache
  unsigned size;
  unsigned num_blocks;
  unsigned nways;
  unsigned block_size;

  // address configuration
  unsigned tag_bits;
  unsigned index_bits;
  unsigned boff_bits;

  unsigned LRU_counter;    // a counter used for tracking LRU
	
  // bitmasks	
  unsigned tag_mask;      // obtains the tag from an address 
  unsigned index_mask;    // obtains the index from an address 

} cache_t;

// statistics
typedef struct stats {
  unsigned accesses;
  unsigned hits;
} stats_t;


