#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cache.h"

const int LINE_LENGTH = 80;

void init_cache(cache_t *cache, unsigned num_blocks, 
					 unsigned block_size, unsigned assoc);
void init_stats(stats_t *stats);
bool find_block_and_update_lru(cache_t *cache, unsigned address, stats_t *stats);
void fill_cache_with_block(cache_t *cache, unsigned address);

int
main(int argc, char *argv[]) {
  bool verbose = (argc == 6) && (strncmp(argv[5], "verbose", 8) == 0);

  // check to see if there are the right number of parameters
  if ((argc != 5) && !verbose) {
    printf("%s <trace_file> <cache_size> <nways> <block_size> [verbose]\n", 
	   argv[0]);
    exit(0);
  }

  // read the parameters and convert the last 3 to integers
  // open the trace file for reading
  FILE *trace_file = fopen(argv[1], "r");
  int cache_size = atoi(argv[2]);
  int nways = atoi(argv[3]);
  int block_size = atoi(argv[4]);

  // instantiate the cache
  cache_t cache;
  init_cache(&cache, cache_size, block_size, nways);
  
  //initialize stats
  stats_t stats;
  init_stats(&stats);
	
  // parse the trace, performing the accesses on the cache
  char type;
  unsigned address;
  char line[LINE_LENGTH];
  while (!feof(trace_file)) { // while we haven't gotten to the end
    char *read_line = fgets(line, LINE_LENGTH, trace_file);
    if (read_line == NULL) {
      continue;    // if we hit the end of file, feof will be true
    }

    // parse the line of the trace file to extract the address
    sscanf(line, "%c %x", &type, &address);

    // check to see if that address hits in the cache, and if it
    // doesn't then bring that line into the cache.
    bool hit = find_block_and_update_lru(&cache, address,&stats);
	 if (!hit){
      fill_cache_with_block(&cache, address);
    }

    // print verbose output if requested.
    if (verbose) {
      printf("%s %x\n", hit ? "HIT " : "MISS", address);
    }
  }

  // output final statistics
  printf("Reached end of file\n");
  printf("hits: %d, accesses: %d, hit rate: %.2f\n", 
	 stats.hits, stats.accesses, (100.0 * stats.hits)/stats.accesses);
}
