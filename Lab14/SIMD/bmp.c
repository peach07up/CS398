/* Implementation of operations defined in bmp.h
 *
 * You do NOT need to understand the code in this file in order to
 * solve the MP. Please refer to the file "sample.c" for an example of
 * how to use the datatypes and operations on BMP files.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bmp.h"

typedef struct __attribute__((gcc_struct, packed)) {
	char magicNumber[2];
	uint32_t fileSize;
	uint32_t reserved;
	uint32_t offset;
} bmp_header_t;

typedef struct  __attribute__((gcc_struct, packed)) {
	uint32_t headerSize;
	uint32_t width;
	uint32_t height;
	uint16_t numPlanes;
	uint16_t bitsPerPixel;
	uint32_t compressionMethod;
	uint32_t imageSize;
	uint32_t hRes;
	uint32_t vRes;
	uint32_t numPaletteColors;
	uint32_t numImportantColors;
} dib_header_t;

#define HEADER_SIZE (sizeof(bmp_header_t) + sizeof(dib_header_t))

// typedef'd in header
struct bmp {
	bmp_header_t bmpHeader;
	dib_header_t dibHeader;
	uint32_t rowPadding;
	// these go bottom to top, left to right
	pixel_t *pixels;
} __attribute__((gcc_struct, packed));


bmp_t *createBmp(uint32_t width, uint32_t height) {
	if (height > INT32_MAX) {
		// negative heights are interpreted as top to bottom bitmaps,
		// and I don't want to handle that
		return NULL;
	}

	bmp_t *bmp = malloc(sizeof(bmp_t));
	if (bmp == NULL) {
		return NULL;
	}

	bmp->pixels = malloc(width * height * sizeof(pixel_t));
	if (bmp->pixels == NULL) {
		free(bmp);
		return NULL;
	}

	// each row is padded to a multiple of 4 bytes
	bmp->rowPadding = -(width * sizeof(pixel_t)) & 3;
	uint32_t imageSize = height * (width * sizeof(pixel_t) + bmp->rowPadding);

	strcpy(bmp->bmpHeader.magicNumber, "BM");
	bmp->bmpHeader.fileSize = HEADER_SIZE + imageSize;
	bmp->bmpHeader.reserved = 0;
	bmp->bmpHeader.offset = HEADER_SIZE;

	bmp->dibHeader.headerSize = sizeof(dib_header_t);
	bmp->dibHeader.width = width;
	bmp->dibHeader.height = height;
	bmp->dibHeader.numPlanes = 1;
	bmp->dibHeader.bitsPerPixel = 24;
	bmp->dibHeader.compressionMethod = 0;
	bmp->dibHeader.imageSize = imageSize;
	bmp->dibHeader.hRes = 0;
	bmp->dibHeader.vRes = 0;
	bmp->dibHeader.numPaletteColors = 0;
	bmp->dibHeader.numImportantColors = 0;

	return bmp;
}


bmp_t *openBmp(const char *name) {
	FILE *file = fopen(name, "rb");
	if (file == NULL) {
		return NULL;
	}

	bmp_t *bmp = malloc(sizeof(bmp_t));
	if (bmp == NULL) {
		fclose(file);
		return NULL;
	}

	size_t count = fread(bmp, HEADER_SIZE, 1, file);
	if (count != 1 || strcmp(bmp->bmpHeader.magicNumber, "BM") != 0 ||
			bmp->bmpHeader.offset != HEADER_SIZE || 
			bmp->dibHeader.headerSize != sizeof(dib_header_t) ||
			bmp->dibHeader.bitsPerPixel != 24 ||
			bmp->dibHeader.compressionMethod != 0) {
		// unsupported file format
		free(bmp);
		fclose(file);
		return NULL;
	}

	uint32_t width = bmp->dibHeader.width;
	uint32_t height = bmp->dibHeader.height;
	if (height > INT32_MAX) {
		// negative heights are interpreted as top to bottom bitmaps,
		// and I don't want to handle that
		free(bmp);
		fclose(file);
		return NULL;
	}

	bmp->rowPadding = -(width * sizeof(pixel_t)) & 3;
	bmp->pixels = malloc(width * height * sizeof(pixel_t));
	if (bmp->pixels == NULL) {
		free(bmp);
		fclose(file);
		return NULL;
	}

	pixel_t *pixels = bmp->pixels;
	for (uint32_t y = 0; y < height; ++y) {
		// assuming nothing goes wrong with reading the rest of the file
		pixels += fread(pixels, sizeof(pixel_t), width, file);
		// skip padding
		fseek(file, bmp->rowPadding, SEEK_CUR);
	}

	fclose(file);
	return bmp;
}

uint32_t getWidth(bmp_t *bmp) {
	return bmp->dibHeader.width;
}

uint32_t getHeight(bmp_t *bmp) {
	return bmp->dibHeader.height;
}

pixel_t getPixel(bmp_t *bmp, uint32_t x, uint32_t y) {
	pixel_t p = { 0, 0, 0 };

	uint32_t width = bmp->dibHeader.width;
	uint32_t height = bmp->dibHeader.height;
	if (x < width && y < height) {
		p = bmp->pixels[(height - 1 - y) * width + x];
	}

	return p;
}

void putPixel(bmp_t *bmp, pixel_t p, uint32_t x, uint32_t y) {
	uint32_t width = bmp->dibHeader.width;
	uint32_t height = bmp->dibHeader.height;
	if (x < width && y < height) {
		bmp->pixels[(height - 1 - y) * width + x] = p;
	}
}


void writeBmp(bmp_t *bmp, const char *name) {
	FILE *file = fopen(name, "wb");
	if (file == NULL) {
		return;
	}

	fwrite(bmp, HEADER_SIZE, 1, file);
	pixel_t *pixels = bmp->pixels;
	uint32_t paddingBytes = 0;
	uint32_t width = bmp->dibHeader.width;
	uint32_t height = bmp->dibHeader.height;
	for (uint32_t y = 0; y < height; ++y) {
		pixels += fwrite(pixels, sizeof(pixel_t), width, file);
		fwrite(&paddingBytes, 1, bmp->rowPadding, file);
	}
	fclose(file);
}

void closeBmp(bmp_t *bmp) {
	free(bmp->pixels);
	free(bmp);
}
