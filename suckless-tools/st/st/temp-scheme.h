 const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#332d29", /* black   */
  [1] = "#8c644c", /* red     */
  [2] = "#746c48", /* green   */
  [3] = "#908a66", /* yellow  */
  [4] = "#646a6d", /* blue    */
  [5] = "#605655", /* magenta */
  [6] = "#4b5c5e", /* cyan    */
  [7] = "#504339", /* white   */

  /* 8 bright colors */
  [8]  = "#817267", /* black   */
  [9]  = "#9f7155", /* red     */
  [10] = "#857b52", /* green   */
  [11] = "#9c956e", /* yellow  */
  [12] = "#71777a", /* blue    */
  [13] = "#656565", /* magenta */
  [14] = "#556d70", /* cyan    */
  [15] = "#9a875f", /* white   */

  /* special colors */
  [256] = "#181512", /* background */
  [257] = "#bea492", /* foreground */
};

/*
 * Default colors (colorname index)
 * foreground, background, cursor
 */
 unsigned int defaultfg = 257;
 unsigned int defaultbg = 256;
 unsigned int defaultcs = 257;
