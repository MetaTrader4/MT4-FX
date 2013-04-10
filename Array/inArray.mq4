
/**
 * Check if an integer value in the array.
 */
bool inArrayInt(int val, int arr[], int total = 0)
{
   int arr_size = ArraySize(arr);
   if (total > 0 && total > arr_size)
   {
      arr_size = total;
   }
   for (int i = 0; i < arr_size; i++)
   {
      if (arr[i] == val)
      {
         return(true);
      }
   }

   return(false);
}

/**
 * Check if an string value in the array.
 */
bool inArrayString(string val, string arr[], int total = 0)
{
   int arr_size = ArraySize(arr);
   if (total > 0 && total > arr_size)
   {
      arr_size = total;
   }
   for (int i = 0; i < arr_size; i++)
   {
      if (arr[i] == val)
      {
         return(true);
      }
   }

   return(false);
}


//---------- 2.x ----------//
Return the first occurence index.

/**
 * Check if an integer value in the array.
 *
 * @return int The first occurence of the val in array or -1 if not exist.
 */
int inArrayInt(int val, int arr[], int total = 0)
{
   int arr_size = ArraySize(arr);
   if (arr_size == 0) return(-1);
   
   if (total > 0 && total > arr_size)
   {
      arr_size = total;
   }
   for (int i = 0; i < arr_size; i++)
   {
      if (arr[i] == val)
      {
         return(i);
      }
   }

   return(-1);
}

/**
 * Check if a string value in the array.
 *
 * @return int The first occurence of the val in array or -1 if not exist.
 */
int inArrayString(string val, string arr[], int total = 0)
{
   int arr_size = ArraySize(arr);
   if (arr_size == 0) return(-1);
   
   if (total > 0 && total > arr_size)
   {
      arr_size = total;
   }
   for (int i = 0; i < arr_size; i++)
   {
      if (arr[i] == val)
      {
         return(i);
      }
   }

   return(-1);
}

//---------- 3.x ----------//
Give an additional parameter to set the start point.
Useful for looping find occurrence.

Should Wrap arrayIndex to return bool.