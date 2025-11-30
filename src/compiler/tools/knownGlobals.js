export const functions = new Set([
  //Dialog
  'alert',
  'confirm',
  'prompt',
  //Timers
  'setTimeout',
  'setInterval',
  'clearTimeout',
  'clearInterval',
  //Network
  'fetch',
  //URI encoding
  'encodeURI',
  'decodeURI',
  'encodeURIComponent',
  'decodeURIComponent',
  //Data encoding
  'atob',
  'btoa',
  //Task scheduling
  'queueMicrotask'
]);

export const classes = new Set([
  'AbortController',
  'AbortSignal',
  'Headers',
  'Request',
  'Response',
  'URL',
  'URLSearchParams',
  'TextEncoder',
  'TextDecoder'
])

export const objects = new Set([
  'console',
  'crypto',
  'document',
  'location',
  'navigator',
  'window'
])