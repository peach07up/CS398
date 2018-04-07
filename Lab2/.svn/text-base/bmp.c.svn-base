/* Implementation of operations defined in bmp.h
 *
 * You do NOT need to understand the code in this file in order to
 * solve the MP. Please refer to the file "sample.c" for an example of
 * how to use the datatypes and operations on BMP files.
*/

#include "bmp.h"

BMPfile openBMPfile(char name[])
{
	BMPfile f;
	f.file = fopen(name, "r+b");	/* Open binary file for read/write */

	if(f.file != NULL)
	{
		fseek(f.file, 10, SEEK_SET);	/* Skip header information */
		fread(&(f.offset), sizeof(unsigned int), 1, f.file); /* Read offset */
		fseek(f.file, 4, SEEK_CUR);	/* Skip size information */
		fread(&(f.width), sizeof(int), 1, f.file); /* Read image width */
		fread(&(f.height), sizeof(int), 1, f.file); /* Read image height */
	}

	return f;
}

int getWidth(BMPfile bmpfile)
{
	return bmpfile.width;
}

int getHeight(BMPfile bmpfile)
{
	return bmpfile.height;
}

pixel getPixel(BMPfile bmpfile, int x, int y)
{
	pixel p;

	if(bmpfile.file != NULL && x >=0 && x < bmpfile.width &&
	y >=0 && y < bmpfile.height)	/* Boundary check */
	{
		fseek(bmpfile.file,
		bmpfile.offset + (bmpfile.width * 3 + (-(bmpfile.width * 3) & 3)) * (bmpfile.height - 1 - y) + x * 3,
		SEEK_SET);	/* Read from appropriate location */

		/* Read blue, green and red components */
		fread(&(p.blue), sizeof(unsigned char), 1, bmpfile.file);
		fread(&(p.green), sizeof(unsigned char), 1, bmpfile.file);
		fread(&(p.red), sizeof(unsigned char), 1, bmpfile.file);
	}

	return p;
}

void putPixel(BMPfile bmpfile, pixel newPixel, int x, int y)
{
	if(bmpfile.file != NULL && x >=0 && x < bmpfile.width &&
	y >=0 && y < bmpfile.height)	/* Boundary check */
	{
		fseek(bmpfile.file,
		bmpfile.offset + (bmpfile.width * 3 + (-(bmpfile.width * 3) & 3)) * (bmpfile.height - 1 - y) + x * 3,
		SEEK_SET);	/* Write to appropriate location */

		/* Write blue, green and red components */
		fwrite(&(newPixel.blue), sizeof(unsigned char), 1, bmpfile.file);
		fwrite(&(newPixel.green), sizeof(unsigned char), 1, bmpfile.file);
		fwrite(&(newPixel.red), sizeof(unsigned char), 1, bmpfile.file);
	}
}

void closeBMPfile(BMPfile bmpfile)
{
	if(bmpfile.file != NULL)
	{
		fclose(bmpfile.file);
	}
}
