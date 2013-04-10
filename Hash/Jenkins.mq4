
/**
 * Hash function.
 *
 * @see http://www.burtleburtle.net/bob/hash/doobs.html
 */
int jenkinsHash(string key)
{
    int magic = 0;

    for (int i = 0; i < StringLen(key); i++)
    {
        magic += StringGetChar(key, i);
        magic += (magic << 10);
        magic ^= (magic >> 6);
    }

    magic += (magic << 3);
    magic ^= (magic >> 11);
    magic += (magic << 15);
    magic = MathAbs(magic);

    return(magic);
}