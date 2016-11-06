export const ADD_DIRECTORY = 'ADD_DIRECTORY'

let nextDirectoryId = 0;

export function addDirectory(text) {
   return {
      type: ADD_DIRECTORY,
      id: nextDirectoryId++,
      text
   };
}
